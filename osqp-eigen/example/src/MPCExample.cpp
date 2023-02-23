/**
 * @file MPCExample.cpp
 * @author Giulio Romualdi
 * @copyright Released under the terms of the BSD 3-Clause License
 * @date 2018
 */

#pragma warning(push, 0)
#include <SimpleAmqpClient/SimpleAmqpClient.h>
#pragma warning(pop)
//#include "connected_test.h"
// osqp-eigen
#include "OsqpEigen/OsqpEigen.h"

// eigen
#include <Eigen/Dense>
#include <ctime>
#include <chrono>
#include <fstream>
#include <iostream>
#include <math.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>


using namespace std;
using namespace AmqpClient;

constexpr auto QUEUE_NAME = "centmpc";
constexpr auto QUEUE_NAMEp = "rrtst";

void setDynamicsMatrices(Eigen::Matrix<double, 12, 12> &a, Eigen::Matrix<double, 12, 4> &b)
{
    a << 1.,      0.,     0., 0., 0., 0., 0.1,     0.,     0.,  0.,     0.,     0.    ,
        0.,      1.,     0., 0., 0., 0., 0.,      0.1,    0.,  0.,     0.,     0.    ,
        0.,      0.,     1., 0., 0., 0., 0.,      0.,     0.1, 0.,     0.,     0.    ,
        0.0488,  0.,     0., 1., 0., 0., 0.0016,  0.,     0.,  0.0992, 0.,     0.    ,
        0.,     -0.0488, 0., 0., 1., 0., 0.,     -0.0016, 0.,  0.,     0.0992, 0.    ,
        0.,      0.,     0., 0., 0., 1., 0.,      0.,     0.,  0.,     0.,     0.0992,
        0.,      0.,     0., 0., 0., 0., 1.,      0.,     0.,  0.,     0.,     0.    ,
        0.,      0.,     0., 0., 0., 0., 0.,      1.,     0.,  0.,     0.,     0.    ,
        0.,      0.,     0., 0., 0., 0., 0.,      0.,     1.,  0.,     0.,     0.    ,
        0.9734,  0.,     0., 0., 0., 0., 0.0488,  0.,     0.,  0.9846, 0.,     0.    ,
        0.,     -0.9734, 0., 0., 0., 0., 0.,     -0.0488, 0.,  0.,     0.9846, 0.    ,
        0.,      0.,     0., 0., 0., 0., 0.,      0.,     0.,  0.,     0.,     0.9846;

    b << 0.,      -0.0726,  0.,     0.0726,
        -0.0726,  0.,      0.0726, 0.    ,
        -0.0152,  0.0152, -0.0152, 0.0152,
        -0.,     -0.0006, -0.,     0.0006,
        0.0006,   0.,     -0.0006, 0.0000,
        0.0106,   0.0106,  0.0106, 0.0106,
        0,       -1.4512,  0.,     1.4512,
        -1.4512,  0.,      1.4512, 0.    ,
        -0.3049,  0.3049, -0.3049, 0.3049,
        -0.,     -0.0236,  0.,     0.0236,
        0.0236,   0.,     -0.0236, 0.    ,
        0.2107,   0.2107,  0.2107, 0.2107;
}


void setInequalityConstraints(Eigen::Matrix<double, 12, 1> &xMax, Eigen::Matrix<double, 12, 1> &xMin,
                              Eigen::Matrix<double, 4, 1> &uMax, Eigen::Matrix<double, 4, 1> &uMin)
{
    double u0 = 10.5916;

    // input inequality constraints
    uMin << 9.6 - u0,
        9.6 - u0,
        9.6 - u0,
        9.6 - u0;

    uMax << 13 - u0,
        13 - u0,
        13 - u0,
        13 - u0;

    // state inequality constraints
    xMin << -M_PI/6,-M_PI/6,-OsqpEigen::INFTY,-OsqpEigen::INFTY,-OsqpEigen::INFTY,-1.,
        -OsqpEigen::INFTY, -OsqpEigen::INFTY,-OsqpEigen::INFTY,-OsqpEigen::INFTY,
        -OsqpEigen::INFTY,-OsqpEigen::INFTY;

    xMax << M_PI/6,M_PI/6, OsqpEigen::INFTY,OsqpEigen::INFTY,OsqpEigen::INFTY,
        OsqpEigen::INFTY, OsqpEigen::INFTY,OsqpEigen::INFTY,OsqpEigen::INFTY,
        OsqpEigen::INFTY,OsqpEigen::INFTY,OsqpEigen::INFTY;
}

