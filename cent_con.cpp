#pragma warning(push, 0)
#include <SimpleAmqpClient/SimpleAmqpClient.h>
#pragma warning(pop)

#include<fstream>
#include <string.h>
#include<chrono>
#include <iostream>
#include <thread>
#include <stdio.h>
#include <unistd.h>     // execv(), fork()
#include <cstdio>
#include <cstdlib>
#include <sys/types.h>  // pid_t
#include <sys/wait.h>   // waitpid()
//Main function calling different methods to solve TSP
//Print output into .sol and .trace file

using namespace std;
using namespace AmqpClient;

//ofstream output_sol,output_trace;
constexpr auto QUEUE_NAME1 = "centmpc";
constexpr auto QUEUE_NAME2 = "rrtst";
constexpr auto QUEUE_NAME3 = "tspst";
constexpr auto QUEUE_NAME4 = "tspopt";
constexpr auto QUEUE_NAME5 = "centrrt";
constexpr auto QUEUE_NAME6 = "slamst";
//pid_t child_pid;
//char* child_args[2] = {NULL};
//int   child_status;
//pid_t wait_result;

double get_time_point();

class Timer {
    bool clear = false;

public:
    template<typename Function>
    void setTimeout(Function function, int delay);
    template<typename Function>
    void setInterval(Function function, int interval);
    void stop();
};

template<typename Function>
void Timer::setTimeout(Function function, int delay) {
    this->clear = false;
    std::thread t([=,this]() {
        if(this->clear) return;
        std::this_thread::sleep_for(std::chrono::milliseconds(delay));
        if(this->clear) return;
        function();
    });
    t.detach();
}

template<typename Function>
void Timer::setInterval(Function function, int interval) {
    this->clear = false;
    std::thread t([=]() {
        while(true) {
            if(this->clear) return;
            std::this_thread::sleep_for(std::chrono::milliseconds(interval));
            if(this->clear) return;
            function();
        }
    });
    t.detach();
}

void Timer::stop() {
    this->clear = true;
}

