/**
* This file is a modified version of ORB-SLAM2.<https://github.com/raulmur/ORB_SLAM2>
*
* This file is part of DynaSLAM.
* Copyright (C) 2018 Berta Bescos <bbescos at unizar dot es> (University of Zaragoza)
* For more information see <https://github.com/bertabescos/DynaSLAM>.
*
*/
#pragma warning(push, 0)
#include <SimpleAmqpClient/SimpleAmqpClient.h>
#pragma warning(pop)

#include<iostream>
#include<algorithm>
#include<fstream>
#include<chrono>
#include <unistd.h>
#include<opencv2/core/core.hpp>

#include "Geometry.h"
#include "Tracking.h"
#include "MaskNet.h"
#include <System.h>
#include "yolo.h"
#include "darknet.h"
//#include "image_opencv.h"
using namespace DynaSLAM;
using namespace std;
using namespace AmqpClient;
constexpr auto QUEUE_NAME1 = "slamst";
constexpr auto QUEUE_NAME2 = "slamtt";

double get_time_point();
image_ash mat_to_image(cv::Mat mat);
void LoadImages(const string &strAssociationFilename, vector<string> &vstrImageFilenamesRGB,
                vector<string> &vstrImageFilenamesD, vector<double> &vTimestamps);

int main(int argc, char **argv)
{
    if(argc != 5 && argc != 6 && argc != 7)
    {
        cerr << endl << "Usage: ./rgbd_tum path_to_vocabulary path_to_settings path_to_sequence path_to_association (path_to_masks) (path_to_output)" << endl;
        return 1;
    }

	ofstream myfile;
	myfile.open ("SLAM_time.txt");
    // Retrieve paths to images
    vector<string> vstrImageFilenamesRGB;
    vector<string> vstrImageFilenamesD;
    vector<double> vTimestamps;
    string strAssociationFilename = string(argv[4]);
    LoadImages(strAssociationFilename, vstrImageFilenamesRGB, vstrImageFilenamesD, vTimestamps);

    // Check consistency in the number of images and depthmaps
    int nImages = vstrImageFilenamesRGB.size();
    std::cout << "nImages: " << nImages << std::endl;

    nImages = 450;

    if(vstrImageFilenamesRGB.empty())
    {
        cerr << endl << "No images found in provided path." << endl;
        return 1;
    }
    else if(vstrImageFilenamesD.size()!=vstrImageFilenamesRGB.size())
    {
        cerr << endl << "Different number of images for rgb and depth." << endl;
        return 1;
    }

    // Initialize Mask R-CNN
    //DynaSLAM::SegmentDynObject *MaskNet;
//    yolov3::yolov3Segment* yolo;
//    if (argc==6 || argc==7)
//    {
//        //cout << "Loading Mask R-CNN. This could take a while..." << endl;
//        //MaskNet = new DynaSLAM::SegmentDynObject();
//        //cout << "Mask R-CNN loaded!" << endl;
//        cout << "Loading Yolov3 net. This could take a while..." << endl;
//        yolo = new yolov3::yolov3Segment();
//        cout << "Yolov3 net loaded!" << endl;
//    }

	DynaSLAM::Geometry mGeometry;
    // Create SLAM system. It initializes all system threads and gets ready to process frames.
    ORB_SLAM2::System SLAM(argv[1],argv[2],ORB_SLAM2::System::RGBD,true);
    mGeometry.file_func();
    // Vector for tracking time statistics
    vector<float> vTimesTrack;
    vTimesTrack.resize(nImages);

    cout << endl << "-------" << endl;
    cout << "Start processing sequence ..." << endl;
    cout << "Images in the sequence: " << nImages << endl << endl;

    // Dilation settings
    int dilation_size = 15;
    cv::Mat kernel = getStructuringElement(cv::MORPH_ELLIPSE,
                                           cv::Size( 2*dilation_size + 1, 2*dilation_size+1 ),
                                           cv::Point( dilation_size, dilation_size ) );

    if (argc==7)
    {
        std::string dir = string(argv[6]);
        mkdir(dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
        dir = string(argv[6]) + "/rgb/";
        mkdir(dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
        dir = string(argv[6]) + "/depth/";
        mkdir(dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
        dir = string(argv[6]) + "/mask/";
        mkdir(dir.c_str(), S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }

    // Main loop
        cv::Mat imRGB, imD;
        cv::Mat imRGBOut, imDOut,maskOut;

	//initialize darknet
	masking masking1=test_detector_init(0,0);

	//rabbitmq-cpp library
	auto channel1 = AmqpClient::Channel::Create();
	channel1->DeclareQueue(QUEUE_NAME1, false, false, false, true);
//	channel1->DeclareQueue(QUEUE_NAME1, bit-passive, bit-durbale, bit-exclusve, bit-auto-delete);
//	auto channel2 = AmqpClient::Channel::Create();
//	channel2->DeclareQueue(QUEUE_NAME2, false, true, false, true);


    for(int ni=0; ni<nImages; ni++)
    //for(int ni=0; ni<1; ni++)
    {
        cout << ni << endl;
	double begin_time1 = get_time_point()/1e6;
	//write start time to file
  	myfile << begin_time1 ;
  	myfile << " " ;
        // Read image and depthmap from file
        imRGB = cv::imread(string(argv[3])+"/"+vstrImageFilenamesRGB[ni],CV_LOAD_IMAGE_UNCHANGED);
        imD = cv::imread(string(argv[3])+"/"+vstrImageFilenamesD[ni],CV_LOAD_IMAGE_UNCHANGED);

        double tframe = vTimestamps[ni];

        if(imRGB.empty())
        {
            cerr << endl << "Failed to load image at: "
                 << string(argv[3]) << "/" << vstrImageFilenamesRGB[ni] << endl;
            return 1;
        }

	double end_time1 = get_time_point()/1e6;
	double srest1= end_time1-begin_time1;


#ifdef COMPILEDWITHC11
        std::chrono::steady_clock::time_point t1 = std::chrono::steady_clock::now();
#else
        std::chrono::monotonic_clock::time_point t1 = std::chrono::monotonic_clock::now();
#endif

//	cout << "begin time: " << begin_time << endl;



        // Segment out the images
        cv::Mat mask = cv::Mat::ones(480,640,CV_8U);
//        cv::Mat mask = cv::Mat::zeros(480,640,CV_32F);
	image_ash image_rgb=mat_to_image(imRGB);
        /*
        if (argc == 6 || argc == 7)
        {
            cv::Mat maskRCNN;
            maskRCNN = MaskNet->GetSegmentation(imRGB,string(argv[5]),vstrImageFilenamesRGB[ni].replace(0,4,""));
            cv::Mat maskRCNNdil = maskRCNN.clone();
            cv::dilate(maskRCNN,maskRCNNdil, kernel);
            mask = mask - maskRCNNdil;
        }
        */
	//char* fname=NULL;
        if (argc == 6 || argc == 7)
            //mask = yolo->Segmentation(imRGB);
		//init_cpu();
	//char *datacfg = "/cfg/coco.data";
	//char *cfg = "/cfg/yolov4-tiny.cfg";
	//char *weights = "/yolov4-tiny.weights";
	cout << "calling test detector" << endl;
	double begin_time2 = get_time_point()/1e6;

	detection_with_class* selected_detections= test_detector(masking1, image_rgb, 0.25, 0.5, 0, 0, 0, 0);

 	double end_time2 = get_time_point()/1e6;
	double srest2= end_time2-begin_time2;

	double begin_time3 = get_time_point()/1e6;
            //mask = create_mask_mat(image_rgb);
        // Pass the image to the SLAM system
        if (argc == 7){SLAM.TrackRGBD(imRGB,imD,mask,tframe,imRGBOut,imDOut,maskOut);}
        else {SLAM.TrackRGBD(imRGB,imD,mask,tframe);}

 	double end_time3 = get_time_point()/1e6;
	double srest3= end_time3-begin_time3;

#ifdef COMPILEDWITHC11
        std::chrono::steady_clock::time_point t2 = std::chrono::steady_clock::now();
#else
        std::chrono::monotonic_clock::time_point t2 = std::chrono::monotonic_clock::now();
#endif

        if (argc == 7)
        {
            cv::imwrite(string(argv[6]) + "/rgb/" + vstrImageFilenamesRGB[ni],imRGBOut);
            vstrImageFilenamesD[ni].replace(0,6,"");
            cv::imwrite(string(argv[6]) + "/depth/" + vstrImageFilenamesD[ni],imDOut);
            cv::imwrite(string(argv[6]) + "/mask/" + vstrImageFilenamesRGB[ni],maskOut);
        }

        double ttrack= std::chrono::duration_cast<std::chrono::duration<double> >(t2 - t1).count();

        vTimesTrack[ni]=ttrack;
	//write start time to file
  	myfile << ttrack ;
  	myfile << " " ;
  	myfile << srest1 ;
  	myfile << " " ;
  	myfile << srest2 ;
  	myfile << " " ;
  	myfile << srest3 ;
  	myfile << "\n" ;
	//send to rabbitmq server
   	string s1 = to_string(begin_time1);
//   	string s3 = " ";
//   	string s2 = to_string(ttrack);
	cout << "begin time: " << begin_time1 << endl;
	cout << "track time: " << ttrack << endl;
//	channel1->PurgeQueue(QUEUE_NAME1);
//	string s=strcat(s1, s2);
	auto message1 = AmqpClient::BasicMessage::Create(s1);
	channel1->BasicPublish("", QUEUE_NAME1, message1);
	cout << "begin time string: " << s1 << endl;


//   	string s2 = to_string(ttrack);
//	auto message2 = AmqpClient::BasicMessage::Create(s2);
//	channel2->BasicPublish("", QUEUE_NAME2, message2);

        // Wait to load the next frame
        double T=0;
        if(ni<nImages-1)
            T = vTimestamps[ni+1]-tframe;
        else if(ni>0)
            T = tframe-vTimestamps[ni-1];

//        if(ttrack<T)
        if(ttrack<1.0)
            usleep((1-ttrack)*1e6);
	cout << "for loop "<< ni << endl;

    }
	myfile.close();
    // Stop all threads
	    // free memory
	    free_ptrs((void**)masking1.names, masking1.net.layers[masking1.net.n - 1].classes);
//	    free_list_contents_kvp(options);
//	    free_list(options);
	    //printf("inside test Detector8 \n");
	    int i,j;
	    const int nsize = 8;
	    for (j = 0; j < nsize; ++j) {
		for (i = 32; i < 127; ++i) {
		    free_image(masking1.alphabet[j][i]);
		}
		free(masking1.alphabet[j]);
	    }
	    //printf("inside test Detector9 \n");
	    free(masking1.alphabet);

	    free_network(masking1.net);
	    //printf("inside test Detector10 \n");
        


    SLAM.Shutdown();
	mGeometry.file_cl_func();
    // Tracking time statistics
    sort(vTimesTrack.begin(),vTimesTrack.end());
    float totaltime = 0;
    for(int ni=0; ni<nImages; ni++)
    {
        totaltime+=vTimesTrack[ni];
    }
    cout << "-------" << endl << endl;
    cout << "median tracking time: " << vTimesTrack[nImages/2] << endl;
    cout << "mean tracking time: " << totaltime/nImages << endl;

    // Save camera trajectory
    SLAM.SaveTrajectoryTUM("CameraTrajectory.txt");
    SLAM.SaveKeyFrameTrajectoryTUM("KeyFrameTrajectory.txt");

    return 0;
}

double get_time_point() {
    std::chrono::steady_clock::time_point current_time = std::chrono::steady_clock::now();
    return std::chrono::duration_cast<std::chrono::microseconds>(current_time.time_since_epoch()).count();
}


image_ash mat_to_image(cv::Mat mat)
{
    int w = mat.cols;
    int h = mat.rows;
    int c = mat.channels();
    image_ash im = make_image(w, h, c);
    unsigned char *data = (unsigned char *)mat.data;
    int step = mat.step;
    for (int y = 0; y < h; ++y) {
        for (int k = 0; k < c; ++k) {
            for (int x = 0; x < w; ++x) {
                //uint8_t val = mat.ptr<uint8_t>(y)[c * x + k];
                //uint8_t val = mat.at<Vec3b>(y, x).val[k];
                //im.data[k*w*h + y*w + x] = val / 255.0f;

                im.data[k*w*h + y*w + x] = data[y*step + x*c + k] / 255.0f;
            }
        }
    }
    cout << "successfully converted mat to image" << endl;
    return im;
}

void LoadImages(const string &strAssociationFilename, vector<string> &vstrImageFilenamesRGB,
                vector<string> &vstrImageFilenamesD, vector<double> &vTimestamps)
{
    ifstream fAssociation;
    fAssociation.open(strAssociationFilename.c_str());
    while(!fAssociation.eof())
    {
        string s;
        getline(fAssociation,s);
        if(!s.empty())
        {
            stringstream ss;
            ss << s;
            double t;
            string sRGB, sD;
            ss >> t;
            vTimestamps.push_back(t);
            ss >> sRGB;
            vstrImageFilenamesRGB.push_back(sRGB);
            ss >> t;
            ss >> sD;
            vstrImageFilenamesD.push_back(sD);

        }
    }
}
