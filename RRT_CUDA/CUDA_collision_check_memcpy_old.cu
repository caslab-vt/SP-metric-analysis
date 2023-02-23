#include <cstdlib>
#include <iostream>
#include <cassert>
#include <vector>
#include <ctime>
#include <chrono>
#include <math.h>
#include <unistd.h>

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <algorithm>
#include <cmath>
#include <fstream>
#include <limits>
#include "rrt_memcpy.hpp"
#include "rfunc.h"

#define BLOCK 1024

static cudaStream_t streamsArray[4];
static int streamInit[4] = { 0 };

//	ofstream myfile1;
//	  myfile1.open ("rrtGPU_time.txt");

cudaStream_t get_cuda_stream_32(int i) {
    if (!streamInit[i]) {
	cudaError_t status = cudaStreamCreateWithFlags(&streamsArray[i],cudaStreamNonBlocking);
        streamInit[i] = 1;
    }
    return streamsArray[i];
}

void Destroy_stream()
{
    for(int i =0;i<4;i++)
    {
	if (streamInit[i]) {
    		cudaStreamDestroy(streamsArray[i]);
   		streamInit[i] = 0;
	}
    }
}

double get_time_point() {
    std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(current_time.time_since_epoch()).count();
}


int get_number_of_blocks(int array_size, int block_size)
{
    return array_size / block_size + ((array_size % block_size > 0) ? 1 : 0);
}

__global__ void distance_cal_cuda(vertex* vertex_cuda_ptr,float* new_vertex_cuda,float* distances,int offset)
{
	int idx = blockIdx.x * blockDim.x + offset +  threadIdx.x;
	float current_vertex[2] = {vertex_cuda_ptr[idx].x,vertex_cuda_ptr[idx].y};

	float dx = current_vertex[0] - new_vertex_cuda[0];
	float dy = current_vertex[1] - new_vertex_cuda[1];
	
	distances[idx] = sqrt((dx*dx) + (dy * dy));

}

__device__ bool overlapping_check_dev(float p0, float p3, float p1, float p2)
{
	if (p0 > p3)
	{
	   p0 = p0+p3;
	   p3 = p0 - p3;
	   p0 = p0 - p3;
	}
	if (p1 > p2)
	{
	   p1 = p1+p2;
	   p2 = p1 - p2;
	   p1 = p1 - p2;
	}
	float max_p00_p10 = p0 > p1 ?p0 : p1;
	float min_p30_p20 = p3 < p2 ?p3 : p2;
	return max_p00_p10 <= min_p30_p20;
	
}

