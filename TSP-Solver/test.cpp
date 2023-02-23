#include<iostream>
#include<fstream>
#include<vector>
#include<queue>
#include<string>
#include<cmath>
#include<ctime>
#include<cstdlib>

int main()
{	int dim=5;
 	int *initial=[1,2,3,4,5];
	int** connect = new int *[dim];
	for(int i = 0; i < dim; i++)
	 {
	  connect[i]=&initial[i];
	  } 
	cout << "freeing HC: path min"<< endl;
	for(int i=0;i<dim;i++)
	{

	cout << "min i element:" << *connect[i]<< endl;
	cout << "delete i index:" << i<< endl;
		delete &connect[i];

	}
	delete[] connect;
return 0;
}