void setWeightMatrices(Eigen::DiagonalMatrix<double, 12> &Q, Eigen::DiagonalMatrix<double, 4> &R)
{
    Q.diagonal() << 0, 0, 10., 10., 10., 10., 0, 0, 0, 5., 5., 5.;
    R.diagonal() << 0.1, 0.1, 0.1, 0.1;
}

void castMPCToQPHessian(const Eigen::DiagonalMatrix<double, 12> &Q, const Eigen::DiagonalMatrix<double, 4> &R, int mpcWindow,
                        Eigen::SparseMatrix<double> &hessianMatrix)
{

    hessianMatrix.resize(12*(mpcWindow+1) + 4 * mpcWindow, 12*(mpcWindow+1) + 4 * mpcWindow);

    //populate hessian matrix
    for(int i = 0; i<12*(mpcWindow+1) + 4 * mpcWindow; i++){
        if(i < 12*(mpcWindow+1)){
            int posQ=i%12;
            float value = Q.diagonal()[posQ];
            if(value != 0)
                hessianMatrix.insert(i,i) = value;
        }
        else{
            int posR=i%4;
            float value = R.diagonal()[posR];
            if(value != 0)
                hessianMatrix.insert(i,i) = value;
        }
    }
}

void castMPCToQPGradient(const Eigen::DiagonalMatrix<double, 12> &Q, const Eigen::Matrix<double, 12, 1> &xRef, int mpcWindow,
                         Eigen::VectorXd &gradient)
{

    Eigen::Matrix<double,12,1> Qx_ref;
    Qx_ref = Q * (-xRef);

    // populate the gradient vector
    gradient = Eigen::VectorXd::Zero(12*(mpcWindow+1) +  4*mpcWindow, 1);
    for(int i = 0; i<12*(mpcWindow+1); i++){
        int posQ=i%12;
        float value = Qx_ref(posQ,0);
        gradient(i,0) = value;
    }
}

void castMPCToQPConstraintMatrix(const Eigen::Matrix<double, 12, 12> &dynamicMatrix, const Eigen::Matrix<double, 12, 4> &controlMatrix,
                                 int mpcWindow, Eigen::SparseMatrix<double> &constraintMatrix)
{
    constraintMatrix.resize(12*(mpcWindow+1)  + 12*(mpcWindow+1) + 4 * mpcWindow, 12*(mpcWindow+1) + 4 * mpcWindow);

    // populate linear constraint matrix
    for(int i = 0; i<12*(mpcWindow+1); i++){
        constraintMatrix.insert(i,i) = -1;
    }

    for(int i = 0; i < mpcWindow; i++)
        for(int j = 0; j<12; j++)
            for(int k = 0; k<12; k++){
                float value = dynamicMatrix(j,k);
                if(value != 0){
                    constraintMatrix.insert(12 * (i+1) + j, 12 * i + k) = value;
                }
            }

    for(int i = 0; i < mpcWindow; i++)
        for(int j = 0; j < 12; j++)
            for(int k = 0; k < 4; k++){
                float value = controlMatrix(j,k);
                if(value != 0){
                    constraintMatrix.insert(12*(i+1)+j, 4*i+k+12*(mpcWindow + 1)) = value;
                }
            }

    for(int i = 0; i<12*(mpcWindow+1) + 4*mpcWindow; i++){
        constraintMatrix.insert(i+(mpcWindow+1)*12,i) = 1;
    }
}

