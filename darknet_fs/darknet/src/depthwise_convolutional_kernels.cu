#include "cuda_runtime.h"
#include "curand.h"
#include "cublas_v2.h"

#include "depthwise_convolutional_layer.h"
#include "batchnorm_layer.h"
#include "gemm.h"
#include "blas.h"
#include "im2col.h"
#include "col2im.h"
#include "utils.h"
#include "cuda.h"

__global__ void DepthwiseConv2dGPUKernelNCHW(
	const float* input,const int in_rows, const int in_cols, const int in_depth,
	const float* filter, const int filter_rows, const int filter_cols,
	const int stride,const int pad_rows,const int pad_cols,
	const int out_rows,const int out_cols,const int out_depth,
	float* output, int num_outputs,int offset) {

	int thread_id = blockIdx.x * blockDim.x + offset +  threadIdx.x;
	//int thread_id = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
	if (thread_id >= num_outputs) return;



	const int OC = thread_id % out_cols;//width
	const int OR = (thread_id / out_cols) % out_rows;//height
	const int OD = (thread_id / out_cols / out_rows) % out_depth;//channel
	const int OB = thread_id / out_cols / out_rows / out_depth;//batch size

	const int in_d = OD ;
	const int input_offset_temp = (OB * in_depth + in_d) * (in_rows * in_cols);
	const int input_row_start = OR * stride - pad_rows;
	const int input_col_start = OC * stride - pad_cols;
	const int input_row_end = input_row_start + filter_rows;
	const int input_col_end = input_col_start + filter_cols;

	float sum = 0;
	if (input_row_start >= 0 && input_col_start >= 0 &&
		input_row_end < in_rows && input_col_end < in_cols)
	{
		#pragma unroll
			for (int f_r = 0; f_r < filter_rows; ++f_r) {
				const int in_r = input_row_start + f_r;
				#pragma unroll
				for (int f_c = 0; f_c < filter_cols; ++f_c) {
					const int in_c = input_col_start + f_c;

					const int input_offset =
						(input_offset_temp)+(in_r * in_cols) + in_c;
					const int filter_offset =f_c + filter_cols * f_r +OD*filter_cols*filter_rows;
					sum += (*(input + input_offset)) * (*(filter + filter_offset));
				}
			}
		}
	else {
		#pragma unroll
		for (int f_r = 0; f_r < filter_rows; ++f_r) {
				const int in_r = input_row_start + f_r;
				#pragma unroll
				for (int f_c = 0; f_c < filter_cols; ++f_c) {
					const int in_c = input_col_start + f_c;

					if (in_r >= 0 && in_r < in_rows && in_c >= 0 && in_c < in_cols) {
						//const int in_c = input_col_start + f_c;

						const int input_offset =
							(input_offset_temp)+(in_r * in_cols) + in_c;

						const int filter_offset = f_c + filter_cols * f_r + OD*filter_cols*filter_rows;
						sum += (*(input + input_offset)) * (*(filter + filter_offset));
					}
				}
			}
		}

	output[thread_id] = sum;

}

__global__ void DepthwiseConv2dBackpropFilterGPUKernelNCHW(const float* out_backprop,
			const int stride, const int pad_rows, const int pad_cols, const int out_rows, const int out_cols, const int out_depth,
			const float* input, const int in_rows, const int in_cols, const int in_depth,
			float* filter_backprop, const int filter_rows, const int filter_cols,
			int num_out_backprop) {

	int thread_id = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
	if (thread_id >= num_out_backprop) return;


	const int out_c = thread_id % out_cols;
	const int out_r = (thread_id / out_cols) % out_rows;
	const int out_d = (thread_id / out_cols / out_rows) % out_depth;

	const int b = thread_id / out_depth / out_cols / out_rows;
	const int in_d = out_d;


	const int in_r_start = out_r * stride - pad_rows;
	const int in_c_start = out_c * stride - pad_cols;
	const int in_r_end = in_r_start + filter_rows;
	const int in_c_end = in_c_start + filter_cols;

	const int out_backprop_offset = (b * out_depth * out_rows * out_cols) +
				(out_d * out_rows * out_cols) +(out_r * out_cols) + (out_c);

	const float out_bp = *(out_backprop + out_backprop_offset);
	if (in_r_start >= 0 && in_c_start >= 0 && in_r_end < in_rows &&in_c_end < in_cols) {
		#pragma unroll 
		for (int f_r = 0; f_r < filter_rows; ++f_r) {
			const int in_r = in_r_start + f_r;
			const int input_offset_temp = (b * in_depth * in_rows * in_cols) +
						(in_d * in_rows * in_cols) +(in_r * in_cols);

			#pragma unroll 
			for (int f_c = 0; f_c < filter_cols; ++f_c) {
						const int in_c = in_c_start + f_c;
						const int input_offset = input_offset_temp + in_c;
						float partial_sum = (*(input + input_offset)) * out_bp;
						float* addr = filter_backprop + f_c + filter_cols * f_r + out_d*filter_cols*filter_rows;
						atomicAdd(addr, partial_sum);
					}
				}
			}
			else {
				#pragma unroll 
				for (int f_r = 0; f_r < filter_rows; ++f_r) {
					const int in_r = in_r_start + f_r;
					const int input_offset_temp = (b * in_depth * in_rows * in_cols) +(in_d * in_rows * in_cols) +(in_r * in_cols);
					#pragma unroll 
					for (int f_c = 0; f_c < filter_cols; ++f_c) {
						const int in_c = in_c_start + f_c;
						if (in_r >= 0 && in_r < in_rows && in_c >= 0 && in_c < in_cols) {
							const int input_offset = input_offset_temp + in_c;
							float partial_sum = (*(input + input_offset)) * out_bp;
							float* addr =filter_backprop + f_c + filter_cols * f_r + out_d*filter_cols*filter_rows;
							atomicAdd(addr, partial_sum);
						}
					}
				}

		}
	}



