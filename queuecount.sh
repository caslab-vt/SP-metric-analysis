#! /bin/bash

while [ 1 ]
do
	sudo rabbitmqctl list_queues
#	echo $(date +"%s.%3N") $(ps -C rgbd_tum_yolo -o %cpu,%mem) $(ps -C RRT -o %cpu,%mem) $(ps -C MPCExample -o %cpu,%mem) $(ps -C tsp -o %cpu,%mem)
done



