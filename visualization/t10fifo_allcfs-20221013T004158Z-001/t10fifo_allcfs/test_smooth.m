clc;
clear all;
close all;

x = (0:0.1:15)';
y = sin(x) + 0.5*(rand(size(x))-0.5);
y([90,110]) = 3;
tic
yy1 = smooth(x,y,0.1,'loess');
yy2 = smooth(x,y,0.1,'rloess');
toc
subplot(2,1,1)
plot(x,y,'b.',x,yy1,'r-')
set(gca,'YLim',[-1.5 3.5])
legend('Original data','Smoothed data using ''loess''',...
       'Location','NW')
   
subplot(2,1,2)
plot(x,y,'b.',x,yy2,'r-')
set(gca,'YLim',[-1.5 3.5])
legend('Original data','Smoothed data using ''rloess''',...
       'Location','NW')