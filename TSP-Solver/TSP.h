#include<iostream>
#include<fstream>
#include<vector>
#include<queue>
#include<string>
#include<cmath>
#include<ctime>
#include<cstdlib>
#include<climits>
#include<stack>
#include <map>
#include <cassert>

using namespace std;

extern string NAME;
extern ofstream output_sol,output_trace;

//Read graph from file(read.cpp)
int **readgraph(char *graph, int *p, int*q);

//2-Approximation algorithm(Approx.cpp)

class node{
public:
	int keyv;
	int edgeval_bychild;
	node **child;
	int cntr;

	 node(int a, int d)
	{
		keyv =a;
		cntr = 0;
		child = new node* [d];
		edgeval_bychild = 0;
	}
};

int findpathLength(int **distance);

int preorder( node *s);

int findminKey(int key[], bool mstSet[],int DIM);

void buildTree(int parent, int ch, int link_weight, node** s);

int printMST(int parent[], int n, int **graph, node **s,int DIM);

void prim(int **distance, node** s,int DIM);

//Greedy algorithm(Greedy.cpp)
int *greedy_algo(int **distance, int dim);

//Iterated Hill Climbing(HC.cpp)
struct Tabu{
	int **cycle;
	int value;
};

int Exchange3opt(int **distance, int dim, int **path);

int *Generate(int dim, unsigned seed);

int perturb(int **path,int dim,unsigned seed);

int **HC(int **distance, int dim, int *initial, double cutoff, unsigned seed);

// Simulated Annealing(SA.cpp)

int Exchange2opt(int **distance, int dim, int **path, unsigned seed);

int **SA(int *initial, int **distance, double T, double T_min , double r, double cutoff, int dim, unsigned seed);

//Branch and Bound algorithm(BnB.cpp)

struct Node{
	int end;
	int value;
	vector<int> *path;
	vector<int> *remain;
	double lowerbound;
	double time;
};

class CompareNode{
public:
	bool operator()(Node*& n1, Node*& n2)
	{
		return n1->lowerbound > n2->lowerbound;
	}
};

struct Edge{
	int start;
	int target;
	int length;
};

class CompareEdge{
public:
	bool operator()(Edge*& e1, Edge*& e2)
	{
		return e1->length > e2->length;
	}
};

int Kruskal(int **distance, vector<int> *set);

int FindMin(int *v, vector<int> *range);

int *Matrix(int **distance, int dim);

struct Node *BranchAndBound(int **distance, int dim, int *min, int start, double cutoff);