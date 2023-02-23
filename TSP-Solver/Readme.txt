https://github.com/aashusingh/TSP-Solver 


Just use instructions in the repository
Input data is given in DATA folder
./tsp DATA/burma14.tsp 10 LS1 3


Advanced steps:
For rabbitmq integration:
g++ Approx.cpp Read.cpp Greedy.cpp BnB.cpp SA.cpp HC.cpp TSP.h TSPSolver.cpp -o tsp -lSimpleAmqpClient -lboost_chrono -lboost_system -lrabbitmq -lrt -lssl -lcrypto -ldl -lpthread

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/

./tsp DATA/burma14.tsp 10 LS1 3

Performance metrics:
Path Length:
Solution gap:
Elapsed(response) time:
---------------------------------------------------------------------------------------------------



TSPSolver Program Version 1.0 12/05/2014

Program Description
--------------------
This program is used to solve symmetric Travelling Salesman Problem(TSP) with five different methods:

1. 2-Approximation algorithm
2. Greedy algorithm(with farthest insertion)
3. Iterated Hill Climbing + Tabu Search
4. Simulated Annealing
5. Branch-and-Bound 
----------------------------------------

How to compile and create the executable
----------------------------------------
This program is written in C++ and there are 8 files including 7 .cpp file and 1 header file.
Use the command as follows to create the executable (tsp.exe):

$ g++ Approx.cpp Read.cpp Greedy.cpp BnB.cpp SA.cpp HC.cpp TSP.h TSPSolver.cpp -o tsp

--------------------------------------------------------------------------------

How to run tsp.exe
--------------------
tsp.exe takes 4 input arguments and must be input in the following order:

 i) the filename of a dataset
 ii) the cut-off time (in seconds) 
 iii) the method to use 
 iv) a random seed

For i), the dataset must have the same format as in TSPLIB.
For iii), use specific name to indicate which method you want to use:
"Approx"------ 2-opt Approximation
"Greedy"------ greedy with farthest insertion
"LS1"--------- Iterated Hill Climbing
"LS2"--------- Simulated Annealing
"BnB"--------- Branch-and-Bound

For example:
If you want to use 2-opt Approximation, write in the command line:

./tsp burma14.tsp 2 Approx 2

If you want to use Iterated Hill Climbing, write in the command line:

./tsp burma14.tsp 10 LS1 3

Pay attention that cut-off time is only effective for the last 3 methods and random seed is effective for 2 local search methods.
--------------------------------------------------------------------------------

Output
--------------------
The output of tsp.exe has 2 components:
1. Print out the result on the screen
2. Generate 2 output files named as
	<inputFilename>_<method>_<cutoff>_<runID>.sol------- tour + tour length
	<inputFilename>_<method>_<cutoff>_<runID>.trace------- timestamp + best found solution at that time