void castMPCToQPConstraintVectors(const Eigen::Matrix<double, 12, 1> &xMax, const Eigen::Matrix<double, 12, 1> &xMin,
                                   const Eigen::Matrix<double, 4, 1> &uMax, const Eigen::Matrix<double, 4, 1> &uMin,
                                   const Eigen::Matrix<double, 12, 1> &x0,
                                   int mpcWindow, Eigen::VectorXd &lowerBound, Eigen::VectorXd &upperBound)
{
    // evaluate the lower and the upper inequality vectors
    Eigen::VectorXd lowerInequality = Eigen::MatrixXd::Zero(12*(mpcWindow+1) +  4 * mpcWindow, 1);
    Eigen::VectorXd upperInequality = Eigen::MatrixXd::Zero(12*(mpcWindow+1) +  4 * mpcWindow, 1);
    for(int i=0; i<mpcWindow+1; i++){
        lowerInequality.block(12*i,0,12,1) = xMin;
        upperInequality.block(12*i,0,12,1) = xMax;
    }
    for(int i=0; i<mpcWindow; i++){
        lowerInequality.block(4 * i + 12 * (mpcWindow + 1), 0, 4, 1) = uMin;
        upperInequality.block(4 * i + 12 * (mpcWindow + 1), 0, 4, 1) = uMax;
    }

    // evaluate the lower and the upper equality vectors
    Eigen::VectorXd lowerEquality = Eigen::MatrixXd::Zero(12*(mpcWindow+1),1 );
    Eigen::VectorXd upperEquality;
    lowerEquality.block(0,0,12,1) = -x0;
    upperEquality = lowerEquality;
    lowerEquality = lowerEquality;

    // merge inequality and equality vectors
    lowerBound = Eigen::MatrixXd::Zero(2*12*(mpcWindow+1) +  4*mpcWindow,1 );
    lowerBound << lowerEquality,
        lowerInequality;

    upperBound = Eigen::MatrixXd::Zero(2*12*(mpcWindow+1) +  4*mpcWindow,1 );
    upperBound << upperEquality,
        upperInequality;
}


void updateConstraintVectors(const Eigen::Matrix<double, 12, 1> &x0,
                             Eigen::VectorXd &lowerBound, Eigen::VectorXd &upperBound)
{
    lowerBound.block(0,0,12,1) = -x0;
    upperBound.block(0,0,12,1) = -x0;
}


double getErrorNorm(const Eigen::Matrix<double, 12, 1> &x,
                    const Eigen::Matrix<double, 12, 1> &xRef)
{
    // evaluate the error
    Eigen::Matrix<double, 12, 1> error = x - xRef;

    // return the norm
    return error.norm();
}

double get_time_point() {
    std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(current_time.time_since_epoch()).count();
}