__global__ void polygon_collision_check_dev(Polygon* polygons_ ,float* p0,int offset)
{
	int i = blockIdx.x * blockDim.x + offset + threadIdx.x;
	
	__shared__ int flag;
	if(threadIdx.x == 0)
		flag =0;
	__syncthreads();
	
	if(flag == 1 || p0[4] == 1)
	{
		return;
	}
	float p1[2];
  	float p2[2];

	p1[0] = polygons_[i].x1;
	p1[1] = polygons_[i].y1;
  	p2[0] = polygons_[i].x1;
	p2[1] = polygons_[i].y2;

	float cross_p0_p1_p2 = (((p1[0] - p0[0]) * (p2[1] - p0[1])) - ((p2[0] - p0[0]) * (p1[1] - p0[1])));
	float cross_p3_p1_p2 = (((p1[0] - p0[2]) * (p2[1] - p0[3])) - ((p2[0] - p0[2]) * (p1[1] - p0[3])));
	float cross_p1_p0_p3 = (((p0[0] - p1[0]) * (p0[3] - p1[1])) - ((p0[2] - p1[0]) * (p0[1] - p1[1])));
	float cross_p2_p0_p3 = (((p0[0] - p2[0]) * (p0[3] - p2[1])) - ((p0[2] - p2[0]) * (p0[1] - p2[1])));
	int sign_cross_p0_p1_p2 =  cross_p0_p1_p2 >=0 ? cross_p0_p1_p2 ? 1 :0 :-1;
	int sign_cross_p3_p1_p2 =  cross_p3_p1_p2 >=0 ? cross_p3_p1_p2 ? 1 :0 :-1;
	int sign_cross_p1_p0_p3 =  cross_p1_p0_p3 >=0 ? cross_p1_p0_p3 ? 1 :0 :-1;
	int sign_cross_p2_p0_p3 =  cross_p2_p0_p3 >=0 ? cross_p2_p0_p3 ? 1 :0 :-1;	

	bool overlapping_check_x = overlapping_check_dev(p0[0],p0[2],p1[0],p2[0]);
	bool overlapping_check_y = overlapping_check_dev(p0[1],p0[3],p1[1],p2[1]);
	
	if((cross_p0_p1_p2 == 0) &&  (cross_p3_p1_p2 == 0)) // Lines are colinear
	{
		if (overlapping_check_x || overlapping_check_y) //lines are overlapping
		{
			flag = 1;
			p0[4] = 1;
			return;	
		}
			
	}
	
	if((sign_cross_p0_p1_p2 != sign_cross_p3_p1_p2) && (sign_cross_p1_p0_p3 != sign_cross_p2_p0_p3))    //lines are intersecting
	{
		flag = 1;
		p0[4] = 1;
		return;	
	}
	if(flag == 1 || p0[4] == 1)
	{
		return;
	}
	p1[0] = polygons_[i].x1;
	p1[1] = polygons_[i].y2;
  	p2[0] = polygons_[i].x2;
	p2[1] = polygons_[i].y2;

	cross_p0_p1_p2 = (((p1[0] - p0[0]) * (p2[1] - p0[1])) - ((p2[0] - p0[0]) * (p1[1] - p0[1])));
	cross_p3_p1_p2 = (((p1[0] - p0[2]) * (p2[1] - p0[3])) - ((p2[0] - p0[2]) * (p1[1] - p0[3])));
	cross_p1_p0_p3 = (((p0[0] - p1[0]) * (p0[3] - p1[1])) - ((p0[2] - p1[0]) * (p0[1] - p1[1])));
	cross_p2_p0_p3 = (((p0[0] - p2[0]) * (p0[3] - p2[1])) - ((p0[2] - p2[0]) * (p0[1] - p2[1])));
	sign_cross_p0_p1_p2 =  cross_p0_p1_p2 >=0 ? cross_p0_p1_p2 ? 1 :0 :-1;
	sign_cross_p3_p1_p2 =  cross_p3_p1_p2 >=0 ? cross_p3_p1_p2 ? 1 :0 :-1;
	sign_cross_p1_p0_p3 =  cross_p1_p0_p3 >=0 ? cross_p1_p0_p3 ? 1 :0 :-1;
	sign_cross_p2_p0_p3 =  cross_p2_p0_p3 >=0 ? cross_p2_p0_p3 ? 1 :0 :-1;	

	overlapping_check_x = overlapping_check_dev(p0[0],p0[2],p1[0],p2[0]);
	overlapping_check_y = overlapping_check_dev(p0[1],p0[3],p1[1],p2[1]);
		
	if((cross_p0_p1_p2 == 0) &&  (cross_p3_p1_p2 == 0)) // Lines are colinear
	{
		if (overlapping_check_x || overlapping_check_y) //lines are overlapping
		{
			flag = 1;
			p0[4] = 1;
			return;	
		}
			
	}
	
	if((sign_cross_p0_p1_p2 != sign_cross_p3_p1_p2) && (sign_cross_p1_p0_p3 != sign_cross_p2_p0_p3))    //lines are intersecting
	{
		flag = 1;
		p0[4] = 1;
		return;	
	}
	
	if(flag == 1 || p0[4] == 1)
	{
		return;
	}
	p1[0] = polygons_[i].x2;
	p1[1] = polygons_[i].y2;
  	p2[0] = polygons_[i].x2;
	p2[1] = polygons_[i].y1;
	
	cross_p0_p1_p2 = (((p1[0] - p0[0]) * (p2[1] - p0[1])) - ((p2[0] - p0[0]) * (p1[1] - p0[1])));
	cross_p3_p1_p2 = (((p1[0] - p0[2]) * (p2[1] - p0[3])) - ((p2[0] - p0[2]) * (p1[1] - p0[3])));
	cross_p1_p0_p3 = (((p0[0] - p1[0]) * (p0[3] - p1[1])) - ((p0[2] - p1[0]) * (p0[1] - p1[1])));
	cross_p2_p0_p3 = (((p0[0] - p2[0]) * (p0[3] - p2[1])) - ((p0[2] - p2[0]) * (p0[1] - p2[1])));
	sign_cross_p0_p1_p2 =  cross_p0_p1_p2 >=0 ? cross_p0_p1_p2 ? 1 :0 :-1;
	sign_cross_p3_p1_p2 =  cross_p3_p1_p2 >=0 ? cross_p3_p1_p2 ? 1 :0 :-1;
	sign_cross_p1_p0_p3 =  cross_p1_p0_p3 >=0 ? cross_p1_p0_p3 ? 1 :0 :-1;
	sign_cross_p2_p0_p3 =  cross_p2_p0_p3 >=0 ? cross_p2_p0_p3 ? 1 :0 :-1;	

	overlapping_check_x = overlapping_check_dev(p0[0],p0[2],p1[0],p2[0]);
	overlapping_check_y = overlapping_check_dev(p0[1],p0[3],p1[1],p2[1]);
		
	if((cross_p0_p1_p2 == 0) &&  (cross_p3_p1_p2 == 0)) // Lines are colinear
	{
		if (overlapping_check_x || overlapping_check_y) //lines are overlapping
		{
			flag = 1;
			p0[4] = 1;
			return;	
		}
			
	}
	
	if((sign_cross_p0_p1_p2 != sign_cross_p3_p1_p2) && (sign_cross_p1_p0_p3 != sign_cross_p2_p0_p3))    //lines are intersecting
	{
		flag = 1;
		p0[4] = 1;
		return;	
	}	
	if(flag == 1 || p0[4] == 1)
	{
		return;
	}
	p1[0] = polygons_[i].x2;
	p1[1] = polygons_[i].y1;
  	p2[0] = polygons_[i].x1;
	p2[1] = polygons_[i].y1;
	
	cross_p0_p1_p2 = (((p1[0] - p0[0]) * (p2[1] - p0[1])) - ((p2[0] - p0[0]) * (p1[1] - p0[1])));
	cross_p3_p1_p2 = (((p1[0] - p0[2]) * (p2[1] - p0[3])) - ((p2[0] - p0[2]) * (p1[1] - p0[3])));
	cross_p1_p0_p3 = (((p0[0] - p1[0]) * (p0[3] - p1[1])) - ((p0[2] - p1[0]) * (p0[1] - p1[1])));
	cross_p2_p0_p3 = (((p0[0] - p2[0]) * (p0[3] - p2[1])) - ((p0[2] - p2[0]) * (p0[1] - p2[1])));
	sign_cross_p0_p1_p2 =  cross_p0_p1_p2 >=0 ? cross_p0_p1_p2 ? 1 :0 :-1;
	sign_cross_p3_p1_p2 =  cross_p3_p1_p2 >=0 ? cross_p3_p1_p2 ? 1 :0 :-1;
	sign_cross_p1_p0_p3 =  cross_p1_p0_p3 >=0 ? cross_p1_p0_p3 ? 1 :0 :-1;
	sign_cross_p2_p0_p3 =  cross_p2_p0_p3 >=0 ? cross_p2_p0_p3 ? 1 :0 :-1;	
	overlapping_check_x = overlapping_check_dev(p0[0],p0[2],p1[0],p2[0]);
	overlapping_check_y = overlapping_check_dev(p0[1],p0[3],p1[1],p2[1]);
		
	if((cross_p0_p1_p2 == 0) &&  (cross_p3_p1_p2 == 0)) // Lines are colinear
	{
		if (overlapping_check_x || overlapping_check_y) //lines are overlapping
		{
			flag = 1;
			p0[4] = 1;
			return;	
		}
			
	}
	
	if((sign_cross_p0_p1_p2 != sign_cross_p3_p1_p2) && (sign_cross_p1_p0_p3 != sign_cross_p2_p0_p3))    //lines are intersecting
	{
		flag = 1;
		p0[4] = 1;
		return;	
	}
	
}

