#include"TSP.h"
//Implement Iterated Hill Climbing with 3-opt exchange
//4-opt perturbation and Tabu Search

int Exchange3opt(int **distance, int dim, int **path)
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

	delete edge;
	return 0;
}

int **HC(int **distance, int dim, int *initial, double cutoff, unsigned seed)
{
	int **path=new int *[dim];
	int **min=new int *[dim];
//	int** connect = new int *[dim];
	int pathlength=0;
	int v=0;
	cout << "dim size:" << dim<< endl;
	clock_t start=clock();
	
	int i,j,k,l;
//	for(int i = 0; i < dim; i++)
//	 {connect[i]=&i;} 

	for(i=0;i<dim;i++)
	{
		path[i]=&initial[i];
//		std::cout << "path[i]" << initial[i]<< endl;
		min[i]=&initial[i];
	}
	std::cout << "i pTH size:" << i<< endl;
	for(i=0;i<dim;i++)
	{
		v += distance[*min[i]][*min[(i+1)%dim]];
	}

	
	stack<struct Tabu *> T;
	struct Tabu *mem= new struct Tabu;
	mem->cycle=min;
	mem->value=v;
	T.push(mem);
	int current=v;
	struct Tabu *temp;
	while((clock()-start)/(float) CLOCKS_PER_SEC<=cutoff)
	{
		if(Exchange3opt(distance,dim,path)==0)
		{
			pathlength=0;
			for(i=0;i<dim;i++)
				pathlength += distance[*path[i]][*path[(i+1)%dim]];

			while(!T.empty())
			{
				temp=T.top();
				if(pathlength<=temp->value)
				{
					T.pop();
					if(T.empty()&&pathlength<temp->value)
					{
						cout<< (clock()-start)/(float) CLOCKS_PER_SEC << " " << pathlength <<endl;
						output_trace << (clock()-start)/(float) CLOCKS_PER_SEC << " " << pathlength <<endl;
					}
					continue;
				}
				else if(temp->value<pathlength&&pathlength<2*v)
				{
					if(T.size()<10)
					{
						mem= new struct Tabu;
						mem->cycle=new int *[dim];
						for(i=0;i<dim;i++)
							mem->cycle[i]=path[i];
						mem->value=pathlength;
						T.push(mem);
						break;
					}
					else
					{
						for(i=0;i<dim;i++)
							path[i]=temp->cycle[i];
						break;
					}
				}
				else
				{
					for(i=0;i<dim;i++)
						path[i]=temp->cycle[i];
					break;
				}
			}
			if(T.empty())
			{
				mem= new struct Tabu;
				mem->cycle=new int *[dim];
				for(i=0;i<dim;i++)
					mem->cycle[i]=path[i];
				mem->value=pathlength;
				v=mem->value;
				T.push(mem);
			}
			perturb(path,dim,seed);
		}
	}
	while(T.size()>1)
		T.pop();
	temp=T.top();
//	delete[] mem->cycle;
//	delete mem;
	cout << "freeing HC: path min"<< endl;

//	for(i=0;i<dim;i++)
//	{
//	std::cout << "path i element:" << *path[i]<< endl;
//	std::cout << "min i element:" << *min[i]<< endl;
//	std::cout << "delete i index:" << i<< endl;
//		delete path[i];
//		delete min[i];
//	}

//	delete [] path;
//	delete [] min;
//	delete[] connect;
	cout << "freed HC: path min"<< endl;
	return temp->cycle;
}
