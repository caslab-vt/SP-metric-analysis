#include"TSP.h"
//Implement Branch-and-Bound algorithm with MST lowerbound(Kruskal)
//Using best-node branching strategy

int Kruskal(int **distance, vector<int> *set)
{
	int n=set->size();
	int MST=0;

	priority_queue<Edge*, vector<Edge*>, CompareEdge> pq;
	
	int i,j,k;
	struct Edge *e;
	for(i=0;i<n;i++)
	{
		k=1;
		for(vector<int>::iterator it=set->begin();it!=set->end();++it)
		{
			if(*it<=set->at(i))
				continue;
			e=new struct Edge;
			e->start=i;
			e->target=i+(k++);
			e->length=distance[set->at(i)][*it];
			pq.push(e);
		}
	}
	int *connect[n];
	for(i=0;i<n;i++)
	{
		connect[i]=new int [n];
		for(j=0;j<n;j++)
			connect[i][j]=0;
		connect[i][i]=1;
	}

	struct Edge *p;
	i=0;
	while(i!=n-1)
	{
		p=pq.top();
		pq.pop();
		
		if(connect[p->start][p->target]!=1)
		{
			for(k=0;k<n;k++)
				connect[p->start][k]=(connect[p->start][k]+connect[p->target][k]);
			for(k=0;k<n;k++)
			{
				if(connect[p->start][k]==1)
					connect[k]=connect[p->start];
			}
			MST += p->length;
			i++;
		}
	}

//	cout << "freeing Kruskal: e"<< endl;
//	delete e;
//	cout << "freeing Kruskal: connect"<< endl;

//	for(i=0;i<n;i++)
//	{
//	delete [] connect[i]; 
//	}
//	delete [] connect;
	return MST;
}
//Find the edge minimum length between a node and a subset of its neighbours
int FindMin(int *v, vector<int> *range)
{
	int temp, index=range->front();
	temp=v[range->front()];
	
	for(vector<int>::iterator it=range->begin();it!=range->end();++it)
	{
		if(temp>v[*it])
		{
			temp=v[*it];
			index=*it;
		}
	}	
	return index;
}

//Find the outgoing and income edges with minimum length of each node
int *Matrix(int **distance, int dim)
{
	int *min= new int [2*dim];
	int i, index1, index2;
	
	vector<int> *range=new vector<int>();
	for(i=0;i<dim;i++)
		range->push_back(i);
		
	for(i=0;i<dim;i++)
	{
		index1=FindMin(distance[i],range);
		min[2*i]=distance[i][index1];
		range->erase(range->begin()+index1);
		index2=FindMin(distance[i],range);
		min[2*i+1]=distance[i][index2];
		range->insert(range->begin()+index1,index1);
	}
	return min;
}

//Branch-and-Bound algorithm using the sum of the minimum outgoing and incoming edges as lowerbound
struct Node *BranchAndBound(int **distance, int dim, int *min, int start, double cutoff)
{
	double bestbound=INT_MAX;
	int i;

	clock_t startBnB = clock();
	
	struct Node *root= new struct Node;
	root->end=start;
	root->value=0;
	
	root->path= new vector<int>();
	root->path->push_back(start);
	
	root->remain=new vector<int>();
	for(i=0;i<dim;i++)
	{
		if(i==start)
			continue;
		else
			root->remain->push_back(i);
	}
	
	root->lowerbound=(min[2*start]+min[2*start+1])+Kruskal(distance,root->remain);
	
	root->time=(clock()-startBnB)/(float) CLOCKS_PER_SEC;
		
	priority_queue<Node*, vector<Node*>, CompareNode> pq;
	pq.push(root);
	
	struct Node *p, *q, *opt;
	double temp;
	int index,index1,index2,obj,End,Value;
	vector<int> *u,*v;
	opt=NULL;
	while(!pq.empty())
	{
		p=pq.top();
		pq.pop();
		if(p->lowerbound>=bestbound)
		{
			opt->time=(clock()-startBnB)/(float) CLOCKS_PER_SEC;
			return opt;
		}
		for(vector<int>::const_iterator it= p->remain->begin(); it!=p->remain->end();++it)
		{
			q= new struct Node;

			q->end=*it;
			q->value=p->value+distance[p->end][q->end];
			
			q->path=new vector<int>();
			for(vector<int>::const_iterator k=p->path->begin();k!=p->path->end();++k)
				q->path->push_back(*k);
			q->path->push_back(q->end);
			q->remain=new vector<int>();
			for(vector<int>::const_iterator j=p->remain->begin();j!=p->remain->end();++j)
			{
				if(*j==q->end)
					continue;
				q->remain->push_back(*j);
			}
			
			if(q->remain->size()==1)
			{
				q->path->push_back(q->remain->at(0));
				q->value = q->value+distance[q->end][q->remain->at(0)]+distance[q->remain->at(0)][start];
				q->end=q->remain->at(0);
				if(q->value<bestbound)
				{
					bestbound=q->value;
					opt=q;
					opt->time=(clock()-startBnB)/(float) CLOCKS_PER_SEC;
					cout<< opt->time << " " << bestbound <<endl;
					output_trace << opt->time << " " << bestbound <<endl;
				}
				continue;
			}
			
			index1=FindMin(distance[start], q->remain);
			index2=FindMin(distance[q->end], q->remain);
			q->lowerbound=distance[start][index1]+distance[q->end][index2]+q->value+Kruskal(distance, q->remain);
			q->time=(clock()-startBnB)/(float) CLOCKS_PER_SEC;
			
			if(q->lowerbound<=bestbound)
				pq.push(q);
			else
				delete q;
				
			if((clock()-startBnB)/(float) CLOCKS_PER_SEC>=cutoff)
			{
				if(opt==NULL)
				{
					cout<< "Algorithm run out of time and no solution found!"<< endl;
					cout<< "Use greedy to construct a solution:"<<endl;
					p=pq.top();
					End=p->end;
					Value=p->value;
					u=new vector<int>();
					for(vector<int>::iterator it=p->path->begin();it!=p->path->end();++it)
						u->push_back(*it);
					v=new vector<int>();
					for(vector<int>::iterator it=p->remain->begin();it!=p->remain->end();++it)
						v->push_back(*it);
						
					while(!v->empty())
					{
						index=FindMin(distance[End], v);
						Value += distance[End][index];
						u->push_back(index);
						for(vector<int>::iterator it=v->begin();it!=v->end();++it)
						{
							if(*it==index)
							{
								v->erase(it);
								break;
							}
						}
						End=index;
					}
					
					opt= new struct Node;
					opt->end=End;
					opt->value=Value+distance[opt->end][start];
					opt->path=u;
					opt->remain=v;
					opt->time=(clock()-startBnB)/(float) CLOCKS_PER_SEC;
					return opt;
				}
				else 
				{
					cout<< "Algorithm run out of time!" << endl;
					cout << "Current best solution:" << endl;
					opt->time=(clock()-startBnB)/(float) CLOCKS_PER_SEC;
					return opt;
				}
			}
		}
	}
	opt->time=(clock()-startBnB)/(float) CLOCKS_PER_SEC;

	cout << "freeing inside bnb func: root"<< endl;
//	delete[] root->path;
//	delete[] root->remain;
	delete root;
	cout << "freeing inside bnb func: q"<< endl;
//	delete[] q->path;
//	delete[] q->remain;
	delete q;
	cout << "freeing inside bnb func: u v"<< endl;
	delete[] u;
	delete[] v;

	return opt;
}