int main(int argc, char* argv[])
{	

	ofstream myfile;

//	int i;
//	int pathlength = 0;
//	double gap;
//	ofstream myfile;
//	myfile.open ("TSP_time.txt");
//	//rabbitmq-cpp library
	auto channel1 = AmqpClient::Channel::Create();
	channel1->DeclareQueue(QUEUE_NAME1, false, false, false, true);

//	auto channel5 = AmqpClient::Channel::Create();
//	channel5->DeclareQueue(QUEUE_NAME5, false, false, false, true);


//	auto message = AmqpClient::BasicMessage::Create("Hello World!");
//	channel->BasicPublish("", QUEUE_NAME, message);

//    auto consumerTag = channel->BasicConsume(QUEUE_NAME);
//    clog << "Consumer tag: " << consumerTag << endl;
//    auto envelop = channel->BasicConsumeMessage(consumerTag);
//    clog << " [x] Received " << envelop->Message()->Body() << endl;
	std::string s1,s3,s4,s6;


	//rabbitmq-cpp library
//    AmqpClient::Channel::ptr_t connection = AmqpClient::Channel::Create("localhost");
//    Channel::ptr_t channel;
	
	//rabbitmq-cpp library
	auto channel2 = AmqpClient::Channel::Create();
	auto consumerTag = channel2->BasicConsume(QUEUE_NAME2);
	clog << "Consumer tag: " << consumerTag << endl;

//	auto channel6 = AmqpClient::Channel::Create();
//	auto consumerTag6 = channel6->BasicConsume(QUEUE_NAME6);
//	clog << "Consumer tag: " << consumerTag6 << endl;

//	auto envelop = channel2->BasicConsumeMessage(consumerTag);
//	//clog << " [x] Received " << envelop->Message()->Body() << endl;
//	s1=envelop->Message()->Body();
//	cout << "received message" << s1 << endl; 
//    	double num_double = std::stod(s1);
//	myfile << num_double;
//	myfile << " ";
	  double begin_time = get_time_point();
//	myfile << begin_time/1e6;
//	myfile << " ";



	//timer implementaion

	Timer t = Timer();

	t.setInterval([&]() {
//	std::cout << "Hey..sending mpc trigger After each 100ms..." << std::endl;
	auto message = AmqpClient::BasicMessage::Create(s1);
	channel1->BasicPublish("", QUEUE_NAME1, message);
//	double begin_time = get_time_point();
//	myfile << begin_time/1e6;
//	myfile << " ";

	}, 100); 

	t.setTimeout([&]() {

	std::cout << "Hey.. After 400s. But I will stop the timer!" << std::endl;
	t.stop();
	}, 300000); 
////////////////////////////////////////////////////////////////////////////////

	Timer t1 = Timer();

	t1.setInterval([&]() {
//	std::cout << "Hey..sending mpc trigger After each 100ms..." << std::endl;
//	std::system("TSP-Solver/tsp DATA/ulysses16.tsp 10 BnB");
////////
	system ("./TSP-Solver/tsp TSP-Solver/DATA/ulysses16.tsp 10 BnB 3");
//	system("TA_ID=$(pidof tsp)");
//	system("sudo chrt -f -p 10 $(pidof tsp)");
//	double begin_time = get_time_point();
//	myfile << begin_time/1e6;
//	myfile << " ";

	}, 10); 

	t1.setTimeout([&]() {

	std::cout << "Hey.. After 400s. But I will stop the timer!" << std::endl;

	auto channel3 = AmqpClient::Channel::Create();
	auto consumerTag3 = channel3->BasicConsume(QUEUE_NAME3);
	clog << "Consumer tag: " << consumerTag3 << endl;
	auto channel4 = AmqpClient::Channel::Create();
	auto consumerTag4 = channel4->BasicConsume(QUEUE_NAME4);
	clog << "Consumer tag: " << consumerTag4 << endl;

	t1.stop();
	myfile.open ("cent_time.txt");
	sleep(10);

	while (1){

		auto envelop3 = channel3->BasicConsumeMessage(consumerTag3);
		//clog << " [x] Received " << envelop->Message()->Body() << endl;
		s3=envelop3->Message()->Body();
		auto envelop4 = channel4->BasicConsumeMessage(consumerTag4);
		//clog << " [x] Received " << envelop->Message()->Body() << endl;
		s4=envelop4->Message()->Body();
		cout << s3 << " from_tsp_in_CENT_CONTROL " << s4 << endl;

		if (s3.empty()) {
			break;
		}
	   	double num_double1 = std::stod(s3);
		myfile << num_double1;
		myfile << " ";
	    	double num_double2 = std::stod(s4);
		myfile << num_double2;
		myfile << " ";
		myfile << "\n";
//		if (!(s3.empty())) 
//			continue;
	}

	cout << "close myfile"  << endl;
	  myfile.close();

	}, 300000); 

	//end timer implementation

    while(1){

	auto envelop = channel2->BasicConsumeMessage(consumerTag);
	//clog << " [x] Received " << envelop->Message()->Body() << endl;
	s1=envelop->Message()->Body();
	cout << "received message from rrt in CENT CONTROL " << s1 << endl; 
	 if (	  ((double) get_time_point()-begin_time)/1e6>310)
		{break;}

//	auto envelop6 = channel6->BasicConsumeMessage(consumerTag6);
//	//clog << " [x] Received " << envelop->Message()->Body() << endl;
//	s6=envelop6->Message()->Body();
//	cout << "received message from slam in CENT CONTROL " << get_time_point()/1e6 << " " << s6 << endl;

//	auto message5 = AmqpClient::BasicMessage::Create(s6);
//	channel5->BasicPublish("", QUEUE_NAME5, message5);

	}


return 0;
}

double get_time_point() {
    std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(current_time.time_since_epoch()).count();
}
