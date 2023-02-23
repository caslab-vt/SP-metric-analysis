# SP metric analysis
 Code repository with DAG node packages and visalization scripts
 
 1. Install yolodynaslam: follow directions from original repository
 https://github.com/bijustin/YOLO-DynaSLAM
 
 2. Install darknet
 
 cd darknet_fs/darknet
 make
 
 sudo cp libdarknet.so /usr/local/lib/
 
 sudo cp include/darknet.h /usr/local/include/
 
 sudo ldconfig
 
following instrcutions from https://github.com/stephanecharette/DarkHelp

3. Install RRT-CUDA

cd RRT_CUDA
make

4. Install TSP-Solver: original repo:
https://github.com/aashusingh/TSP-Solver 

INstall rabbutmq
follow original repository instruciotns 
https://github.com/alanxz/rabbitmq-c
https://github.com/alanxz/SimpleAmqpClient

Advanced steps:
For rabbitmq integration with TSP:
g++ Approx.cpp Read.cpp Greedy.cpp BnB.cpp SA.cpp HC.cpp TSP.h TSPSolver.cpp -o tsp -lSimpleAmqpClient -lboost_chrono -lboost_system -lrabbitmq -lrt -lssl -lcrypto -ldl -lpthread

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

5. for depth estimation: put depth data in darknet/data dolder 
