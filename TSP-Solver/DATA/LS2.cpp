#include"TSP.h"


int Exchange(int **distance, int dim, int **path)
{
	int *pos[dim];
	int flag=0;
	
	int i,j,k,l;
	for(i=0;i<dim;i++)
	{
		pos[i]=path[i];
	}
	
	int old,index,min,best=1e6;
	int temp[4];
	int current[4]={0,0,0,0};
	for(i=0;i<=dim-5;i++)
		for(k=dim-1-(i==0);k>=i+4;k--)
			for(j=i+2;j<=k-2;j++)
			{				
				index=0;
				
				old=distance[*path[i]][*path[i+1]]+distance[*path[j]][*path[j+1]]+distance[*path[k]][*path[(k+1)%dim]];
				temp[0]=distance[*path[i+1]][*path[j+1]]+distance[*path[k]][*path[i]]+distance[*path[(k+1)%dim]][*path[j]];
				temp[1]=distance[*path[i+1]][*path[k]]+distance[*path[j+1]][*path[(k+1)%dim]]+distance[*path[i]][*path[j]];
				temp[2]=distance[*path[i+1]][*path[k]]+distance[*path[j+1]][*path[i]]+distance[*path[(k+1)%dim]][*path[j]];
				temp[3]=distance[*path[i+1]][*path[(k+1)%dim]]+distance[*path[i]][*path[j+1]]+distance[*path[k]][*path[j]];
				
				min=old;
				for(l=0;l<4;l++)
				{
					if(temp[l]<min)
					{
						index=l+1;
						min=temp[l];
					}
				}
				
				if(index!=0)
				{
					if(min<best)
					{
						best=min;
						current[0]=i;
						current[1]=j;
						current[2]=k;
						current[3]=index;
					}
				}				
			}	
	
	i=current[0];
	j=current[1];
	k=current[2];
	switch(current[3])
	{
		case 0:
			flag=0;
			return flag;
		case 1:
			path[0]=pos[i+1];
			for(l=1;l<=k-j;l++)
				path[l]=pos[j+l];
			for(l=1;l<=dim-k+i;l++)
				path[k-j+l]=pos[(i-l+1+dim)%dim];
			for(l=1;l<=j-i-1;l++)
				path[dim+i-j+l]=pos[j-l+1];
			
			flag=1;
			return flag;
		case 2:
			path[0]=pos[i+1];
			for(l=1;l<=k-j;l++)
				path[l]=pos[k-l+1];
			for(l=1;l<=dim-k+i;l++)
				path[k-j+l]=pos[(k+l+dim)%dim];
			for(l=1;l<=j-i-1;l++)
				path[dim+i-j+l]=pos[j-l+1];
			
			flag=1;
			return flag;
		case 3:
			path[0]=pos[i+1];
			for(l=1;l<=k-j;l++)
				path[l]=pos[k-l+1];
			for(l=1;l<=dim-k+i;l++)
				path[k-j+l]=pos[(i-l+1+dim)%dim];
			for(l=1;l<=j-i-1;l++)
				path[dim+i-j+l]=pos[j-l+1];
			
			flag=1;
			return flag;
		case 4:
			path[0]=pos[i+1];
			for(l=1;l<=dim-k+i;l++)
				path[l]=pos[(k+l)%dim];
			for(l=1;l<=k-j;l++)
				path[dim-k+i+l]=pos[j+l];
			for(l=1;l<=j-i-1;l++)
				path[dim+i-j+l]=pos[j-l+1];
				
			flag=1;
			return flag;
	}				
}

int *Generate(int dim, unsigned seed)
{
	srand(seed);
	
	int i,j,k,l;
	int *edge=new int [4];
	
	i=rand()%dim;
	edge[0]=i;
	
	j=rand()%dim;
	while(abs(j-i)<2)
	{
		j=rand()%dim;
	}
	if(j<i)
	{
		edge[0]=j;
		edge[1]=i;
	}
	else
		edge[1]=j;
	
	k=rand()%dim;
	while(abs(k-i)<2||abs(k-j)<2)
	{
		k=rand()%dim;
	}
	if(k<edge[0])
	{
		edge[2]=edge[1];
		edge[1]=edge[0];
		edge[0]=k;
	}
	else if(k<edge[1])
	{
		edge[2]=edge[1];
		edge[1]=k;
	}
	else
		edge[2]=k;
	
	l=rand()%dim;
	while(abs(l-i)<2||abs(l-j)<2||abs(l-k)<2)
	{
		l=rand()%dim;
	}
	if(l<edge[0])
	{
		edge[3]=edge[2];
		edge[2]=edge[1];
		edge[1]=edge[0];
		edge[0]=l;
	}
	else if(l<edge[1])
	{
		edge[3]=edge[2];
		edge[2]=edge[1];
		edge[1]=l;
	}
	else if(l<edge[2])
	{
		edge[3]=edge[2];
		edge[2]=l;
	}
	else
		edge[3]=l;
	
	return edge;
}