float distance_(const float *p1, const float *p2)
{
  const float dx = p1[0] - p2[0];
  const float dy = p1[1] - p2[1];
  

  return sqrt(pow(dx, 2) + pow(dy, 2));
}

int min_distance(float* distance_list,int vertex_count)
{
	float min_dstance = distance_list[0];
	int idx = 0;	
	for(int i=1; i <vertex_count;i++)
	{
		if(distance_list[i] < min_dstance)
		{
			min_dstance = distance_list[i];
			idx = i;
		} 
	}

	return idx;
}


float cross_(const float *p0, const float *p1, const float *p2)
{
	return (((p1[0] - p0[0]) * (p2[1] - p0[1])) - ((p2[0] - p0[0]) * (p1[1] - p0[1])));
}

int sign_(float value)
{
	return value >=0 ? value ? 1 :0 :-1;
}

float max_(float p0 , float p1)
{
	return p0 > p1?p0 : p1;
}

float min_(float p0 , float p1)
{
	return p0 < p1?p0 : p1;
}


bool overlapping_check(float p0, float p3, float p1, float p2)
{
	if (p0 > p3)
	{
	   p0 = p0+p3;
	   p3 = p0 - p3;
	   p0 = p0 - p3;
	}
	if (p1 > p2)
	{
	   p1 = p1+p2;
	   p2 = p1 - p2;
	   p1 = p1 - p2;
	}
	return max_(p0,p1) <= min_(p3,p2);
	
}

RRT::RRT(float *start, float *goal, int rando)
        : start_(start),
          goal_(goal),
          delta_(0.1),
          epsilon_(0),
          xmin_(0),
          xmax_(1000),
          ymin_(0),
          ymax_(1000),
          resolution_(1.0),
          max_iter_(MAX_ITER),
          vertex_count_(0),
	  obstacles_count_(0)
{
  std::srand(rando);
}

