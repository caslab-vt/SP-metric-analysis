counter = 0.0
sum_ = 0.0
sum_vertices = 0.0
counter_vertices = 0.0
with open('CPU_time.txt') as f:
	lines = f.readlines()
	for line in lines:
		if line.find('Obstacle Detection') != -1:
			data = float(line.split('= ')[1])
			counter = counter + 1.0
			sum_ = sum_ + data
		else:
			data = float(line.split('= ')[1])
			counter_vertices = counter_vertices + 1.0
			sum_vertices = sum_vertices + data

print("CPU time for obstacle detection = " + str(sum_/counter)) 
print("CPU time for finding nearesr Vertices = " + str(sum_vertices/counter_vertices)) 

counter = 0.0
sum_ = 0.0
sum_vertices = 0.0
counter_vertices = 0.0
with open('GPU_time.txt') as f:
	lines = f.readlines()
	for line in lines:
		if line.find('Obstacle Detection') != -1:
			data = float(line.split('= ')[1])
			counter = counter + 1.0
			sum_ = sum_ + data
		else:
			data = float(line.split('= ')[1])
			counter_vertices = counter_vertices + 1.0
			sum_vertices = sum_vertices + data

print("GPU time for obstacle detection = " + str(sum_/counter)) 
print("GPU time for finding nearesr Vertices = " + str(sum_vertices/counter_vertices))  