int perturb(int **path,int dim,unsigned seed)
{	
	int *pos[dim];
	int n;
	for(n=0;n<dim;n++)
	{
		pos[n]=path[n];
	}
	
	int *edge;
	edge=Generate(dim, seed);
	
	path[0]=pos[edge[0]];
	for(n=1;n<=edge[3]-edge[2];n++)
		path[n]=pos[edge[2]+n];
	for(n=1;n<=edge[2]-edge[1];n++)
		path[edge[3]-edge[2]+n]=pos[edge[1]+n];
	for(n=1;n<=edge[1]-edge[0];n++)
		path[edge[3]-edge[1]+n]=pos[edge[0]+n];
	for(n=1;n<=dim-edge[3]+edge[0]-1;n++)
		path[edge[3]-edge[0]+n]=pos[(edge[3]+n)%dim];

	return 0;
}

int **LS(int **distance, int dim, int *initial, double cutoff, unsigned seed)
{
	int **path=new int *[dim];
	int **min=new int *[dim];
	int pathlength=0;
	int temp=0;
	
	clock_t start=clock();
	
	int i,j,k,l;
	for(i=0;i<dim;i++)
	{
		path[i]=&initial[i];
		min[i]=&initial[i];
	}
	
	for(i=0;i<dim;i++)
	{
		temp += distance[*min[i]][*min[(i+1)%dim]];
	}
			
	while((clock()-start)/(float) CLOCKS_PER_SEC<=cutoff)
	{
		if(Exchange(distance,dim,path)==0)
		{
			for(i=0;i<dim;i++)
			{
				pathlength += distance[*path[i]][*path[(i+1)%dim]];
			}
			if(pathlength<temp)
			{
				for(i=0;i<dim;i++)
					min[i]=path[i];
				temp=pathlength;
			}
			else
			{
				for(i=0;i<dim;i++)
					path[i]=min[i];
			}
			perturb(path,dim,seed);
		}
	}
	return min;
}

int **SA(int *initial, int **distance, double T, double T_min , double r, double cutoff, int dim){
//	clock_t start=clock();
	int newpathlegth = 0;
	
	int **path=new int *[dim];
	int **min=new int *[dim];
	int pathlength=0;
	int temp=0;
	
	clock_t start=clock();
	
	int i,j,k,l;
	for(i=0;i<dim;i++)
	{
		path[i]=&initial[i];
		min[i]=&initial[i];
	}
	while((clock()-start)/(float) CLOCKS_PER_SEC<=cutoff and T >= T_min){
	//while (T >= T_min){
		int pathlength = 0;
		int newpathlength = 0;
		int dE = 0; int i = 0;
		for(i=0;i<dim-1;i++)
			{
				pathlength += distance[*path[i]][*path[i+1]];
			}
		pathlength += distance[*path[dim-1]][*path[0]];

		Exchange(distance,dim,path);
		newpathlength = 0;
		for(i=0;i<dim-1;i++)
			{
				newpathlength += distance[*path[i]][*path[i+1]];
			}
		newpathlength += distance[*path[dim-1]][*path[0]];

		dE = -(newpathlength) - pathlength;
		if(dE <= 0){
			if(exp((double)dE / (double)T) > rand()){
				T = T * r;
			}
		}

	
	}
		return path;
}

int main(int argc, char* argv[])
{
	cout<< "This program only implements Local Search algorithm for competition!"<<endl;
	string Methods []= {"Approx", "Greedy", "LS1","LS2","BnB"};
	
	int **distance;
	int *d=new int;
	int *o=new int;
	distance=readgraph(argv[1],d,o);
	int temp = 0;

	int dim=*d;
	int opt=*o;
	double cutoff = 60*strtod(argv[2],NULL);
	int seed=atoi(argv[4]);
	
	int i;
	int pathlength = 0;
	double gap;
	
	if(Methods[3].compare(argv[3])==0)
	{
		cout << "Method:" << "LS2"<<endl;
		int **path;
		int *initial;
		initial=greedy_algo(distance, dim);

		temp = distance[initial[3]][initial[4]]+ dim;
		double cooling_r = 0.999;
		path = SA(initial, distance, temp, 0.001, cooling_r, cutoff, dim);
		
		cout<<"Path:";
		for(i=0;i<dim-1;i++)
		{
			cout<<*path[i]<<"->";
			pathlength += distance[*path[i]][*path[i+1]];
		}
		cout<<*path[dim-1]<<"->"<<*path[0]<<endl;
		cout<<"Path Length:";
		pathlength += distance[*path[dim-1]][*path[0]];
		cout<<pathlength<<endl;
		
		gap = (float)(pathlength-opt)/opt;
		cout << "Solution gap:" << 100*gap << "%" << endl;
		return 0;
	}
	return 0;
}