__global__ void DepthwiseConv2dBackpropInputGPUKernelNCHW(
		const float* out_backprop, const int out_rows, const int out_cols, const int out_depth,
		const float* filter, const int filter_rows, const int filter_cols,
		float* in_backprop, const int in_rows, const int in_cols, const int in_depth,
		const int stride, const int pad_rows, const int pad_cols,int num_in_backprop)
{
		int thread_id = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
		if (thread_id >= num_in_backprop) return;

		const int in_c = thread_id % in_cols;
		const int in_r = (thread_id / in_cols) % in_rows;
		const int in_d = (thread_id / in_cols / in_rows) % in_depth;
		const int b = thread_id / in_depth / in_cols / in_rows;

		float sum = 0;


		const int out_r_start =max(0, (in_r - filter_rows + pad_rows + stride) / stride);
		const int out_r_end = min(out_rows - 1, (in_r + pad_rows) / stride);
		const int out_c_start =
			max(0, (in_c - filter_cols + pad_cols + stride) / stride);
		const int out_c_end = min(out_cols - 1, (in_c + pad_cols) / stride);


		#pragma unroll 
			for (int out_r = out_r_start; out_r <= out_r_end; ++out_r) {
				const int f_r = in_r + pad_rows - out_r * stride;


				for (int out_c = out_c_start; out_c <= out_c_end; ++out_c) {
					const int f_c = in_c + pad_cols - out_c * stride;
					const int filter_offset = f_c + filter_cols * f_r + in_d *filter_cols*filter_rows;

					const int out_backprop_offset =
						(b * out_depth * out_rows * out_cols) +
						(in_d * out_rows * out_cols) + (out_r * out_cols) + (out_c);

					sum += (*(out_backprop + out_backprop_offset)) *
						(*(filter + filter_offset));
				}
			}
		in_backprop[thread_id] = sum;

}


