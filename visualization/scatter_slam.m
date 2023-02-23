clc;
clear all;
close all;  

            x1=[1,2,3,4,5,6,7,8,9,10];
            y1 = [.0364, .3281, .0168, -.0699, .021, .017, -.012, -.046, .16, .04];
            y2 = [.08, .09, -.052, .085, -.086, .032, .057, .0597, .015, .121];
            y3 = [.465, .457, .202, .485, .462, .278, .481, .348, -.142, .38 ];
            y4 = [.195, .353, .095, .036, .101, .132, .143, .083, .23, .15  ];
            y5 = [.139, .182, -.138, -.05, -.012, .017, .063, -.079, -.04, .076 ];
            y6 = [.69 , .85, .76, .71, .89 , .9 , .89, .75, .85, .78 ];
figure('Name','individual contr FIFO SLAM 20 RRT 30 MPC 40');
            title(' TSP-CFS FIFO SLAM 20 RRT 30 MPC 40')
            
                        ax = gca;

%             err1 = [num(1,3),num(5,3),num(9,3),num(13,3)];
            plot(x1,y1,'--gs', 'MarkerSize',5,'MarkerEdgeColor','green','MarkerFaceColor','green');
            hold on
                plot(x1,y2,'--bs','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue');
                            hold on
               plot( x1,y3,'--rs','MarkerSize',5,'MarkerEdgeColor','red','MarkerFaceColor','red');
                           hold on
               plot( x1,y4,'--cs','MarkerSize',5,'MarkerEdgeColor','cyan','MarkerFaceColor','cyan');
                           hold on
               plot( x1,y5,'--ks','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','black');
                           hold on
               plot( x1,y6,'--ms','MarkerSize',5,'MarkerEdgeColor','magenta','MarkerFaceColor','magenta');
            labels = {'FIFO SLAM 1 RRT 2 MPC 3','FIFO SLAM 2 RRT 3 MPC 1','FIFO SLAM 3 RRT 1 MPC 2','SLAM CFS RRT F1 MPC F2','SLAM F1 RRT CFS MPC F2',...
                'SLAM F1 RRT F2 MPC CFS', 'SLAM CFS RRT CFS MPC FIFO', 'SLAM CFS RRT FIFO MPC CFS', 'SLAM FIFO RRT CFS MPC CFS', 'ALL CFS'};

