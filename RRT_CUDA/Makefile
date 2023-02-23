GPU=1

ARCH= -gencode arch=compute_35,code=sm_35 \
      -gencode arch=compute_50,code=[sm_50,compute_50] \
      -gencode arch=compute_52,code=[sm_52,compute_52] \
	    -gencode arch=compute_61,code=[sm_61,compute_61]

OS := $(shell uname)

EXEC=RRT
OBJDIR=./obj/

NVCC=nvcc
CC=g++
CPP=g++ -std=c++11

COMMON= -DGPU -I/usr/local/cuda/include/
NVCCFLAGS= -DGPU -maxrregcount 32
##Where are include files kept
#INCLUDE = .
##Local Libraries
#MYLIB = mylib.a
LDFLAGS=-lSimpleAmqpClient -lboost_chrono -lboost_system -lrabbitmq -lrt -lssl -lcrypto -ldl -lpthread

#CFLAGS=-Wall -Wno-unused-result -Wno-unknown-pragmas -fPIC
CFLAGS=-I.

OBJ=CUDA_collision_check_memcpy.o rfunc.o
#OBJ=CUDA_collision_check_memcpy.o utils.o unix/platform_utils.o
OBJS=$(addprefix $(OBJDIR), $(OBJ))

#DEPS = rrt_memcpy.hpp utils.h
DEPS = rfunc.h

all: $(OBJDIR) $(EXEC) 

$(EXEC): $(OBJS)
	$(NVCC) $(CFLAGS)  $^ -o $@ $(LDFLAGS)
#$(EXEC): $(OBJS)
#	$(CPP) -std=c++11 $(COMMON) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(OBJDIR)%.o: %.cpp $(DEPS)
	$(CPP) -std=c++11 $(COMMON) $(CFLAGS) -c $< -o $@

#$(OBJDIR)%.o: %.cu $(DEPS)
#	$(NVCC) $(ARCH) $(COMMON) --compiler-options "$(CFLAGS)" $(NVCCFLAGS) -c $< -o $@

$(OBJDIR)%.o: %.cu $(DEPS)
	$(NVCC) $(ARCH) $(COMMON) --compiler-options "$(CFLAGS)" $(NVCCFLAGS) -c $< -o $@

$(OBJDIR):
	mkdir -p $(OBJDIR)

.PHONY: clean

clean:
	rm -rf $(OBJS) $(EXEC) 
