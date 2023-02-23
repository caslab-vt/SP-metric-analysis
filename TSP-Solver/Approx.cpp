#include "TSP.h"
//Implement 2-approximation algorithm
//Using Prim algorithm to find MST

stack<int> Path;

int findpathLength(int **distance){
	int temp1 = 0, temp2 = 0, Pathlength=0;
	int initial = Path.top();
	while(!Path.empty()){
		temp1 = Path.top();
		Path.pop();
		if(!Path.empty()){
			temp2 = Path.top();
			Pathlength += distance[temp1][temp2];
		}
	}
	Pathlength += distance[temp2][initial];
	output_sol << Pathlength << endl;
	return Pathlength;
}

int preorder( node *s){
	int temp = 0, i = 0;
	cout<< (s->keyv + 1) << ",";
	output_sol << (s->keyv + 1) << ",";
	Path.push(s->keyv);
	temp = s->cntr;
	for(i = 0; i < temp; i++){
		preorder( s->child[i]);
	}
}

int findminKey(int key[], bool mstSet[],int DIM)
{
   // Initialize min value
   int min = INT_MAX, min_index;

   for (int v = 0; v < DIM; v++)
     if (mstSet[v] == false && key[v] < min)
         min = key[v], min_index = v;

   return min_index;
}

void buildTree(int parent, int ch, int link_weight, node** s){
	int temp = 0;
	temp = ((*(s+parent))->cntr);

	(*(s+parent))-> child[temp] = (*(s + ch));
	(*(s+ch))->edgeval_bychild = link_weight;
	((*(s+parent))->cntr)++;

}

int printMST(int parent[], int n, int **graph, node **s,int DIM)
{
   int tot_wt = 0;
   for (int i = 1; i < DIM; i++){
      buildTree(parent[i], i, graph[i][parent[i]], s);
   	  tot_wt += graph[i][parent[i]];
   }
   return 0;
}

void prim(int **distance, node** s,int DIM)
{
     int parent[DIM]; // Array to store constructed MST
     int key[DIM];   // Key values used to pick minimum weight edge in cut
     bool mstSet[DIM];  // To represent set of vertices not yet included in MST

     for (int i = 0; i < DIM; i++)
        key[i] = INT_MAX, mstSet[i] = false;

     key[0] = 0;
     parent[0] = -1;


     for (int count = 0; count < DIM-1; count++)
     {

        int u = findminKey(key, mstSet,DIM);

        mstSet[u] = true;

        for (int v = 0; v < DIM; v++)
          if (distance[u][v] && mstSet[v] == false && distance[u][v] <  key[v])
             parent[v]  = u, key[v] = distance[u][v];
     }

     printMST(parent, DIM, distance, s,DIM);
}



