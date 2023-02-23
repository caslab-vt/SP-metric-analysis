#include"TSP.h"
//Read graph from dataset and construct the pairwise distance matrix

using namespace std;

double PI=3.141592;
double RRR=6378.388;
string NAME;
int **readgraph(char *graph, int *p, int*q)
{
	ifstream file(graph);

	if(file.fail())
	{
		cerr << "Error opening file!" << endl;
		return 0;
	}
	
	string comment, graphtype, STRING;
	int dim, opt;
	file.seekg(6);
	file >> NAME;
	file.seekg(10,ios::cur);
	getline(file,comment);
	file.seekg(11,ios::cur);
	file >> dim;
	file >> graphtype >> graphtype;
	file.seekg(14,ios::cur);
	file >> opt;
	file >> STRING;

	double coord[dim][2];
	int num, i, k;
	for(i=0;i<dim;i++)
	{
		file >> num >> coord[i][0] >> coord[i][1];
	}
	
	
	//Building the matrix of pairwise distance.
	int **distance=new int* [dim];
	
	for(i=0;i<dim;i++)
	{
		distance[i]= new int [dim];
		distance[i][i]=INT_MAX;
	}
		
		
	float xd,yd;
	float m, q1, q2, q3;
	int deg, d;
	
	if(graphtype == "EUC_2D")
	{
		for(i=0;i<dim;i++)
			for(k=i+1;k<dim;k++)
			{
				xd=coord[k][0]-coord[i][0];
				yd=coord[k][1]-coord[i][1];
				d=round(sqrt(xd*xd+yd*yd));
				distance[i][k]=d;
				distance[k][i]=d;
			}
	}
	else
	{
		for(i=0;i<dim;i++)
		{
			deg=trunc(coord[i][0]);
			m=coord[i][0]-deg;
			coord[i][0]=PI*(deg+5*m/3.0)/180.0;
			deg=trunc(coord[i][1]);
			m=coord[i][1]-deg;
			coord[i][1]=PI*(deg+5*m/3.0)/180.0;
		}
		for(i=0;i<dim;i++)
			for(k=i+1;k<dim;k++)
			{
				q1=cos(coord[i][1]-coord[k][1]);
				q2=cos(coord[i][0]-coord[k][0]);
				q3=cos(coord[i][0]+coord[k][0]);
				d=(int)(RRR*acos(0.5*((1+q1)*q2-(1-q1)*q3))+1);
				distance[i][k]=d;
				distance[k][i]=d;
			}
	}
	file.close();
	*p=dim;
	*q=opt;
	return distance;
}		