%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
            text(x1,y3,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
             xticks([1 2 3 4 5 6 7 8 9 10])

            %ylabel('Response Time (s)','Fontsize',12)
%             xlim([0.5 4.5])
            legend('S-SLAM','S-RRT','S-MPC','S-PATH','S','P','Fontsize',12,'Location','NorthEast')
            
  figure('Name','correlation study with priority');
            title(' correlation study with priority')          
subplot(6,1,1)
            ax = gca;
%             x1=[1,2,3,4,5,6,7,8,9,10];
%             y1 = [.0364, .3281, .0168, -.0699, .021, .017, -.012, -.046, .16, .04];
%             err1 = [num(1,3),num(5,3),num(9,3),num(13,3)];
            plot(x1,y1,'--gs','MarkerSize',5,'MarkerEdgeColor','green','MarkerFaceColor','green');
            labels = {'FIFO SLAM 1 RRT 2 MPC 3','FIFO SLAM 2 RRT 3 MPC 1','FIFO SLAM 3 RRT 1 MPC 2','SLAM CFS RRT F1 MPC F2','SLAM F1 RRT CFS MPC F2',...
                'SLAM F1 RRT F2 MPC CFS', 'SLAM CFS RRT CFS MPC FIFO', 'SLAM CFS RRT FIFO MPC CFS', 'SLAM FIFO RRT CFS MPC CFS', 'ALL CFS'};

%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
            text(x1,y1,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
             xticks([1 2 3 4 5 6 7 8 9 10])

            %ylabel('Response Time (s)','Fontsize',12)
%             xlim([0.5 4.5])
            legend('S-SLAM','Fontsize',12,'Location','NorthEast')
%            title('Xavier NX 2 core 15W All FIFO')


%             yyaxis right; cla; hold on;
%             plot(SPi,WCMS,'-k','linewidth',2)
           subplot(6,1,2)
            ax = gca;
%             x1=[1,2,3,4,5,6,7,8,9,10];
%             y1 = [.08, .09, -.052, .085, -.086, .032, .057, .0597, .015, .121];
%             err1 = [num(1,3),num(5,3),num(9,3),num(13,3)];
            plot(x1,y2,'--bs','MarkerSize',5,'MarkerEdgeColor','blue','MarkerFaceColor','blue');
%             labels = {'FIFO SLAM 1 RRT 2 MPC 3','FIFO SLAM 2 RRT 3 MPC 1','FIFO SLAM 3 RRT 1 MPC 2','SLAM CFS RRT F1 MPC F2','SLAM F1 RRT CFS MPC F2',...
%                 'SLAM F1 RRT F2 MPC CFS', 'SLAM CFS RRT CFS MPC FIFO', 'SLAM CFS RRT FIFO MPC CFS', 'SLAM FIFO RRT CFS MPC CFS', 'ALL CFS'};

%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
           % text(x1,y1,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
             xticks([1 2 3 4 5 6 7 8 9 10])

            %ylabel('Response Time (s)','Fontsize',12)
%             xlim([0.5 4.5])
            legend('S-RRT','Fontsize',12,'Location','NorthEast')
            
            
           subplot(6,1,3)
            ax = gca;
%             x1=[1,2,3,4,5,6,7,8,9,10];
%             y1 = [.08, .09, -.052, .085, -.086, .032, .057, .0597, .015, .121];
%             err1 = [num(1,3),num(5,3),num(9,3),num(13,3)];
            plot(x1,y3,'--rs','MarkerSize',5,'MarkerEdgeColor','red','MarkerFaceColor','red');
%             labels = {'FIFO SLAM 1 RRT 2 MPC 3','FIFO SLAM 2 RRT 3 MPC 1','FIFO SLAM 3 RRT 1 MPC 2','SLAM CFS RRT F1 MPC F2','SLAM F1 RRT CFS MPC F2',...
%                 'SLAM F1 RRT F2 MPC CFS', 'SLAM CFS RRT CFS MPC FIFO', 'SLAM CFS RRT FIFO MPC CFS', 'SLAM FIFO RRT CFS MPC CFS', 'ALL CFS'};

%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
            %text(x1,y1,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
             xticks([1 2 3 4 5 6 7 8 9 10])

            %ylabel('Response Time (s)','Fontsize',12)
%             xlim([0.5 4.5])
            legend('S-MPC','Fontsize',12,'Location','NorthEast')         
            
            
           subplot(6,1,4)
            ax = gca;
%             x1=[1,2,3,4,5,6,7,8,9,10];
%             y1 = [.08, .09, -.052, .085, -.086, .032, .057, .0597, .015, .121];
%             err1 = [num(1,3),num(5,3),num(9,3),num(13,3)];
            plot(x1,y3,'--cs','MarkerSize',5,'MarkerEdgeColor','cyan','MarkerFaceColor','cyan');
%             labels = {'FIFO SLAM 1 RRT 2 MPC 3','FIFO SLAM 2 RRT 3 MPC 1','FIFO SLAM 3 RRT 1 MPC 2','SLAM CFS RRT F1 MPC F2','SLAM F1 RRT CFS MPC F2',...
%                 'SLAM F1 RRT F2 MPC CFS', 'SLAM CFS RRT CFS MPC FIFO', 'SLAM CFS RRT FIFO MPC CFS', 'SLAM FIFO RRT CFS MPC CFS', 'ALL CFS'};

%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
            %text(x1,y1,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
             xticks([1 2 3 4 5 6 7 8 9 10])

            %ylabel('Response Time (s)','Fontsize',12)
%             xlim([0.5 4.5])
            legend('S-PATH','Fontsize',12,'Location','NorthEast')
            
           subplot(6,1,5)
            ax = gca;
%             x1=[1,2,3,4,5,6,7,8,9,10];
%             y1 = [.08, .09, -.052, .085, -.086, .032, .057, .0597, .015, .121];
%             err1 = [num(1,3),num(5,3),num(9,3),num(13,3)];
            plot(x1,y5,'--ks','MarkerSize',5,'MarkerEdgeColor','black','MarkerFaceColor','black');
%             labels = {'FIFO SLAM 1 RRT 2 MPC 3','FIFO SLAM 2 RRT 3 MPC 1','FIFO SLAM 3 RRT 1 MPC 2','SLAM CFS RRT F1 MPC F2','SLAM F1 RRT CFS MPC F2',...
%                 'SLAM F1 RRT F2 MPC CFS', 'SLAM CFS RRT CFS MPC FIFO', 'SLAM CFS RRT FIFO MPC CFS', 'SLAM FIFO RRT CFS MPC CFS', 'ALL CFS'};

%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
            %text(x1,y1,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
             xticks([1 2 3 4 5 6 7 8 9 10])

            %ylabel('Response Time (s)','Fontsize',12)
%             xlim([0.5 4.5])
            legend('S','Fontsize',12,'Location','NorthEast')
            
            
           subplot(6,1,6)
            ax = gca;
%             x1=[1,2,3,4,5,6,7,8,9,10];
%             y1 = [.08, .09, -.052, .085, -.086, .032, .057, .0597, .015, .121];
%             err1 = [num(1,3),num(5,3),num(9,3),num(13,3)];
            plot(x1,y6,'--ms','MarkerSize',5,'MarkerEdgeColor','magenta','MarkerFaceColor','magenta');
%             labels = {'FIFO SLAM 1 RRT 2 MPC 3','FIFO SLAM 2 RRT 3 MPC 1','FIFO SLAM 3 RRT 1 MPC 2','SLAM CFS RRT F1 MPC F2','SLAM F1 RRT CFS MPC F2',...
%                 'SLAM F1 RRT F2 MPC CFS', 'SLAM CFS RRT CFS MPC FIFO', 'SLAM CFS RRT FIFO MPC CFS', 'SLAM FIFO RRT CFS MPC CFS', 'ALL CFS'};

%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
            %text(x1,y1,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
             xticks([1 2 3 4 5 6 7 8 9 10])

            %ylabel('Response Time (s)','Fontsize',12)
%             xlim([0.5 4.5])
            legend('P','Fontsize',12,'Location','NorthEast')            