int main()
{
    // set the preview window
    int mpcWindow = 20;

    // allocate the dynamics matrices
    Eigen::Matrix<double, 12, 12> a;
    Eigen::Matrix<double, 12, 4> b;

    // allocate the constraints vector
    Eigen::Matrix<double, 12, 1> xMax;
    Eigen::Matrix<double, 12, 1> xMin;
    Eigen::Matrix<double, 4, 1> uMax;
    Eigen::Matrix<double, 4, 1> uMin;

    // allocate the weight matrices
    Eigen::DiagonalMatrix<double, 12> Q;
    Eigen::DiagonalMatrix<double, 4> R;

    // allocate the initial and the reference state space
    Eigen::Matrix<double, 12, 1> x0;
    Eigen::Matrix<double, 12, 1> xRef;

    // allocate QP problem matrices and vectores
    Eigen::SparseMatrix<double> hessian;
    Eigen::VectorXd gradient;
    Eigen::SparseMatrix<double> linearMatrix;
    Eigen::VectorXd lowerBound;
    Eigen::VectorXd upperBound;

    // set the initial and the desired states
    x0 << 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ;
    xRef <<  0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0;

    // set MPC problem quantities
    setDynamicsMatrices(a, b);
    setInequalityConstraints(xMax, xMin, uMax, uMin);
    setWeightMatrices(Q, R);

    // cast the MPC problem as QP problem
    castMPCToQPHessian(Q, R, mpcWindow, hessian);
    castMPCToQPGradient(Q, xRef, mpcWindow, gradient);
    castMPCToQPConstraintMatrix(a, b, mpcWindow, linearMatrix);
    castMPCToQPConstraintVectors(xMax, xMin, uMax, uMin, x0, mpcWindow, lowerBound, upperBound);

    // instantiate the solver
    OsqpEigen::Solver solver;

    // settings
    //solver.settings()->setVerbosity(false);
    solver.settings()->setWarmStart(true);

    // set the initial data of the QP solver
    solver.data()->setNumberOfVariables(12 * (mpcWindow + 1) + 4 * mpcWindow);
    solver.data()->setNumberOfConstraints(2 * 12 * (mpcWindow + 1) + 4 * mpcWindow);
    if(!solver.data()->setHessianMatrix(hessian)) return 1;
    if(!solver.data()->setGradient(gradient)) return 1;
    if(!solver.data()->setLinearConstraintsMatrix(linearMatrix)) return 1;
    if(!solver.data()->setLowerBound(lowerBound)) return 1;
    if(!solver.data()->setUpperBound(upperBound)) return 1;

    // instantiate the solver
    if(!solver.initSolver()) return 1;

    // controller input and QPSolution vector
    Eigen::Vector4d ctr;
    Eigen::VectorXd QPSolution;

    // number of iteration steps
    int numberOfSteps = 20;
  int mpc_deadline_missed = 0;
	std::string s1;
	double num_double=0;

	//rabbitmq-cpp library
//    AmqpClient::Channel::ptr_t connection = AmqpClient::Channel::Create("localhost");
//    Channel::ptr_t channel;
	
	//rabbitmq-cpp library
	auto channel = AmqpClient::Channel::Create();
//	channel->DeclareQueue(QUEUE_NAME, false, true, false, true);
//	auto message = AmqpClient::BasicMessage::Create("Hello World!");
//	channel->BasicPublish("", QUEUE_NAME, message);
	auto consumerTag = channel->BasicConsume(QUEUE_NAME);
	clog << "Consumer tag: " << consumerTag << endl;
//	channel->PurgeQueue(QUEUE_NAME);


	ofstream myfile;
	myfile.open ("MPC_time.txt");

//AmqpClient::Channel::ptr_t connection = AmqpClient::Channel::Create("localhost");
//AmqpClient::Channel::ptr_t channel;
//std::string consumer_tag = channel->BasicConsume("my_queue", "");
//AmqpClient::Envelope::ptr_t envelope = channel->BasicConsumeMessage(consumer_tag);
  for (int j=0; j<1500; j++){

//	auto consumerTag = channel->BasicConsume(QUEUE_NAME);
//	clog << "Consumer tag: " << consumerTag << endl;
	auto envelop = channel->BasicConsumeMessage(consumerTag);
	//clog << " [x] Received " << envelop->Message()->Body() << endl;
	s1=envelop->Message()->Body();
	cout << "received message from central command" << s1 << endl; 
	if (!(s1.empty())){
    	num_double = std::stod(s1);
			}
	myfile << num_double;
	myfile << " ";
	  double begin_time = get_time_point();
	myfile << begin_time/1e6;
	myfile << " ";


    for (int i = 0; i < numberOfSteps; i++){
//	std::string consumer_tag = channel->BasicConsume("test", "");
//	Envelope::ptr_t envelope = channel->BasicConsumeMessage(consumer_tag);


        // solve the QP problem
        if(solver.solveProblem() != OsqpEigen::ErrorExitFlag::NoError) return 1;

        // get the controller input
        QPSolution = solver.getSolution();
        ctr = QPSolution.block(12 * (mpcWindow + 1), 0, 4, 1);

        // save data into file
        auto x0Data = x0.data();

        // propagate the model
        x0 = a * x0 + b * ctr;

        // update the constraint bound
        updateConstraintVectors(x0, lowerBound, upperBound);
        if(!solver.updateBounds(lowerBound, upperBound)) return 1;
      }

	  double time_diff = ((double)get_time_point() - begin_time) / 1e6;
	myfile << time_diff;
	myfile << "\n";
	  int sleep_val = .01-time_diff;
	  if(sleep_val > 0)
		usleep((sleep_val)*1e6);
	  	 else
	{
		printf("MPC Deadline missed \n");		
		mpc_deadline_missed++;
	}


   }
	  myfile.close();
    return 0;
}
