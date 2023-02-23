#pragma warning(push, 0)
#include <SimpleAmqpClient/SimpleAmqpClient.h>
#pragma warning(pop)
#include"TSP.h"
#include<fstream>
#include <string.h>
#include<chrono>
//Main function calling different methods to solve TSP
//Print output into .sol and .trace file

using namespace std;
using namespace AmqpClient;

ofstream output_sol,output_trace;
constexpr auto QUEUE_NAME = "tspst";
constexpr auto QUEUE_NAME1 = "tspopt";

double get_time_point();

int main(int argc, char* argv[])
{	
	string Methods []= {"Approx", "Greedy", "LS1","LS2","BnB"};
	string filename1,filename2;
	
	int **distance;
	int *d=new int;
	int *o=new int;
	distance=readgraph(argv[1],d,o);
	cout << "NAME" << NAME << endl;
	int dim=*d;
	int opt=*o;
	double cutoff = strtod(argv[2],NULL);
	int seed=atoi(argv[4]);
	
	int i;
	int pathlength = 0;
	double gap;
//	ofstream myfile;
//	myfile.open ("TSP_time.txt");
//	//rabbitmq-cpp library
	auto channel = AmqpClient::Channel::Create();
	channel->DeclareQueue(QUEUE_NAME, false, true, false, true);
	auto channel1 = AmqpClient::Channel::Create();
	channel1->DeclareQueue(QUEUE_NAME1, false, true, false, true);
//	std::string s;
//	std::string s1;
//	auto message = AmqpClient::BasicMessage::Create("Hello World!");
//	channel->BasicPublish("", QUEUE_NAME, message);

//    auto consumerTag = channel->BasicConsume(QUEUE_NAME);
//    clog << "Consumer tag: " << consumerTag << endl;
//    auto envelop = channel->BasicConsumeMessage(consumerTag);
//    clog << " [x] Received " << envelop->Message()->Body() << endl;

	double begin_time = get_time_point()/1e6;
	string s = to_string(begin_time);

//    for(int ii=0;ii<40;ii++)
//	{
//	//rabbitmq-cpp library
////	auto channel = AmqpClient::Channel::Create();
////	channel->DeclareQueue(QUEUE_NAME, false, true, false, true);
//	double begin_time = get_time_point()/1e6;
//	//write start time to file
//  	myfile << begin_time ;
//  	myfile << " " ;
//	cout << "begin time: " << begin_time << endl;
//	cout << "loop count: " << ii << endl;
	//send to rabbitmq server
//   	string s1 = to_string(begin_time);
//	cout << "begin time string: " << s1 << endl;
//	auto message = AmqpClient::BasicMessage::Create(s1);
//	channel->BasicPublish("", QUEUE_NAME, message);
//	auto message = AmqpClient::BasicMessage::Create("Hello World!");
//	channel->BasicPublish("", QUEUE_NAME, message);

	if(Methods[0].compare(argv[3])==0)
	{
		cout << "Method:" << "Approximation"<<endl;

		filename1 = NAME + "_" + Methods[0] + "_"+argv[2]+".sol";
		const char *name1 = filename1.c_str();
		output_sol.open(name1);
	
		if (!output_sol.is_open())
		{
			cout << "Failed to create output file!" << endl;
			return 0;
		}
		
		node** s = new node* [dim];
		i = 0;
		for (i=0;i<dim;i++){
			s[i] = new node(i, dim);
		}

		prim(distance,s,dim);		
		cout<<"Path:";
		preorder(s[0]);
		cout<< s[0]->keyv+1<<endl;
		output_sol << s[0]->keyv+1 << endl;
		cout<<"Path Length:";
		pathlength = findpathLength(distance);
		cout<<pathlength<<endl;
		
		gap = (float)(pathlength-opt)/opt;
		cout << "Solution gap:" << 100*gap << "%" << endl;
		
		cout << endl << "Output file created!" << endl;
		output_sol.close();
		output_trace.close();
		return 0;
	}
	
	if(Methods[1].compare(argv[3])==0)
	{	
		cout << "Method:" << "Greedy"<<endl;
		
		filename1 = NAME + "_" + Methods[1] + "_"+argv[2]+".sol";
		const char *name1 = filename1.c_str();
		output_sol.open(name1);
		
		if (!output_sol.is_open())
		{
			cout << "Failed to create output file!" << endl;
			return 0;
		}
		
		int *path;
		path=greedy_algo(distance, dim);
		
		cout<<"Path:";
		
		for(i=0;i<dim-1;i++)
			pathlength += distance[path[i]][path[i+1]];
		pathlength += distance[path[dim-1]][path[0]];
		output_sol << pathlength <<endl;
		for(i=0;i<dim-1;i++)
		{
			cout<<path[i]+1<<",";
			output_sol << path[i]+1<<",";
		}
		cout<<path[dim-1]+1<<","<<path[0]+1<<endl;
		output_sol<<path[dim-1]+1<<","<<path[0]+1<<endl;
		
		cout<<"Path Length:";
		cout<<pathlength<<endl;
		
		gap = (float)(pathlength-opt)/opt;
		cout << "Solution gap:" << 100*gap << "%" << endl;
		
		cout << endl << "Output file created!" << endl;
		output_sol.close();
		output_trace.close();
		return 0;
	}
	
	if(Methods[2].compare(argv[3])==0)
	{
		cout << "Method:" << "Iterated Hill Climbing"<<endl;
		
		filename1 = NAME + "_" + Methods[2] + "_"+argv[2]+"_"+argv[4]+".sol";
		const char *name1 = filename1.c_str();
		filename2 = NAME + "_" + Methods[2] + "_"+argv[2]+"_"+argv[4]+".trace";
		const char *name2 = filename2.c_str();
		output_sol.open(name1);
		output_trace.open(name2);
		if (!output_sol.is_open()|| !output_trace.is_open())
		{
			cout << "Failed to create output file!" << endl;
			return 0;
		}

		int **path;
		int *initial;
		initial=greedy_algo(distance, dim);
		path= HC(distance, dim, initial, cutoff, i);
		
		cout<<"Path:";
		
		for(i=0;i<dim-1;i++)
			pathlength += distance[*path[i]][*path[i+1]];
		pathlength += distance[*path[dim-1]][*path[0]];
		output_sol << pathlength <<endl;
		for(i=0;i<dim-1;i++)
		{
			cout<<*path[i]+1<<",";
			output_sol << *path[i]+1<<",";
		}
		cout<<*path[dim-1]+1<<","<<*path[0]+1<<endl;
		output_sol<<*path[dim-1]+1<<","<<*path[0]+1<<endl;
		
		cout<<"Path Length:";
		cout<<pathlength<<endl;

		gap = (float)(pathlength-opt)/opt;

		cout << "Solution gap:" << begin_time << " " << 100*gap << endl;
		cout << "Elapsed time:" << cutoff << "s" <<endl;

   		string s1 = to_string(100*gap);
		auto message1 = AmqpClient::BasicMessage::Create(s1);
		channel1->BasicPublish("", QUEUE_NAME1, message1);

		auto message = AmqpClient::BasicMessage::Create(s);
		channel->BasicPublish("", QUEUE_NAME, message);
		
		cout << endl << "Output file created!" << endl;
		output_sol.close();
		output_trace.close();
		return 0;
	}
	
	if(Methods[3].compare(argv[3])==0)
	{
		cout << "Method:" << "Simulated Annealing"<<endl;
		
		filename1 = NAME + "_" + Methods[3] + "_"+argv[2]+"_"+argv[4]+".sol";
		const char *name1 = filename1.c_str();
		filename2 = NAME + "_" + Methods[3] + "_"+argv[2]+"_"+argv[4]+".trace";
		const char *name2 = filename2.c_str();
		output_sol.open(name1);
		output_trace.open(name2);
		if (!output_sol.is_open()|| !output_trace.is_open())
		{
			cout << "Failed to create output file!" << endl;
			return 0;
		}
		
		int **path;
		int *initial;
		initial=greedy_algo(distance, dim);

		int temp = distance[initial[9]][initial[10]]*2*dim;
		double cooling_r = 0.99;
		path = SA(initial, distance, temp, 0.1*dim, cooling_r, cutoff, dim, seed);
		
		cout<<"Path:";
		for(i=0;i<dim-1;i++)
			pathlength += distance[*path[i]][*path[i+1]];
		pathlength += distance[*path[dim-1]][*path[0]];
		output_sol << pathlength <<endl;
		for(i=0;i<dim-1;i++)
		{
			cout<<*path[i]+1<<",";
			output_sol << *path[i]+1<<",";
		}
		cout<<*path[dim-1]+1<<","<<*path[0]+1<<endl;
		output_sol<<*path[dim-1]+1<<","<<*path[0]+1<<endl;
		
		cout<<"Path Length:";
		cout<<pathlength<<endl;
//	  	myfile << pathlength;
//		myfile << " " ;
		gap = (float)(pathlength-opt)/opt;
		cout << "Solution gap:" << 100*gap << "%" << endl;
//	  	myfile << gap;
//		myfile << " " ;
//		cout << "Elapsed time:" << cutoff << "s" <<endl;
		
		cout << endl << "Output file created!" << endl;
		output_sol.close();
		output_trace.close();
		return 0;
	}
	
	if(Methods[4].compare(argv[3])==0)
	{
		cout << "Method:" << "Branch and Bound"<<endl;
		
		filename1 = NAME + "_" + Methods[4] + "_"+argv[2]+".sol";
		const char *name1 = filename1.c_str();
		filename2 = NAME + "_" + Methods[4] + "_"+argv[2]+".trace";
		const char *name2 = filename2.c_str();
		output_sol.open(name1);
		output_trace.open(name2);
		if (!output_sol.is_open()|| !output_trace.is_open())
		{
			cout << "Failed to create output file!" << endl;
			return 0;
		}
		
		int *min;
		min=Matrix(distance,dim);
		struct Node *solution;
		int source=0;
		solution=BranchAndBound(distance, dim, min, source, cutoff);
		
		if(solution->time<cutoff)
		{
			cout << "Optimal solution found:"<< endl;
			cout << "Total cost:" << solution->value << endl;
			output_sol << solution->value <<endl;
			cout << "Optimal cycle:" ;
			for(vector<int>::const_iterator it=solution->path->begin();it!=solution->path->end();it++)
			{
				cout<<*it+1<<",";
				output_sol <<*it+1<<",";
			}
			cout << source+1 << endl;
			output_sol<< source+1 << endl;
			cout << "Elapsed time:"<< solution->time << "s" << endl;

	   		string s1 = to_string(100);
			auto message1 = AmqpClient::BasicMessage::Create(s1);
			channel1->BasicPublish("", QUEUE_NAME1, message1);

			auto message = AmqpClient::BasicMessage::Create(s);
			channel->BasicPublish("", QUEUE_NAME, message);


		}
		else
		{
			cout << "Total cost:" << solution->value << endl;
			output_sol << solution->value <<endl;
			gap = (float)(solution->value-opt)/opt;
			cout << "Solution gap:" << 100*gap << "%" << endl;
			cout << "Solution cycle:" ;
			for(vector<int>::const_iterator it=solution->path->begin();it!=solution->path->end();it++)
			{
				cout<<*it+1<<",";
				output_sol <<*it+1<<",";
			}
			cout << source+1 << endl;
			output_sol<< source+1 << endl;
			cout << "Elapsed time:"<< solution->time << "s" << endl;
	   		string s1 = to_string(100*gap);
			auto message1 = AmqpClient::BasicMessage::Create(s1);
			channel1->BasicPublish("", QUEUE_NAME1, message1);

			auto message = AmqpClient::BasicMessage::Create(s);
			channel->BasicPublish("", QUEUE_NAME, message);
		}
		
		cout << endl << "Output file created!" << endl;
		output_sol.close();
		output_trace.close();
		cout << "freeing min array"<< endl;
		delete[] min; 
		cout << "freeing solution"<< endl;
		delete solution;
		return 0;
	}

//  	myfile << gap ;
//  	myfile << " " ;
//  	myfile << pathlength ;
//  	myfile << " " ;

//  	myfile << "\n" ;
//    }
//	  myfile.close();
//return 0;
}

double get_time_point() {
    std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(current_time.time_since_epoch()).count();
}
