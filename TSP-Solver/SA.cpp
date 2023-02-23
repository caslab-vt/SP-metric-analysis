#include"TSP.h"
//Implement Simulated Annealing algorithm
//with 2-opt exchange


int Exchange2opt(int **distance, int dim, int **path, unsigned seed)
{
	int *pos[dim];
	int bools =1;
	int k,i,j,l;
	for(k=0;k<dim;k++)
	{
		pos[k]=path[k];
	}
	
	//Randomly generate i and j,j>i+1
	srand(seed);
    while(bools == 1){
        i = rand()%dim;
            j = rand()%dim;
            if(j > i + 1){
                bools = 0;
            }
    }
	int d;
	
	path[0]=pos[(j+1)%dim];
	for(l=1;l<=j-i;l++)
		path[l]=pos[i+l];
	for(l=0;l<=dim-j+i-2;l++)
		path[j-i+l+1]=pos[(i-l+dim)%dim];

	return 0;
}

int **SA(int *initial, int **distance, double T, double T_min , double r, double cutoff, int dim, unsigned seed){

	int newpathlegth = 0;
	int T_max = T;
	int **path=new int *[dim];
	int **min=new int *[dim];
	int **best=new int *[dim];
	int pathlength=0;
	int temp=0;
	int oldpathlength = 0;
	int newpathlength = 0;
	int temppath = 0;
	int dE=0;
	clock_t start=clock();
	srand(seed);
	int i,j,k,l;
	
	for(i=0;i<dim;i++)
	{
		path[i]=&initial[i];
		min[i]=&initial[i];
		best[i]=&initial[i];
	}
	for(i=0;i<dim-1;i++)
	{
		oldpathlength += distance[*path[i]][*path[i+1]];
	}
	oldpathlength += distance[*path[dim-1]][*path[0]];
	Exchange2opt(distance,dim,path,seed);
	newpathlength = 0;
	for(i=0;i<dim-1;i++)
	{
		newpathlength += distance[*path[i]][*path[i+1]];
	}
	newpathlength += distance[*path[dim-1]][*path[0]];
	temppath = newpathlength;
	while((clock()-start)/(float) CLOCKS_PER_SEC<=cutoff ){
	
		newpathlength = 0;
		dE = 0; i = 0;
		Exchange2opt(distance,dim,path,seed);
		newpathlength = 0;
		for(i=0;i<dim-1;i++)
		{
			newpathlength += distance[*path[i]][*path[i+1]];
		}
		newpathlength += distance[*path[dim-1]][*path[0]];
		
		dE = (newpathlength) - temppath;
		double prob = -(double)dE / (double)T ;
		if(dE < 0 or exp(prob) > rand()){
			if(dE < 0){
				for(i=0;i<dim;i++)
					best[i]=path[i];
			    temppath = 0;
				for(i=0;i<dim-1;i++)
					temppath += distance[*path[i]][*path[i+1]];
						
				temppath += distance[*path[dim-1]][*path[0]];
				
				cout << (clock()-start)/(float) CLOCKS_PER_SEC<<" "<< temppath << endl;		
				output_trace << (clock()-start)/(float) CLOCKS_PER_SEC << " " << temppath <<endl;
			}
				T = T * r;
				for(i=0;i<dim;i++)
					min[i]=path[i];

				for(i=0;i<dim-1;i++)
					newpathlength += distance[*path[i]][*path[i+1]];
						
				newpathlength += distance[*path[dim-1]][*path[0]];
				oldpathlength = newpathlength;
		}	
		if(T == T_min){
			T = T_max;
		}
	}
		return best;
}