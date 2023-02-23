#include "darknet.h"
#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#if defined(_MSC_VER) && defined(_DEBUG)
#include <crtdbg.h>
#endif

#include "parser.h"
#include "utils.h"
#include "dark_cuda.h"
#include "blas.h"
#include "connected_layer.h"

//extern void run_detector(int argc, char **argv);
extern void run_classifier(int argc, char **argv);

int main(int argc, char **argv)
{
#ifdef _DEBUG
	_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF);
    printf(" _DEBUG is used \n");
#endif

#ifdef DEBUG
    printf(" DEBUG=1 \n");
#endif

	int i;
	for (i = 0; i < argc; ++i) {
		if (!argv[i]) continue;
		strip_args(argv[i]);
	}

    //test_resize("data/bad.jpg");
    //test_box();
    //test_convolutional_layer();
    if(argc < 2){
        fprintf(stderr, "usage: %s <function>\n", argv[0]);
        return 0;
    }
    gpu_index = find_int_arg(argc, argv, "-i", 0);
    if(find_arg(argc, argv, "-nogpu")) {
        gpu_index = -1;
        printf("\n Currently Darknet doesn't support -nogpu flag. If you want to use CPU - please compile Darknet with GPU=0 in the Makefile, or compile darknet_no_gpu.sln on Windows.\n");
        exit(-1);
    }

#ifndef GPU
    gpu_index = -1;
    printf(" GPU isn't used \n");
    init_cpu();
#else   // GPU
    if(gpu_index >= 0){
        cuda_set_device(gpu_index);
        //CHECK_CUDA(cudaSetDeviceFlags(cudaDeviceScheduleBlockingSync));
	CHECK_CUDA(cudaSetDeviceFlags(cudaDeviceScheduleSpin));
    }

    show_cuda_cudnn_info();
    cuda_debug_sync = find_arg(argc, argv, "-cuda_debug_sync");

#ifdef CUDNN_HALF
    printf(" CUDNN_HALF=1 \n");
#endif  // CUDNN_HALF

#endif  // GPU

    show_opencv_info();

/*    if (0 == strcmp(argv[1], "detector")){*/
/*        run_detector(argc, argv);*/
/*    } else */
	if (0 == strcmp(argv[1], "classifier")){
        run_classifier(argc, argv);
    }
      else {
        fprintf(stderr, "Not an option: %s\n", argv[1]);
    }
    return 0;
}