bool RRT::polygon_collision_check_cuda(const vertex &v_new,const vertex &v_near,int goal_check)
{
//	#ifdef WR2F
//	high_resolution_clock::time_point t1 = high_resolution_clock::now();
//	#endif	
	static double total_time1 = 0;
  	static int count1 = 0;
	double begin_time = get_time_point();
	v_new_near_host[0] = v_new.x;
	v_new_near_host[1] = v_new.y;	
	v_new_near_host[2] = v_near.x;
	v_new_near_host[3] = v_near.y;
	v_new_near_host[4] = 0;	
	
	////////////////////////////////////////////////////////////////
	int num_blocks = get_number_of_blocks(obstacles_count_, BLOCK);
	int extra_blocks = num_blocks %4;
	int stream_id = 0;
	num_blocks = num_blocks /4;
	int loopcount = 0;
	int offset = 0;
	for (loopcount = 0; loopcount < num_blocks;loopcount++)
	{
		offset = loopcount * 4*BLOCK;
		stream_id = loopcount%4;
		polygon_collision_check_dev<<<4, BLOCK, 0, get_cuda_stream_32(stream_id)>>>(polygons_dev,v_new_near_dev,offset);	
	}
	if(extra_blocks)
	{
		stream_id = loopcount%4;
		offset = loopcount * 4*BLOCK;
		polygon_collision_check_dev<<<extra_blocks, BLOCK, 0, get_cuda_stream_32(stream_id)>>>(polygons_dev,v_new_near_dev,offset);	
	}
	if(loopcount == 0)
	{
		cudaEventRecord(stopEvent,get_cuda_stream_32(0));
		while(cudaEventQuery(stopEvent) != 0);
	}
	else
	{
		cudaDeviceSynchronize();
	}
	////////////////////////////////////////////////////////////////

	/*int blocksize_ = obstacles_count_ > 1024?1024:obstacles_count_ ;
	int gridsize_ = obstacles_count_ % 1024?int(obstacles_count_/1024) + 1:int(obstacles_count_/1024);
        int offset = 0;	*/
//	#ifdef WR2F
//	high_resolution_clock::time_point t2 = high_resolution_clock::now();
//	duration<double, milli> time_span = t2-t1;
//	myfile1 <<"Obstacle Detection = "  << time_span.count() << endl; 
//	#endif	
	count1++;
	double time_diff = ((double)get_time_point() - begin_time) / 1000;
	total_time1+= time_diff;
	if(v_new_near_host[4])
	{	
		return true;
	}
	else
	{
		if(goal_check)
			printf("Average Time for collision check is %lf milli-seconds \n", total_time1/(count1));
		return false;
	}
}


bool RRT::PolygonCollisionCheck(const vertex &v_new, const vertex &v_near)
{

  
  const float p0[2] = {v_new.x, v_new.y};
  const float p3[2] = {v_near.x, v_near.y};
  
  float p1[2];
  float p2[2];

  for(unsigned int i = 0; i < obstacles_count_; i++)
  {
	p1[0] = polygons_[i].x1;
	p1[1] = polygons_[i].y1;
  	p2[0] = polygons_[i].x1;
	p2[1] = polygons_[i].y2;
	
	if((cross_(p0, p1, p2) == 0) &&  (cross_(p3, p1, p2) == 0)) // Lines are colinear
	{
		if (overlapping_check(p0[0], p3[0], p1[0], p2[0]) || overlapping_check(p0[1], p3[1], p1[1], p2[1])) //lines are overlapping
		{
			return true; 	
		}
			
	}
	
	if((sign_(cross_(p0, p1, p2)) != sign_(cross_(p3, p1, p2))) && (sign_(cross_(p1, p0, p3)) != sign_(cross_(p2, p0, p3))))    //lines are intersecting
	{

			return true;
	}
	
	/*if ((i==1249))
	{
		printf(" CPU %d - %f ,%f , %f, %f \n",i,cross_(p0, p1, p2),cross_(p3, p1, p2),cross_(p1, p0, p3),cross_(p2, p0, p3));
		printf("CPU - %d, p1 = %f %f, p2 = %f %f, p0 = %f %f, p3 = %f %f \n ",i,p1[0],p1[1],p2[0],p2[1],p0[0],p0[1],p3[0],p3[1]);
	}*/
		
	
	p1[0] = polygons_[i].x1;
	p1[1] = polygons_[i].y2;
  	p2[0] = polygons_[i].x2;
	p2[1] = polygons_[i].y2;
	
	if((cross_(p0, p1, p2) == 0) &&  (cross_(p3, p1, p2) == 0)) // Lines are colinear
	{
		if (overlapping_check(p0[0], p3[0], p1[0], p2[0]) || overlapping_check(p0[1], p3[1], p1[1], p2[1])) //lines are overlapping
		{
			return true; 	
		}
			
	}
	
	if((sign_(cross_(p0, p1, p2)) != sign_(cross_(p3, p1, p2))) && (sign_(cross_(p1, p0, p3)) != sign_(cross_(p2, p0, p3))))    //lines are intersecting
	{
			return true;
		
	}	
	
	p1[0] = polygons_[i].x2;
	p1[1] = polygons_[i].y2;
  	p2[0] = polygons_[i].x2;
	p2[1] = polygons_[i].y1;
	
	if((cross_(p0, p1, p2) == 0) &&  (cross_(p3, p1, p2) == 0)) // Lines are colinear
	{
		if (overlapping_check(p0[0], p3[0], p1[0], p2[0]) || overlapping_check(p0[1], p3[1], p1[1], p2[1])) //lines are overlapping
		{
			return true; 	
		}
			
	}
	
	if((sign_(cross_(p0, p1, p2)) != sign_(cross_(p3, p1, p2))) && (sign_(cross_(p1, p0, p3)) != sign_(cross_(p2, p0, p3))))    //lines are intersecting
	{
			return true;
		
	}

	p1[0] = polygons_[i].x2;
	p1[1] = polygons_[i].y1;
  	p2[0] = polygons_[i].x1;
	p2[1] = polygons_[i].y1;
	
	if((cross_(p0, p1, p2) == 0) &&  (cross_(p3, p1, p2) == 0)) // Lines are colinear
	{
		if (overlapping_check(p0[0], p3[0], p1[0], p2[0]) || overlapping_check(p0[1], p3[1], p1[1], p2[1])) //lines are overlapping
		{
			return true;	
		}
			
	}
	
	if((sign_(cross_(p0, p1, p2)) != sign_(cross_(p3, p1, p2))) && (sign_(cross_(p1, p0, p3)) != sign_(cross_(p2, p0, p3))))    //lines are intersecting
	{
			return true;
		
	}
  }
  return false;
}

