#include"TSP.h"
//Implement greedy algorithm using farthest insertion

int *greedy_algo(int **distance, int dim)
{
    int max = 0; int i,j;

    int visited[dim];
    int *path=new int [dim];
    int minimum[dim];
    int min_index[dim];
    int index;
    int min, sum, left;

    int path_len, max_index;

    for(i=0;i<dim;i++)
        visited[i] = 0;

    visited[0] = 1;

    max = distance[0][1];
    for(i=2;i<dim;i++){
        if(max < distance[0][i]){
            max = distance[0][i];
            index = i;
        }
    }

    visited[index] = 1;

    path[0] = 0;
    path[1] = index;
    path_len = 2;

    while(path_len < dim){
        for(i=0;i<dim;i++){
            if(visited[i] == 0){
                min = distance[path[0]][i] + distance[path[1]][i] - distance[path[0]][path[1]];
                index = 0;
                for(j=1;j<path_len-1;j++){
                    sum = distance[path[j]][i] + distance[path[j+1]][i] - distance[path[j]][path[j+1]];
                    if(sum < min){
                        min = sum;
                        index = j;
                    }
                }
                sum = distance[path[path_len-1]][i] + distance[path[0]][i] - distance[path[path_len-1]][path[0]];
                if(sum < min){
                    min = sum;
                    index = path_len-1;
                }

                minimum[i] = min;
                min_index[i] = index;
            }
            else{
                minimum[i] = INT_MIN;
                min_index[i] = INT_MIN;
            }
        }

        max = minimum[0];
        max_index = 0;
        for(i=1;i<dim;i++){
            if(minimum[i] > max){
                max = minimum[i];
                max_index = i;
            }
        }

        for(i = path_len-1; i>=(min_index[max_index] + 1); i--){
            path[i+1] = path[i];
        }

        path[i+1] = max_index;    
        visited[max_index] = 1;
        path_len++;
    }
	
	return path;  
}
