import psutil
import subprocess as sp
import re
import os
from subprocess import check_output
from time import sleep
from time import time
import datetime

REGEXP = re.compile(r'(.+?):\s+(.+?) (.?)B')

def get_pid(name):
	return int(check_output(["pidof","-s",name]))

def check_if_task_running(name):
	#s = psutil.process_iter()
	if name in (p.name() for p in  psutil.process_iter()):
		return True
	else:
		return False

def mem_info(path="/proc/meminfo"):
	list_memory = {}
	with open(path,"r") as fp:
		for line in fp:
			match = REGEXP.search(line)
			if match:
				key = str(match.group(1).strip())
				value = int(match.group(2).strip())
				unit = str(match.group(3).strip())
				list_memory[key] = {'val' : value , 'unit' : unit}
	return list_memory


clear_cache = sp.Popen(['sysctl','vm.drop_caches=3'],stdout=sp.PIPE, stderr=sp.PIPE)
out, _ = clear_cache.communicate()

count = 0
total_use_mem = 0
total_cpu_mem = 0
total_gpu_mem = 0
total_cpu_power = 0
total_gpu_power = 0
total_gpu_load = 0
total_cpu_util = []
total_cpu_util = [0 for i in range(8)]
total_cpu_load = 0
cpu_load = 0
average_use_mem = 0
average_cpu_mem = 0
average_gpu_mem = 0
average_cpu_power = 0
average_gpu_power = 0
average_gpu_load = 0
average_cpu_util = []
average_cpu_util = [0 for i in range(8)]
average_cpu_load = 0
data_cpu = []
data_cpu = [None for i in range(8)]
perf_flag = 1
time_sys1=0
time_usr1=0
with open('performace_analysis.txt','a') as f:
#	data = list(['Time','Total Used Memory','CPU Memory','GPU Memory','CPU Power','GPU Power','GPU utilization','All CPU utilization'])
#	f.write(','.join(data))
#	f.write('\n')
	while perf_flag:
		if (check_if_task_running("darknet") == False):
			print("here")
			continue  
		while (check_if_task_running("darknet") == True):
#			count+= 1
#			cur_time = time()
#			print(str(cur_time))
#			meminfo = {}
#			meminfo = mem_info()
#			total = meminfo.get('MemTotal',{})
#			available = meminfo.get('MemAvailable',{})
#			shared = meminfo.get('NvMapMemUsed',{})
#			gpu_mem = (shared.get('val',0))/1000
#			use_mem = (total.get('val',0) - available.get('val',0))/1000
#			cpu_mem = use_mem - gpu_mem
#			gpu_load = float(open('/sys/devices/gpu.0/load','r').read().split('\n')[0])/10.0
#			cpu_p = open('/sys/bus/i2c/drivers/ina3221x/1-0040/iio:device0/in_power1_input','r').read().split('\n')[0]
#			gpu_p = open('/sys/bus/i2c/drivers/ina3221x/1-0040/iio:device0/in_power0_input','r').read().split('\n')[0]
#			soc_p = open('/sys/bus/i2c/drivers/ina3221x/1-0040/iio:device0/in_power2_input','r').read().split('\n')[0]
#			gpu_freq = open('/sys/kernel/debug/bpmp/debug/clk/gpcclk/rate','r').read().split('\n')[0]
#			cpu_util = psutil.cpu_percent(percpu=True)
#			total_use_mem+=use_mem
#			average_use_mem=total_use_mem/count
#			total_cpu_mem+=cpu_mem
#			average_cpu_mem=total_cpu_mem/count
#			total_gpu_mem+=gpu_mem
#			average_gpu_mem=total_gpu_mem/count
#			total_cpu_power+=int(cpu_p)
#			average_cpu_power=total_cpu_power/count
#			total_gpu_power+=int(gpu_p)
#			average_gpu_power=total_gpu_power/count
#			total_gpu_load+=gpu_load
#			average_gpu_load =total_gpu_load/count
#			cpu_load = 0
#			for i in range(8):
#				total_cpu_util[i]+=cpu_util[i]
#				average_cpu_util[i] = total_cpu_util[i]/count
#				cpu_load+=cpu_util[i]
#				data_cpu[i] = str(cpu_util[i]) + '/' + str(average_cpu_util[i])
#			cpu_load/=8
#			total_cpu_load+=cpu_load
#			average_cpu_load = total_cpu_load/count	
			time=datetime.datetime.now()	
		  	p = psutil.Process(get_pid("darknet"))
		  	times=p.cpu_times()
		  	#atimes=psutil.cpu_times()
			mem = psutil.virtual_memory()
#			gps = ','.join(map(str,gps))
			time = str(time)
			util=psutil.cpu_percent()
#			cpu_p = open('/sys/bus/i2c/drivers/ina3221x/7-0040/iio_device/in_power1_input','r').read().split('\n')
#			gpu_p = open('/sys/bus/i2c/drivers/ina3221x/7-0040/iio_device/in_power0_input','r').read().split('\n')
#			soc_p = open('/sys/bus/i2c/drivers/ina3221x/7-0040/iio_device/in_power2_input','r').read().split('\n')
			cpu_p = open('/sys/bus/i2c/drivers/ina3221x/1-0040/iio:device0/in_power1_input','r').read().split('\n')
			gpu_p = open('/sys/bus/i2c/drivers/ina3221x/1-0040/iio:device0/in_power0_input','r').read().split('\n')
			soc_p = open('/sys/bus/i2c/drivers/ina3221x/1-0040/iio:device0/in_power2_input','r').read().split('\n')
		#        data = list([time,gps,str(psutil.cpu_percent()),str(100)])
		#        data = list([time,gps,str(p.cpu_percent(interval=1)),str(100)])
		#        data = list([time,gps,str(times[0]-time_usr),str(times[1]-time_sys),str(ang_vel), str(lin_acc),str(cpu_p),str(100)])
			data = list([time,str(times[0]-time_usr1),str(times[1]-time_sys1), str(util), str(mem[3]), str(cpu_p[0]), str(gpu_p[0]), str(soc_p[0]), str(100)])
			print(data)
			f.write(','.join(data))
			f.write('\n')
			time_usr1=times[0]
			time_sys1=times[1]
#			data = list([str(cur_time),str(use_mem)+'/'+str(average_use_mem),str(cpu_mem)+'/'+str(average_cpu_mem),str(gpu_mem)+'/'+str(average_gpu_mem),str(cpu_p)+'/'+str(average_cpu_power),str(gpu_p)+'/'+str(average_gpu_power),str(gpu_load)+'/'+str(average_gpu_load),str(cpu_load)+'/'+str(average_cpu_load)])
#			f.write(','.join(data))
#			f.write('\n')	
			sleep(0.5)
		perf_flag = 0