bool RRT::exploreObstacles()
{

  vertex_count_ = 0;
  //vertices_.clear();
  // add start to graph
  vertex v_start;
  v_start.x = start_[0];
  v_start.y = start_[1];
  addVertex(v_start);


  bool success = false;
  int ctr = 0;


  while(!success)
  {
	
    if (ctr > max_iter_)
    {
      std::cout << "Goal not achieved" << std::endl;
      return false;
    }

    // std::cout << "Iter: " << ctr << std::endl;
	float rand[2];
    // 1) random point
    randomConfig(rand);
// std::cout << "randat: " << rand_point_cuda[0] << ", " << rand_point_cuda[1] <<std::endl;

    // 2) nearest node in graph
    vertex v_near;
    high_resolution_clock::time_point t3 = high_resolution_clock::now();
     nearestVertex(v_near, rand);
    high_resolution_clock::time_point t4 = high_resolution_clock::now();
    duration<double, milli> time_span = t4-t3;
    #ifdef WR2F
    myfile <<"Nearest Vertex = "  << time_span.count() << endl; 
    #endif 
    // 3) new node
    vertex v_new;
    if(!newConfiguration(v_new, v_near, rand))
    {
      continue;
    }

//    std::cout << "v new at: " << v_new.x << ", " << v_new.y <<std::endl;

    ctr++;

    // 4) check for collisions
   // if (collision_check(v_new, v_near))
   // {
      // std::cout << "Collision" << std::endl;
   //   continue;
   // }
   t3 = high_resolution_clock::now();
   bool collision_flag = PolygonCollisionCheck(v_new, v_near);
   t4 = high_resolution_clock::now();
   time_span = t4-t3;
    #ifdef WR2F
    myfile <<"Obstacle Detection = "  << time_span.count() << endl;  
   #endif
   //cout <<  "CPU Time " << time_span.count() << " ms" << endl; 
    if (collision_flag)
    {
	//std::cout << "Collision" << std::endl;
       continue;
    }

    // std::cout << v_new.x << " " << v_new.y << "\n";

    // 6) add new node
    addVertex(v_new);
    addEdge(v_near, v_new);

    // 7) win check
  t3 = high_resolution_clock::now();
  bool win_flag = win_check(v_new, goal_);
  t4 = high_resolution_clock::now();
   time_span = t4-t3;
   #ifdef WR2F
   myfile <<"Obstacle Detection = "  << time_span.count() << endl; 
   #endif
  // cout <<  "CPU Time " << time_span.count() << " ms" << endl; 
  //  win_flag = 0;
    if (win_flag)
    {
      std::cout << "Goal reached on CPU" << std::endl;
      printf("ctr = %d \n",ctr);
      // add goal to graph
      vertex v_goal;
      v_goal.x = goal_[0];
      v_goal.y = goal_[1];
      addVertex(v_goal);
      addEdge(v_new, v_goal);
      std::cout << "Vnew " << v_new.x << " " << v_new.y << "\n";
      std::cout << "Goal " << v_goal.x << " " << v_goal.y << "\n";
      success = true;
      break;
    }

  }

  return success;
}


bool RRT::win_check(const vertex &v_new, const float *goal)
{
  //cast goal to vertex //TODO: overlead collision to optionally take float as second arg
  vertex v_goal(goal[0],goal[1]);
  // std::cout << "SURUR\n";
  bool collis_check = PolygonCollisionCheck(v_new, v_goal);

 // std::cout << collis_check << std::endl;

  return !collis_check;
}

bool RRT::win_check_cuda(const vertex &v_new,const float *goal)
{
  vertex v_goal(goal[0],goal[1]);
  bool collis_check = polygon_collision_check_cuda(v_new,v_goal,1);
//PolygonCollisionCheck(v_new, v_goal,polygons_dev);

 // std::cout << collis_check << std::endl;

  return !collis_check;
}

