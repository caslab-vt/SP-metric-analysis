#pragma warning(push, 0)
#include <SimpleAmqpClient/SimpleAmqpClient.h>
#pragma warning(pop)

#include<fstream>
#include <string.h>
#include<chrono>
#include <iostream>
#include <thread>
#include <stdio.h>
using namespace std;
using namespace AmqpClient;
constexpr auto QUEUE_NAME = "slamst";
constexpr auto QUEUE_NAMEp = "rrtst";
AmqpClient::Channel::ptr_t channel1, channel2;
std::string consumerTag; 
AmqpClient::Envelope::ptr_t envelop1;
AmqpClient::BasicMessage::ptr_t message;
std::string s1;
ofstream myfile;



extern "C" void rfunc_init (){

	//rabbitmq-cpp library
	channel1 = AmqpClient::Channel::Create();
	channel2 = AmqpClient::Channel::Create();
	channel2->DeclareQueue(QUEUE_NAMEp, false, false, false, true);

	consumerTag = channel1->BasicConsume(QUEUE_NAME);
	clog << "Consumer tag: " << consumerTag << endl;

	myfile.open ("GPU_time.txt");

}


extern "C" void rfunc(){

//	while (1){

	envelop1 = channel1->BasicConsumeMessage(consumerTag);
	//clog << " [x] Received " << envelop->Message()->Body() << endl;
	s1=envelop1->Message()->Body();
	std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
//	double now=std::chrono::duration_cast<std::chrono::microseconds>(current_time.time_since_epoch()).count();
	cout << "received message from slamst" << s1 << endl; 
//	if (s1.empty()) {
//		continue;
//	}
    	double num_double = std::stod(s1);
	myfile << num_double;
	myfile << " ";
//	myfile << now/1e6;
//	myfile << " ";
//	if (!(s1.empty())) 
//		break;
//	}

}

extern "C" void rsend(double rrtst1, double rrtrt){
//	s1="12354"; 
//	channel2->PurgeQueue(QUEUE_NAMEp);
	message = AmqpClient::BasicMessage::Create(s1);
	channel2->BasicPublish("", QUEUE_NAMEp, message);
	cout << "sent message from rrtst" << s1 << endl; 
	myfile << rrtst1/1e6;
	myfile << " ";
	myfile << rrtrt;
	myfile << "\n";

}

extern "C" void rend(){
	  myfile.close();

}

//double get_time_point() {
//    std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
//    return std::chrono::duration_cast<std::chrono::microseconds>(current_time.time_since_epoch()).count();
//}
