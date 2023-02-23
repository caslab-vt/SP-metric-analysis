clc;
% clear all;
close all;
num = xlsread('SP_time_t10s20r30m40fifo_bu.xlsx'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
% time = (0:1:(length(num)-1))';
st_slam=num(:,8);
rt_slam=num(:,2);
st_rrt=num(:,9);
rt_rrt=num(:,10);
st_slam_mpc=num(:,13);
st_mpc=num(:,14);
rt_mpc=num(:,15);
rt_path=num(:,14)-num(:,13)+num(:,15);
P=num(:,25);
 st_dummy=num(1,1);

    d_rt_slam=[];
    d_rt_rrt=[];
    d_rt_mpc=[];
    d_rt_path=[];
SP=[];
SPm=[];
SPslam=[];
SPrrt=[];
SPmpc=[];
SPpath=[];
SPi=[];
WCMS=[];
ART=[];
mean_slam=1.360387724;
std_slam=2.2317932;
mean_mpc=0.024897446;
std_mpc=0.002504779;
mean_rrt=1.000517992;
std_rrt=0.259475283;
mean_path=5.853386303;
std_path=4.183426061;
% mean_slam=mean(rt_slam);
% std_slam=std(rt_slam);
% mean_rrt=mean(rt_rrt);
% std_rrt=std(rt_rrt);
% mean_mpc=mean(rt_mpc);
% std_mpc=std(rt_rrt);
% mean_path=mean(rt_path);
% std_path=std(rt_path);
lambda_path=0.5;
lambda_slam=0.5;
lambda_rrt=0.5;
lambda_mpc=0.5;
ii=1;
k=1;
% pdf_slam = makedist('Normal','mu',mean_slam,'sigma',std_slam);
% pdf_rrt=makedist('Normal','mu',mean_rrt,'sigma',std_rrt);
% pdf_mpc=makedist('Normal','mu',mean_mpc,'sigma',std_mpc);
% pdf_path=makedist('Normal','mu',mean_path,'sigma',std_path);
mean_c_slam=0;
mean_c_rrt=0;
mean_c_mpc=0;
mean_c_path=0;
max_path=0;
i=1;
safe=0;

Sslam=0;
Srrt=0;
Smpc=0;
Spath=0;

% for i=1:length(st_rrt)
%     
%     if (~isnan(st_rrt(i)))
%     while (~isnan(st_slam(i)))
    while (st_slam(i)<=st_slam_mpc(end))&&(~isnan(st_slam(i)))


        while (st_slam(i)-st_dummy<10)&&(st_slam(i)<=st_slam_mpc(end))&&(~isnan(st_slam(i)))
    %         d_rt_slam(end+1) = rt_slam(i);
    %         d_rt_rrt(end+1) = rt_rrt(i);
            I = find(st_slam_mpc == st_slam(i));
            i_rt_mpc=mean(rt_mpc(I));
            i_rt_path=mean(rt_path(I));
            m_rt_path=max(rt_path(I));
             d_rt_slam(end+1) = rt_slam(i);
             d_rt_rrt(end+1) = rt_rrt(i);
             d_rt_mpc(end+1) = i_rt_mpc;
             d_rt_path(end+1) = i_rt_path;
             if(max_path<m_rt_path)
                 max_path=m_rt_path;
             end 
               
%             if (k==1)
%              mean_c_slam=cdf(pdf_slam,rt_slam(i),'upper')
%              mean_c_rrt=cdf(pdf_rrt,rt_rrt(i),'upper');
%              mean_c_mpc=cdf(pdf_mpc,d_rt_mpc,'upper');         
%              mean_c_path=cdf(pdf_path,d_rt_path,'upper');
%              max_path=m_rt_path;
% 
% 
%             else
%              mean_c_slam=(k-1)*mean_c_slam/k+(cdf(pdf_slam,rt_slam(i),'upper'))/k;
%              mean_c_rrt=(k-1)*mean_c_rrt/k+(cdf(pdf_rrt,rt_rrt(i),'upper'))/k;
%              mean_c_mpc=(k-1)*mean_c_mpc/k+(cdf(pdf_mpc,d_rt_mpc,'upper'))/k;         
%              mean_c_path=(k-1)*mean_c_path/k+(cdf(pdf_path,d_rt_path,'upper'))/k;
%              if(max_path<m_rt_path)
%                  max_path=m_rt_path;
%              end     
%           
%             end 

    %         for j=1:length(rt_mpc)
    %             if(st_slam_mpc(j)==st_slam(i))
    %                 d_rt_mpc(end+1) = rt_mpc(j);
    %                 d_rt_path(end+1) = rt_path(j);
    % 
    %             end
    %         end
            k=k+1;
            i=i+1;
        end
        ii
        d_rt_mpc
        d_rt_rrt
        d_rt_slam
        rt_slam(i-1)
        rt_rrt(i-1)
        if(k>2)
            mean_c_slam=cdf('Normal',mean_slam,mean(d_rt_slam),std(d_rt_slam),'upper');
            mean_c_rrt=cdf('Normal',mean_rrt,mean(d_rt_rrt),std(d_rt_rrt),'upper');
            mean_c_mpc=cdf('Normal',mean_mpc,mean(d_rt_mpc),std(d_rt_mpc),'upper');
            mean_c_path=cdf('Normal',mean_path,mean(d_rt_path),std(d_rt_path),'upper');
        else
             if(rt_slam(i-1)>mean_slam)
                 mean_c_slam=1;
             else
                 mean_c_slam=0;
             end
             if(rt_rrt(i-1)>mean_rrt)
                 mean_c_rrt=1;
             else
                 mean_c_rrt=0;
             end
             if(i_rt_mpc>mean_mpc)
                 mean_c_mpc=1;
             else
                 mean_c_mpc=0;
             end
             if(i_rt_path>mean_path)
                 mean_c_path=1;
             else
                 mean_c_path=0;
             end
            
        end

    %         cdf_slam=cdf('Normal',d_rt_slam,mean_slam,std_slam)
    %         mean_c_slam=mean(cdf_slam);
    %         cdf_rrt=cdf('Normal',d_rt_rrt,mean_rrt,std_rrt);
    %         mean_c_rrt=mean(cdf_rrt);
    %         cdf_mpc=cdf('Normal',d_rt_mpc,mean_mpc,std_mpc);
    %         mean_c_mpc=mean(cdf_mpc);
    %         cdf_path=cdf('Normal',d_rt_path,mean_path,std_path);
    %         mean_c_path=mean(cdf_path);
    %         d_rt_path;
    %         max_path=max(d_rt_path);
            WCMS(ii)=max_path;
            ART(ii)=mean(d_rt_path);
%            SP(ii)=(lambda_path-mean_c_path)/4+(lambda_slam-mean_c_slam)/4+(lambda_rrt-mean_c_rrt)/4+(lambda_mpc-mean_c_mpc)/4;
            SPslam(ii)=(lambda_slam-mean_c_slam);
            SPrrt(ii)=(lambda_rrt-mean_c_rrt);
            SPmpc(ii)=(lambda_mpc-mean_c_mpc);
            SPpath(ii)=(lambda_path-mean_c_path);
%             if(SPslam(ii)<0)||(SPrrt(ii)<0)||(SPmpc(ii)<0)||(SPpath(ii)<0)
%                 SP(ii)=-abs((lambda_path-mean_c_path)/4+(lambda_slam-mean_c_slam)/4+(lambda_rrt-mean_c_rrt)/4+(lambda_mpc-mean_c_mpc)/4);
%             else
%                 SP(ii)=(lambda_path-mean_c_path)/4+(lambda_slam-mean_c_slam)/4+(lambda_rrt-mean_c_rrt)/4+(lambda_mpc-mean_c_mpc)/4;
%             end
            if(SPslam(ii)<0)
                Sslam=-0.01*exp(10*abs(SPslam(ii)));
            else
                Sslam=log(SPslam(ii)+1);                
            end
            if(SPrrt(ii)<0)
                Srrt=-0.01*exp(10*abs(SPrrt(ii)));
            else
                Srrt=log(SPrrt(ii)+1);                
            end
            if(SPmpc(ii)<0)
                Smpc=-0.01*exp(10*abs(SPmpc(ii)));
            else
                Smpc=log(SPmpc(ii)+1);                
            end
            if(SPpath(ii)<0)
                Spath=-0.01*exp(10*abs(SPpath(ii)));
            else
                Spath=log(SPpath(ii)+1);                
            end
            
            SP_arr=[Sslam Srrt Smpc Spath];
       
            if(SPslam(ii)>=0)&&(SPrrt(ii)>=0)&&(SPmpc(ii)>=0)&&(SPpath(ii)>=0)
                SP(ii)= mean(SP_arr);
                SPm(ii)=0.8*SP(ii)+0.2*(100-P(ii))/100;

            else%if(SPslam(ii)<0)||(SPrrt(ii)<0)||(SPrrt(ii)<0)||(SPpath(ii)<0)
                SP(ii)= mean(SP_arr.*(SP_arr<0));
                SPm(ii)=SP(ii);
            end
%             SP(ii)=Sslam/4+Srrt/4+Smpc/4+Spath/4+(100-P(ii))/100;
            %SP(ii)=Sslam/4+Srrt/4+Smpc/4+Spath/4;
            
            if (SP(ii)>=0)
            safe=safe+1;
            end
            
            d_rt_slam=[];
            d_rt_rrt=[];
            d_rt_mpc=[];
            d_rt_path=[];

%             SPi(ii)=st_slam(i);
            SPi(ii)=ii;

            ii=ii+1;
            %continue;
            mean_c_slam=0;
            mean_c_rrt=0;
            mean_c_mpc=0;
            mean_c_path=0;
            max_path=0;


        st_dummy=st_slam(i);
        %i=i+1;
        k=1;

    end
    
        safe
ii
100*safe/ii
[mean(SPslam) mean(SPrrt) mean(SPmpc) mean(SPpath) mean(SP) mean((100-P(1:length(SPi)))/100) mean(SPm) max(WCMS) mean(ART) 100*safe/ii]
[std(SPslam) std(SPrrt) std(SPmpc) std(SPpath) std(SP) std((100-P(1:length(SPi)))/100) std(SPm)]

%     else
%         break;
%     end
%     
% end

% figure('Name','Xavier AGX FIFO SLAM 20, rrt 30');


   figure('Name','individual contr TSP 20 FIFO all cfs');
            title('TSP 20 FIFO all cfs')
subplot(6,1,1)
            yyaxis left; cla; hold on;
            plot(SPi,SPslam,'-g','linewidth',2)% plotted every data as plotting all was making the graph too dense to see
            plot(xlim, [1 1]*mean(SPslam), '--k')                % First Horizontal Line at ‘y=4.5’

                               ylabel('Sslam','Fontsize',24)
            title('TSP 20 FIFO all cfs')

%             yyaxis right; cla; hold on;
%             plot(SPi,WCMS,'-k','linewidth',2)
           subplot(6,1,2)
            yyaxis left; cla; hold on;
            plot(SPi,SPrrt,'-g','linewidth',2)% plotted every data as plotting all was making the graph too dense to see
            plot(xlim, [1 1]*mean(SPrrt), '--k')                % First Horizontal Line at ‘y=4.5’
                                                ylabel('Srrt','Fontsize',24)

%             yyaxis right; cla; hold on;
%             plot(SPi,WCMS,'-k','linewidth',2)
            subplot(6,1,3)
            yyaxis left; cla; hold on;
            plot(SPi,SPmpc,'-g','linewidth',2)% plotted every data as plotting all was making the graph too dense to see
            plot(xlim, [1 1]*mean(SPmpc), '--k')                % First Horizontal Line at ‘y=4.5’
                                                ylabel('Smpc','Fontsize',24)

%             yyaxis right; cla; hold on;
%             plot(SPi,WCMS,'-k','linewidth',2)
            subplot(6,1,4)
            yyaxis left; cla; hold on;
            plot(SPi,SPpath,'-g','linewidth',2)% plotted every data as plotting all was making the graph too dense to see
            plot(xlim, [1 1]*mean(SPpath), '--k')                % First Horizontal Line at ‘y=4.5’
                                                ylabel('Spath','Fontsize',24)

            yyaxis right; cla; hold on;
            plot(SPi,WCMS,'-k','linewidth',2)
                        ylabel('Makespan','Fontsize',24)

            legend('S path','S path mean', 'Worst-case Makespan','Fontsize',14,'Location','NorthEast')
            
            subplot(6,1,5)

            yyaxis left; cla; hold on;
            plot(SPi,SP,'-g','linewidth',2)% plotted every data as plotting all was making the graph too dense to see
            plot(xlim, [1 1]*mean(SP), '--k')                % First Horizontal Line at ‘y=4.5’
                                    ylabel('S','Fontsize',24)

            yyaxis right; cla; hold on;
            plot(SPi,WCMS,'-k','linewidth',2)
            ylabel('Makespan','Fontsize',24)
            legend('S','S mean', 'Worst-case Makespan','Fontsize',14,'Location','NorthEast')
            
            
            subplot(6,1,6)

            yyaxis left; cla; hold on;
            plot(SPi,(100-P(1:length(SPi))),'-g','linewidth',2)% plotted every data as plotting all was making the graph too dense to see
            plot(xlim, [1 1]*mean(100-P(1:length(SPi))), '--k')                % First Horizontal Line at ‘y=4.5’
                                    ylabel('P','Fontsize',24)

            yyaxis right; cla; hold on;
            plot(SPi,WCMS,'-k','linewidth',2)
            ylabel('Makespan','Fontsize',24)
            legend('P(sol opt%)','mean P', 'Worst-case Makespan','Fontsize',14,'Location','NorthEast')