bool RRT::exploreCuda()
{
  static double total_time = 0;
  static int count = 0;
  double time_diff;
   vertex_count_ = 0;
 // vertices_.clear();
   // add start to graph
  vertex v_start;
  v_start.x = start_[0];
  v_start.y = start_[1];
  addVertex(v_start);
  bool success = false;
  int ctr = 0;
  while(!success)
  {
	
    if (ctr > max_iter_)
    {
      std::cout << "Goal not achieved" << std::endl;
      return false;
    }
    // printf("ctr = %d\n",ctr);
    float rand[2];
    randomConfig(rand);
    vertex v_near;
 //   high_resolution_clock::time_point t3 = high_resolution_clock::now();
    double begin_time = get_time_point();
    if(vertex_count_ > 1024)
    	nearestVertex_cuda(v_near, rand);
    else
     	nearestVertex(v_near, rand);
    count++;
    time_diff = ((double)get_time_point() - begin_time) / 1000;
    total_time+= time_diff;
   // high_resolution_clock::time_point t4 = high_resolution_clock::now();
  //  duration<double, milli> time_span = t4-t3;
//    #ifdef WR2F
//    myfile1 <<"Nearest Vertex = "  << time_span.count() << endl; 
//    #endif
    vertex v_new;
	
    if(!newConfiguration(v_new, v_near, rand))
    {
	
      continue;
    }
    ctr++;
	
    if (polygon_collision_check_cuda(v_new,v_near,0))
    {
       continue;
    }
    addVertex(v_new);
    addEdge(v_near, v_new);

    bool win_flag = win_check_cuda(v_new,goal_);
    if (win_flag)
    {
	printf("Average Time for Nearest Vertex find is %lf milli-seconds \n", total_time/(count));
     // std::cout << "Goal reached on GPU" << std::endl;
  //    printf("ctr = %d \n",ctr);
      vertex v_goal;
      v_goal.x = goal_[0];
      v_goal.y = goal_[1];
      addVertex(v_goal);
      addEdge(v_new, v_goal);
     // std::cout << "Vnew " << v_new.x << " " << v_new.y << "\n";
    //  std::cout << "Goal " << v_goal.x << " " << v_goal.y << "\n";
      success = true;
      break;
    }

  }

  return success;
}


void RRT::randomObstacles(int num_obstacle, float x_min, float x_max, float y_min, float y_max)
{
	for(int i = 0; i<num_obstacle;i++)
	{
		 float x1 = xmin_+static_cast<float>(std::rand()) / (static_cast<float>(RAND_MAX/(xmax_-xmin_)));
    		 float y1 = ymin_+static_cast<float>(std::rand()) / (static_cast<float>(RAND_MAX/(ymax_-ymin_)));
		 float x2 = x1 + x_min +static_cast<float>(std::rand()) / (static_cast<float>(RAND_MAX/(x_max-x_min)));
    		 float y2 = y1 +y_min + +static_cast<float>(std::rand()) / (static_cast<float>(RAND_MAX/(y_max- y_min)));

		if ((start_[0] >= x1) && (start_[0] <= x2) && (start_[1] >= y1) && (start_[1] <= y2))
		{
			i--;
			//printf("%f %f %f %f start within the polygon\n ",x1,y1,x2,y2);
			continue;
		}
		if (goal_[0] >= x1 && goal_[0] <= x2 && goal_[1] >= y1 && goal_[1] <= y2)
		{
			i--;
			//printf("%f %f %f %f goal within the polygon\n ",x1,y1,x2,y2);	
			continue;
		}
		Polygon poly;
		poly.x1 = x1;
		poly.y1 = y1;
		poly.x2 = x2;	
		poly.y2 = y2;
		//polygons_.push_back(poly);
		//polygons_dev[i] = poly;
		polygons_[obstacles_count_++] = poly;
		//printf(" polygo= %f %f %f %f \n",x1,y1,x2,y2);
		
	}
	//printf("size = %d\n",polygons_.size());
}

void RRT::addVertex(vertex &v)
{
  v.id = vertex_count_;

  vertex_host_ptr[vertex_count_++] = v;
  

  // std::cout << "New vertex count: " << vertex_count_ << std::endl;
} 



void RRT::addEdge(const vertex &v_near, const vertex &v_new)
{
  // search for node1 and node2
  // addes edge btw both
  bool added = false;


  for(unsigned int i = 0; i < vertex_count_; i++)
  {
    // found node 1
    if (vertex_host_ptr[i].id == v_near.id)
    {
      for(unsigned int j = 0; j < vertex_count_; j++)
      {
        // do not add vertex to itself
        // found node 2
        if(vertex_host_ptr[j].id == v_new.id && i != j)
        {
          // edge connecting node 1 to node 2
          // std::cout << "adding edge " << v_near.id << "->" << v_new.id << std::endl;
          // v_near.adjacent_vertices.push_back(v_new.id);
          vertex_host_ptr[v_near.id].adjacent_vertices.push_back(v_new.id);
          added = true;
        }

      } // end inner loop
    }
  } // end outer loop

  if (!added)
  {
    std::cout << "Error: 'addEdge' edge not added" << std::endl;
  }
}