void forward_depthwise_convolutional_layer_gpu(depthwise_convolutional_layer l, network_state state)
{
	//cuda_pull_array(l.output_gpu, l.output, l.c*l.out_h*l.out_w);//add by hjimce for debug
    fill_ongpu(l.outputs*l.batch, 0, l.output_gpu, 1);

	int size = l.out_h*l.out_w*l.batch*l.n;

	int num_blocks = get_number_of_blocks(size, BLOCK);
	int extra_blocks = num_blocks %4;
	int stream_id = 0;
	num_blocks = num_blocks /4;
	int loopcount = 0;
	int offset = 0;
	cudaDeviceSynchronize();
	for (loopcount = 0; loopcount < num_blocks;loopcount++)
	{
		offset = loopcount * 4*BLOCK;
		stream_id = loopcount%4;
		DepthwiseConv2dGPUKernelNCHW <<<4, BLOCK,0,get_cuda_stream_32(stream_id) >>>(state.input,l.h,l.w,l.c,l.weights_gpu, l.size, l.size,l.stride, l.pad, l.pad,l.out_h, l.out_w, l.n,l.output_gpu, size,offset);	
	}
	cudaDeviceSynchronize();
	if(extra_blocks)
	{
		stream_id = loopcount%4;
		offset = loopcount * 4*BLOCK;
		DepthwiseConv2dGPUKernelNCHW <<<extra_blocks, BLOCK,0,get_cuda_stream_32(stream_id) >>>(state.input,l.h,l.w,l.c,l.weights_gpu, l.size, l.size,l.stride, l.pad, l.pad,l.out_h, l.out_w, l.n,l.output_gpu, size,offset);
	}	
	


	/*DepthwiseConv2dGPUKernelNCHW << <4, BLOCK,0,get_cuda_stream_32(stream_id) >> >(state.input,l.h,l.w,l.c,l.weights_gpu, l.size, l.size,l.stride, l.pad, l.pad,l.out_h, l.out_w, l.n,l.output_gpu, size,offset);*/
	check_error(cudaPeekAtLastError());
    /*int i;
    int k = l.size*l.size;
    int n = l.out_w*l.out_h;

	for (int b = 0; b < l.batch; ++b) {
		for (int c = 0; c<l.c; c++)
		{

			float *aoffset = l.weights_gpu + c*l.size*l.size;
			float *boffset = state.workspace;
			float *coffset = l.output_gpu + c*l.out_h*l.out_w + b*l.n*l.out_h*l.out_w;
			float *intput_offset = state.input + c*l.h*l.w + b*l.c*l.h*l.w;
			//im2col_gpu_ext(intput_offset, 1, l.h, l.w,
			//	l.size, l.stride, l.pad, boffset);

			 im2col_gpu_ext(intput_offset,          // input
                   	1,         // input channels
                    l.h, l.w,               // input size (h, w)
                    l.size, l.size,         // kernel size (h, w)
                    l.pad, l.pad,   // padding (h, w)
                    l.stride, l.stride,     // stride (h, w)
                    l.dilation, l.dilation, // dilation (h, w)
                    boffset);       // workspace			
		 gemm_ongpu(0, 0, 1, n, k, 1, aoffset, k, boffset, n, 1, coffset, n);
			
		}
	}


	check_error(cudaPeekAtLastError());*/
    if (l.batch_normalize) {
        forward_batchnorm_layer_gpu(l, state);
    } else {
        add_bias_gpu(l.output_gpu, l.biases_gpu, l.batch, l.n, l.out_w*l.out_h);
    }

	int m = l.n;
    activate_array_ongpu(l.output_gpu, l.outputs*l.batch, l.activation);


	//cuda_pull_array(l.output_gpu, l.output, l.c*l.out_h*l.out_w);//add by hjimce for debug

	

}


void backward_depthwise_convolutional_layer_gpu(depthwise_convolutional_layer l, network_state state)
{

    constrain_ongpu(l.outputs*l.batch, 1, l.delta_gpu, 1);
    gradient_array_ongpu(l.output_gpu, l.outputs*l.batch, l.activation, l.delta_gpu);


    if(l.batch_normalize){
        backward_batchnorm_layer_gpu(l, state);
    } else {
        backward_bias_gpu(l.bias_updates_gpu, l.delta_gpu, l.batch, l.n, l.out_w*l.out_h);
    }
    float *original_input = state.input;

	//cuda_pull_array(net.delta_gpu, net.delta, l.batch*l.c*l.h*l.w);
    /*int m = l.n;
    int n = l.size*l.size;
    int k = l.out_w*l.out_h;
	//pull_depthwise_convolutional_layer(l);//add by hjimce for debug

	for (int b = 0; b < l.batch; ++b) {
		for (int c = 0; c<l.c; c++)
		{



			float *aoffset = l.delta_gpu + c*l.out_h*l.out_w + b*l.n*l.out_h*l.out_w;
			float *boffset = net.workspace;
			float *coffset = l.weight_updates_gpu + c*l.size*l.size;


			float *im = net.input_gpu + c*l.h*l.w + b*l.c*l.h*l.w;


			im2col_gpu(im, 1, l.h, l.w,
				l.size, l.stride, l.pad, boffset);
			gemm_gpu(0, 1, 1, n, k, 1, aoffset, k, boffset, k, 1, coffset, n);


			if (net.delta_gpu) {
				aoffset = l.weights_gpu + c*l.size*l.size;
				boffset = l.delta_gpu + c*l.out_h*l.out_w + b*l.n*l.out_h*l.out_w;
				coffset = net.workspace;

				gemm_gpu(1, 0, n, k, 1, 1, aoffset, n, boffset, k, 0, coffset, k);

				col2im_gpu(net.workspace, 1, l.h, l.w, l.size, l.stride, l.pad, net.delta_gpu + c*l.h*l.w + b*l.n*l.h*l.w);
			}


		}
	}*/
	
	int out_size= l.out_h*l.out_w*l.batch*l.n;
	DepthwiseConv2dBackpropFilterGPUKernelNCHW << <cuda_gridsize(out_size), BLOCK >> > (
		l.delta_gpu, l.stride, l.pad, l.pad, l.out_h, l.out_w, l.c,
		state.input, l.h, l.w, l.n,
		l.weight_updates_gpu, l.size, l.size,
		out_size);
	if (state.delta)
	{
		int in_size = l.h*l.w*l.batch*l.n;
		DepthwiseConv2dBackpropInputGPUKernelNCHW << <cuda_gridsize(in_size), BLOCK >> > (
			l.delta_gpu, l.out_h, l.out_w, l.c,
			l.weights_gpu, l.size, l.size,
			state.delta, l.h, l.w, l.c,
			l.stride, l.pad, l.pad, in_size);

	}
	//cuda_pull_array(net.delta_gpu, net.delta, l.batch*l.c*l.h*l.w);
	//pull_depthwise_convolutional_layer(l);//add by hjimce for debug

//#endif
}
void pull_depthwise_convolutional_layer(depthwise_convolutional_layer layer)
{
   /* cuda_pull_array(layer.weights_gpu, layer.weights, layer.n*layer.size*layer.size);
    cuda_pull_array(layer.biases_gpu, layer.biases, layer.n);
    cuda_pull_array(layer.weight_updates_gpu, layer.weight_updates, layer.n*layer.size*layer.size);
    cuda_pull_array(layer.bias_updates_gpu, layer.bias_updates, layer.n);
    if (layer.batch_normalize){
        cuda_pull_array(layer.scales_gpu, layer.scales, layer.n);
        cuda_pull_array(layer.rolling_mean_gpu, layer.rolling_mean, layer.n);
        cuda_pull_array(layer.rolling_variance_gpu, layer.rolling_variance, layer.n);
    }*/
}

