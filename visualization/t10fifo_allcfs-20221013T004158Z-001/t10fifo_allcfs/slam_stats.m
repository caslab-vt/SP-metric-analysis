clc;
clear all;
close all;
num1 = xlsread('SLAM_time.xlsx'); 
% num2 = xlsread('SLAM_stats.xlsx'); 
%fileID1 = fopen('SLAM_time.txt','r');
fileID2 = fopen('SLAM_stats.txt','r');
% 
% num1 = textscan(fileID1, '%f', 'Delimiter', ' ');
% num2 = textscan(fileID2, '%f', 'Delimiter', ' ');
% num1=cell2mat(textscan(fileID1,'%f %f %f %f %f', 'delimiter',' ', 'multipledelimsasone',1));
num2=cell2mat(textscan(fileID2,'%f %f ', 'delimiter',' ', 'multipledelimsasone',1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
% time = (0:1:(length(num)-1))';
st_slam=num1(:,1);
rt_slam=num1(:,2);
st_slams=num2(:,1);
regsize=num2(:,2);
% regsize_undersampled = resample(regsize, st_slam);
% ii=1;
% RS=[];
% st_reg=[];
% k=1;

% for i=1:length(regsize)
%     mean_reg=regsize(i);
%     while (st_slams(i)==st_slams(i+1)&&(i<length(regsize)-1))
%         mean_reg=(k-1)*mean_reg/k+regsize(i+1)/k;
%         k=k+1;
%         i=i+1;
%     end
%     RS(ii)=mean_reg;
%     st_reg(ii)=st_slams(i);
%     ii=ii+1;
%     k=1;
% end
%reg=smoooth(st_slams, regsize,0.1,'rloess');
[C,ia,ib] = unique(st_slams,'stable') ;    % get unique values and their indices 
 st_reg = accumarray(ib,regsize,[],@mean); 
% st_reg =[C val] ;      % get mean of unique A time stamp values
% 
st_un=st_slams(ia);
reg=smooth(st_reg,10000);

% regsize_undersampled = interp1(st_un,st_reg,st_slam);
% size(rt_slam)
% size(regsize_undersampled)
% %use max as well
% % [R,P] = corrcoef(regsize_undersampled(17:226),rt_slam(17:226))
% % [R1,P1] = corr(regsize_undersampled(17:226),rt_slam(17:226), 'type', 'Kendall'	)
% [R,P] = corrcoef(regsize_undersampled,rt_slam)
% [R1,P1] = corr(regsize_undersampled,rt_slam, 'type', 'Kendall'	)



figure('Name','SLAM stats');
            yyaxis left; cla; hold on;
            plot(st_slam,rt_slam,'-g','linewidth',2)% 
                        ylabel('response Time (s)','Fontsize',20)

            yyaxis right; cla; hold on;
%             plot(st_slam,regsize_undersampled,'-k','linewidth',2)% 
            plot(st_un,reg,'-k','linewidth',2)% 

                        ylabel('region size (pixels)','Fontsize',20)

                        xlabel('wall Time x 10^-^1 (s)','Fontsize',28)
            legend('response Time (s)', 'region size (pixels)','CPU Power','Fontsize',24,'Location','NorthEast')