bool RRT::newConfiguration(vertex &v_new, const vertex &v_near, const float *q_rand) const
{

  //std::cout << "Vnear " << v_near.x << " " << v_near.y << "\n";
  // difference btw q_rand and v_near
  const float vx = q_rand[0] - v_near.x;
  const float vy = q_rand[1] - v_near.y;
  
//std::cout << "Vx " << vx << " " << vy << "\n";
  // distance_ between v_near and q_rand
  const float magnitude = std::sqrt(std::pow(vx, 2) + std::pow(vy, 2));
  
//  std::cout << "Magnitude " << magnitude << std::endl;

  if (magnitude == 0)
  {
    return false;
  }

  // unit vector in driection of q_rand
  const float ux = vx / magnitude;
  const float uy = vy / magnitude;

  // place v_new a delta away from v_near
  v_new.x = v_near.x + delta_ * ux;
  v_new.y = v_near.y + delta_ * uy;
 //std::cout << "ux " << ux << " " << uy << "\n";
 // std::cout << "Vnew " << v_new.x << " " << v_new.y << "\n";

  // make sure still within bounds
  if (v_new.x > xmax_ || v_new.x < xmin_ || v_new.y > ymax_ || v_new.y < ymin_)
  {
    return false;
  }

  return true;
}



void RRT::nearestVertex(vertex &v, float *q_rand) const
{
  float point[2];
  std::vector<float> d;

  for(unsigned int i = 0; i < vertex_count_; i++)
  {
    point[0] = vertex_host_ptr[i].x;
    point[1] = vertex_host_ptr[i].y;

    distances_host[i] = (distance_(point, q_rand));
  }

  int idx = min_distance(distances_host,vertex_count_);
  v = vertex_host_ptr[idx];
}

void RRT::nearestVertex_cuda(vertex &v, float *q_rand) const
{
	
	/*int blocksize_ = vertex_count_ > 1024?1024:vertex_count_ ;
	int gridsize_ = vertex_count_ % 1024?int(vertex_count_/1024) + 1:int(vertex_count_/1024);
	dim3 blocksize(blocksize_);
	dim3 gridsize(gridsize_);*/
	new_vertex_host[0] = q_rand[0];
	new_vertex_host[1] = q_rand[1];
	//////////////////////////////////////////////////////////////////////////////
	int num_blocks = get_number_of_blocks(vertex_count_, BLOCK);
	int extra_blocks = num_blocks %4;
	int stream_id = 0;
	num_blocks = num_blocks /4;
	int loopcount = 0;
	int offset = 0;
	for (loopcount = 0; loopcount < num_blocks;loopcount++)
	{
		offset = loopcount * 4*BLOCK;
		stream_id = loopcount%4;
		distance_cal_cuda<<<4, BLOCK, 0, get_cuda_stream_32(stream_id)>>>(vertex_cuda_ptr,new_vertex_cuda,distances_cuda,offset);	
	}
	if(extra_blocks)
	{
		stream_id = loopcount%4;
		offset = loopcount * 4*BLOCK;
		distance_cal_cuda<<<extra_blocks, BLOCK, 0, get_cuda_stream_32(stream_id)>>>(vertex_cuda_ptr,new_vertex_cuda,distances_cuda,offset);	
	}
	if(loopcount == 0)
	{
		cudaEventRecord(stopEvent,get_cuda_stream_32(0));
		while(cudaEventQuery(stopEvent) != 0);
	}
	else
	{
		cudaDeviceSynchronize();
	}
	////////////////////////////////////////////////////////////////////////////////


	/*distance_cal_cuda<<<gridsize,blocksize,0,get_cuda_stream_32(0)>>>(vertex_cuda_ptr,new_vertex_cuda,distances_cuda,offset);
	cudaEventRecord(stopEvent,stream[0]);
	while(cudaEventQuery(stopEvent) != 0);*/
	int idx = min_distance(distances_host,vertex_count_);
	v = vertex_host_ptr[idx];
	
}


void RRT::randomConfig(float *q_rand) const
{
  // x position
  q_rand[0] = xmin_+static_cast<float>(std::rand()) / (static_cast<float>(RAND_MAX/(xmax_-xmin_)));

  // y position
  q_rand[1] = ymin_+static_cast<float>(std::rand()) / (static_cast<float>(RAND_MAX/(ymax_-ymin_)));
}

