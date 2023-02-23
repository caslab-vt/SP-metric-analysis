#! /bin/bash


./YOLO-DynaSLAM/Examples/RGB-D/rgbd_tum_yolo YOLO-DynaSLAM/Vocabulary/ORBvoc.txt YOLO-DynaSLAM/Examples/RGB-D/TUM3.yaml YOLO-DynaSLAM/rgbd_dataset_freiburg3_walking_xyz/ YOLO-DynaSLAM/Examples/RGB-D/associations/fr3_walking_xyz.txt YOLO &

SLAM_ID=$(pidof rgbd_tum_yolo)
echo "SLAM PID $SLAM_ID"
#sudo chrt -f -p 40 $SLAM_ID

sleep 10

sudo rabbitmqctl set_policy my-pol1 "^slamst$"   '{"max-length":1,"overflow":"drop-head"}'   --apply-to queues

sleep 2
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/
#sudo rabbitmqctl purge_queue slamst
./Downloads/Testedk/Tested_Kernels/RRT_CUDA/RRT &

rrt_ID=$(pidof RRT)
echo "rrt PID $rrt_ID"
sudo chrt -f -p 20 $rrt_ID

sleep 2
#./cent_con

#sleep 2
sudo rabbitmqctl set_policy my-pol2 "^rrtst$"   '{"max-length":1,"overflow":"drop-head"}'   --apply-to queues
#sleep 2
sudo rabbitmqctl set_policy my-pol3 "^centmpc$"   '{"max-length":1,"overflow":"drop-head"}'   --apply-to queues

sleep 2
#sudo rabbitmqctl purge_queue centmpc &
#sudo rabbitmqctl purge_queue rrtst

./osqp-eigen/build/bin/MPCExample &
MPC_ID=$(pidof MPCExample)
echo "Mpc PID $MPC_ID"
#sudo chrt -f -p 30 $MPC_ID
sleep 1

#./TSP-Solver/tsp TSP-Solver/DATA/burma14.tsp 10 LS1 3 &
#sleep 2
#TA_ID=$(pidof tsp)
#echo "TA PID $TA_ID"
#sudo chrt -f -p 10 $TA_ID

./darknet_fs/darknet/darknet classifier darknet_fs/darknet/depth darknet_fs/darknet/Depth_Estimation_leaky.cfg darknet_fs/darknet/Depth_Estimation.weights darknet_fs/darknet/data/backup_data_set pytorch_weights

#cd darknet_fs/darknet/
#./Depth_estimation_multiple_images.sh
#DEPTH_ID=$(pidof darknet)
#echo "depth est PID $DEPTH_ID"


#sudo chrt -f -p 20 $SLAM_ID
#sudo chrt -f -p 30 $rrt_ID
##sudo chrt -f -p 40 $TA_ID
#sudo chrt -f -p 50 $MPC_ID