void push_depthwise_convolutional_layer(depthwise_convolutional_layer layer)
{
    /*cuda_push_array(layer.weights_gpu, layer.weights, layer.n*layer.size*layer.size);
    cuda_push_array(layer.biases_gpu, layer.biases, layer.n);
    cuda_push_array(layer.weight_updates_gpu, layer.weight_updates, layer.n*layer.size*layer.size);
    cuda_push_array(layer.bias_updates_gpu, layer.bias_updates, layer.n);
    if (layer.batch_normalize){
        cuda_push_array(layer.scales_gpu, layer.scales, layer.n);
        cuda_push_array(layer.rolling_mean_gpu, layer.rolling_mean, layer.n);
        cuda_push_array(layer.rolling_variance_gpu, layer.rolling_variance, layer.n);
    }*/
}

void update_depthwise_convolutional_layer_gpu(layer l, update_args a)
{
    float learning_rate = a.learning_rate*l.learning_rate_scale;
    float momentum = a.momentum;
    float decay = a.decay;
    int batch = a.batch;

    int size = l.size*l.size*l.c;

    if(a.adam){
        adam_update_gpu(l.weights_gpu, l.weight_updates_gpu, l.m_gpu, l.v_gpu, a.B1, a.B2, a.eps, decay, learning_rate, size, batch, a.t);
        adam_update_gpu(l.biases_gpu, l.bias_updates_gpu, l.bias_m_gpu, l.bias_v_gpu, a.B1, a.B2, a.eps, decay, learning_rate, l.n, batch, a.t);
        if(l.scales_gpu){
            adam_update_gpu(l.scales_gpu, l.scale_updates_gpu, l.scale_m_gpu, l.scale_v_gpu, a.B1, a.B2, a.eps, decay, learning_rate, l.n, batch, a.t);
        }

    }else{
        axpy_ongpu(size, -decay*batch, l.weights_gpu, 1, l.weight_updates_gpu, 1);
        axpy_ongpu(size, learning_rate/batch, l.weight_updates_gpu, 1, l.weights_gpu, 1);
        scal_ongpu(size, momentum, l.weight_updates_gpu, 1);

        axpy_ongpu(l.n, learning_rate/batch, l.bias_updates_gpu, 1, l.biases_gpu, 1);
        scal_ongpu(l.n, momentum, l.bias_updates_gpu, 1);

        if(l.scales_gpu){
            axpy_ongpu(l.n, learning_rate/batch, l.scale_updates_gpu, 1, l.scales_gpu, 1);
            scal_ongpu(l.n, momentum, l.scale_updates_gpu, 1);
        }

    }

}