int RRT::findParent(const vertex &v) const
{
  // iterate over vertices
  for(unsigned int i = 0; i < vertex_count_; i++)
  {
    for(unsigned int j = 0; j < vertex_host_ptr[i].adjacent_vertices.size(); j++)
    {
      if (vertex_host_ptr[i].adjacent_vertices.at(j) == v.id)
      {
        // std::cout << "Parent found" << std::endl;
        return i;
      }
    } // end inner loop
  } // end outer loop

  std::cout << "Parent not found" << std::endl;
  return -1;
}

void destroy_cuda_mem(void)
{
 // cudaFree(polygons_dev);
  cudaFree(v_new_near_dev);
  cudaFreeHost(polygons_);
  cudaFreeHost(v_new_near_host);
  cudaFree(vertex_cuda_ptr);
  cudaFree(new_vertex_cuda);
  cudaFree(distances_cuda);
  cudaFreeHost(vertex_host_ptr);
  cudaFreeHost(new_vertex_host);
  cudaFreeHost(distances_host);
  cudaEventDestroy(stopEvent);

}


int main(int argc, char * argv[])
{

 ///  cpu_set_t cpuset_sched;
//CPU_ZERO(&cpuset_sched);
//CPU_SET(4,&cpuset_sched);
//sched_setaffinity(getpid(),sizeof(cpuset_sched),&cpuset_sched);

  printf("\n\n**===-------------------------------------------------===**\n");
  printf("\n\n**===--- RRT ---===**\n");
  printf("\n\n**===-------------------------------------------------===**\n");
  float start[] = {0,0};
  float goal[] = {1000,1000};//{float(rand()%1000),float(rand()%1000)};
  

  //expecting command line args to be rand num, then num onbstacles
  if (argc > 2)
  {
    num_obstacles = std::atoi(argv[2]);
    rand_num = std::atoi(argv[1]);
  } else if (argc > 1) {
    rand_num = std::atoi(argv[1]);
    num_obstacles = 2048;
  } else {
    num_obstacles = 2048;
    rand_num = 20;
  }

  RRT rrt(start, goal, rand_num);
  cudaHostAlloc(&polygons_,num_obstacles*sizeof(Polygon),cudaHostAllocMapped);
  rrt.randomObstacles(num_obstacles, 1.0, 2.0, 1.0, 2.0);
  cudaHostAlloc(&v_new_near_host,5*sizeof(float),cudaHostAllocMapped);
  status = cudaHostGetDevicePointer(&v_new_near_dev,v_new_near_host,0);  
  cudaHostAlloc(&vertex_host_ptr,MAX_ITER*sizeof(vertex),cudaHostAllocMapped);
  cudaHostAlloc(&new_vertex_host,2*sizeof(float),cudaHostAllocMapped);
  cudaHostAlloc(&distances_host,MAX_ITER*sizeof(float),cudaHostAllocMapped);
  status = cudaHostGetDevicePointer(&distances_cuda,distances_host,0);  
  status = cudaHostGetDevicePointer(&new_vertex_cuda,new_vertex_host,0);  
  status = cudaHostGetDevicePointer(&vertex_cuda_ptr,vertex_host_ptr,0);  
  cudaEventCreateWithFlags(&stopEvent,cudaEventDisableTiming);
  status = cudaHostGetDevicePointer(&polygons_dev,polygons_,0);  
  double total_time = 0; 
  int loopcount = 0;
  int path_deadline_missed = 0;
//  char *s1;

  rfunc_init ();
//	ofstream myfile1;
//	  myfile1.open ("rrtGPU_time.txt");
  for(loopcount = 0; loopcount < 120;loopcount++)
  {

	  rfunc();	
//    	double num_double = std::stod(s1);
	  double begin_time = get_time_point();
//	  #ifdef WR2F
////	  myfile1.open ("GPU_time.txt");
//	  #endif
	  printf("GPU**===-------------------------------------------------===**\n");
	  printf("loopcount = %d \n",loopcount);
	  rrt.exploreCuda();
//	  #ifdef WR2F
////	  myfile1.close();
//	  #endif
	  double time_diff = ((double)get_time_point() - begin_time) / 1e6;

	  total_time+= time_diff;
	//  printf("%d :GPU path finding completed in %d loopcount \n",(loopcount+1),counter);
	//  printf("Average Time for Path Planning is %lf milli-seconds \n", total_time/(loopcount+1));
	rsend(begin_time, time_diff);
//	  int sleep_val = 2.0-time_diff;
//	  if(sleep_val > 0)
//		usleep(sleep_val*1e6);
//	  	 else
//	{
//		printf("Path Planning Deadline missed \n");		
//		path_deadline_missed++;
//	}
 	  //printf("GPU Path finding Completed in %lf milli-seconds.\n\n\n", ((double)get_time_point() - begin_time) / 1000);

    }
    printf("Average Time for Path Planning is %lf milli-seconds \n", total_time/(loopcount));
   printf("Total Deadline Missed in Path Planning = %d\n",path_deadline_missed);
//	  #ifdef WR2F
//	  myfile1.close();
//	  #endif
	rend();
   destroy_cuda_mem();
   Destroy_stream();
return 0;

}









// end file

