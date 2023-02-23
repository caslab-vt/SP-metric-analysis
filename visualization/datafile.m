clc;
clear all;
close all;

%format [Sslam    Srrt    Smpc    Spath   S   P   SP   WCMS  AMS  %safety ]
%s20r30m40tcfs
t0=[        0.0364    0.0860    0.4654    0.1945    0.0381    0.6915    0.0688   17.4904    4.6870   30.7692];
std0=[       0.3270    0.1534    0.1199    0.3309    0.2696    0.2009    0.3059];

%s30r40m20tcfs
t20=[    0.3281    0.0920    0.4567    0.3526    0.1037    0.8564    0.1776   17.5527    3.4547   60.0000];
std20=[        0.3671    0.2181    0.1488    0.3554    0.3887    0.1269    0.4357];

t21=[        0.1655    0.1728   -0.1225    0.2515   -0.1384    0.8410   -0.1288   18.2520    4.3908    7.6923];
std21=[        0.3907    0.1508    0.2728    0.3828    0.2933    0.1294    0.3113];

t23=[      -0.0235    0.0517    0.4667    0.1602   -0.0183    0.8790    0.0359   18.0313    5.1913   38.4615];
std23=[        0.3155    0.1595    0.0937    0.3511    0.3447    0.0877    0.3935];

t2=(t20+t23)/2;
std2=(std20+std23)/2;


%s40r20m30tcfs
t31=[        0.0168   -0.0519    0.2016    0.0947   -0.2773    0.7655   -0.2684   17.5837    5.9859    7.1429];
std31=[        0.4321    0.2952    0.3084    0.4454    0.4838    0.1695    0.4967];

t3=[        0.1004   -0.0250    0.4564    0.1827   -0.1136    0.8440   -0.0790   17.9855    5.2594   26.6667];
std3=[        0.4114    0.2663    0.1596    0.4188    0.4026    0.1319    0.4425];

%r30m40tscfs
t4=[      -0.0699    0.0851    0.4849    0.0361   -0.1588    0.7191   -0.1335   17.6312    5.7646   28.5714];
std4=[       0.3898    0.2750    0.0545    0.4276    0.4777    0.2117    0.5052];


%s20m40allcfs
t5=[        0.0210   -0.0864    0.4618    0.1011   -0.1617    0.8959   -0.1415   18.1192    6.0687   14.2857];
std5=[        0.3911    0.2522    0.1379    0.3739    0.3919    0.0306    0.4164];

%s20r30fifo_allcfs
t6=[        0.0170    0.0321    0.2776    0.1318   -0.0777    0.9044   -0.0491   17.8026    5.1587   21.4286];
std6=[       0.3703    0.2120    0.2330    0.3567    0.3328         0    0.3682];

%m20fifo_allcfs
t7=[      -0.0118    0.0568    0.4808    0.1429   -0.0694    0.8170   -0.0382   17.9503    5.3901   23.0769];
std7=[        0.3571    0.2153    0.0664    0.3762    0.3523    0.1597    0.3882];

%r20allcfs
t8=[      -0.0456    0.0597    0.3481    0.0825   -0.1815    0.7441   -0.1576   18.1300    5.7921   28.5714];
std8=[        0.3805    0.2437    0.1975    0.4200    0.4741    0.1914    0.4991];

%s20fallcfs
t9=[        0.1605    0.0151   -0.1418    0.2315   -0.2008    0.8535   -0.2008   18.7767    5.0317         0];
std9=[        0.3903    0.2599    0.3185    0.3755    0.2867    0.1163    0.2867];

%allcfs
t10=[        0.0259    0.0725    0.4501    0.1391   -0.0972    0.6462   -0.0739   17.4316    5.3264   30.7692];
std10=[        0.4028    0.2520    0.1282    0.4116    0.4299    0.1828    0.4532];

%t10allcfs
t11=[     -0.2061    0.0712    0.3351   -0.2748   -0.3582    0.9044   -0.3582   18.1721    9.0345         0];
std11=[            0.3094    0.2093    0.1986    0.2518    0.3636         0    0.3636];

%t10s20r30m40
t12=[           0.0865    0.1384    0.4652    0.1419   -0.0760    0.8549   -0.0271   17.3507    5.0296   40.0000];
std12=[        0.4579    0.2865    0.1304    0.4478    0.4751    0.1029    0.5215];

%t10s30r40m20
t13=[        0.1117    0.1281    0.4670    0.2153    0.0419    0.9044    0.1087   17.4421    4.5411   50.0000];
std13=[        0.3732    0.1829    0.1102    0.3760    0.3588         0    0.4075];

%t10s40r20m30
t14=[        0.1205    0.0082    0.3888    0.2240   -0.0212    0.8686    0.0152   17.7192    4.8172   28.5714];
std14=[        0.3635    0.1251    0.2125    0.3520    0.3458    0.0947    0.3857];


%%

%            plot(x1,y1,'--gs', 'MarkerSize',5,'MarkerEdgeColor','green','MarkerFaceColor','green');
%             hold on

%             subplot(4,1,1)
%             ax = gca;
%             yyaxis left; cla; hold on;

%             labels = {'SLAM,TSP=CFS,RRT=FIFO1,MPC=FIFO2','SLAM,TSP,RRT=CFS,MPC=FIFO','SLAM,TSP,MPC=CFS,RRT=FIFO',...
%                 'SLAM=FIFO1,RRT=FIFO2,MPC=FIFO3','SLAM=FIFO2,RRT=FIFO3,MPC=FIFO1','SLAM=FIFO3,RRT=FIFO1,MPC=FIFO2'};
% 
%             errorbar(x1,y1,err1,'-g','linewidth',1,'MarkerSize',5,...
%                 'MarkerEdgeColor','green','MarkerFaceColor','green')
%             text(x1,y1,labels,'VerticalAlignment','bottom','HorizontalAlignment','center')
%              xticks([1 2 3 4 5 6])
% 
%             %ylabel('Response Time (s)','Fontsize',12)
%             %xlim([0.5 4.5])
%             legend('SLAM','Fontsize',12,'Location','NorthEast')
%             title('Xavier AGX 8 core MAXN SLAM prority correlation')

            %SLAM
            x1=[0,0,0,1,2,3,99];
            y1 = [t4(1),t7(1),t8(1),t0(1),t2(1),t3(1),t9(1)];
            err1 = [std4(1),std7(1),std8(1),std0(1),std2(1),std3(1),std9(1)];
            figure

            subplot(1,3,1)

            b=bar(y1);
            set(gca, 'XTickLabel',x1);
            xtips1 = b(1).XEndPoints;
            ytips1 = b(1).YEndPoints;
%             labels = {'SLAM,TSP=CFS,RRT=FIFO1,MPC=FIFO2','SLAM,TSP,RRT=CFS,MPC=FIFO','SLAM,TSP,MPC=CFS,RRT=FIFO',...
%                 'SLAM=FIFO1,RRT=FIFO2,MPC=FIFO3','SLAM=FIFO2,RRT=FIFO3,MPC=FIFO1','SLAM=FIFO3,RRT=FIFO1,MPC=FIFO2','SLAM=FIFO, All else=CFS'};
            labels={'S5','S4','S3','S8','S9','S10','S2'};
            text(xtips1,ytips1,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','Fontsize',8)
%             hold on
%             errorbar(y1, err1, '.')
            ylabel('S-SLAM');
            xlabel('SLAM relative priority');
%             title('(a)', 'FontSize', 15,'HorizontalAlignment','center','VerticalAlignment','bottom');

            %ylim([-.1 .3]);
            %legend('S-SLAM');
            %saveas(gcf,['bar_2', '.jpg'])
            

            %RRT
            x2=[0,0,0,1,2,3,99];
            y2 = [t5(2),t9(2),t7(2),t3(2),t0(2),t2(2),t8(2)];
            err2 = [std5(2),std9(2),std7(2),std3(2),std0(2),std2(2),std8(2)];
            %figure
            subplot(1,3,2)

            b=bar(y2);
            set(gca, 'XTickLabel',x2);
            xtips1 = b(1).XEndPoints;
            ytips1 = b(1).YEndPoints;
            labels={'S6','S2','S4','S10','S8','S9','S3'};

%             labels = {'RRT,TSP=CFS,SLAM=FIFO1,MPC=FIFO2','RRT,MPC,TSP=CFS,SLAM=FIFO','SLAM,RRT,TSP=CFS,MPC=FIFO',...
%                 'RRT=FIFO1,MPC=FIFO2,SLAM=FIFO3','RRT=FIFO2,MPC=FIFO3,SLAM=FIFO1','RRT=FIFO3,MPC=FIFO1,SLAM=FIFO2','RRT=FIFO, ALL ELSE=CFS'};
            text(xtips1,ytips1,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','Fontsize',8)
%             hold on
%             errorbar(y1, err1, '.')
            ylabel('S-RRT');
            xlabel('RRT relative priority');
%             title('(b)', 'FontSize', 15,'HorizontalAlignment','center','VerticalAlignment','bottom');

            %ylim([-.1 .1]);
            %legend('S-RRT');
            %saveas(gcf,['bar_2', '.jpg'])

             %MPC
            x3=[0,0,1,2,3,99];
            y3 = [t6(3),t8(3),t2(3),t3(3),t0(3),t7(3)];
            err3 = [std6(3),std8(3),std2(3),std3(3),std0(3),std7(3)];
            %figure
            subplot(1,3,3)
            b=bar(y3);
            set(gca, 'XTickLabel',x3);
            xtips1 = b(1).XEndPoints;
            ytips1 = b(1).YEndPoints;
            labels={'S7','S3','S9','S10','S8','S4'};

%             labels = {'MPC,TSP=CFS,SLAM=FIFO1,RRT=FIFO2','RRT=FIFO, ALL ELSE CFS',...
%                 'MPC=FIFO1,SLAM=FIFO2,RRT=FIFO3','MPC=FIFO2,SLAM=FIFO3,RRT=FIFO1','MPC=FIFO3,SLAM=FIFO1,RRT=FIFO2','MPC=FIFO, ALL ELSE=CFS'};
            text(xtips1,ytips1,labels,'HorizontalAlignment','center','VerticalAlignment','bottom','Fontsize',8)
%             hold on
%             errorbar(y1, err1, '.')
            ylabel('S-MPC');
            xlabel('MPC relative priority');
%             title('(c)', 'FontSize', 15,'HorizontalAlignment','center','VerticalAlignment','bottom');

            %ylim([.2 .65]);
            %legend('S-MPC');
            %saveas(gcf,['bar_2', '.jpg'])
%             %MPC
%             x3=[0,0,0,1,2,3,99];
%             y3 = [t9(3),t8(3),t6(3),t2(3),t3(3),t0(3),t7(3)];
%             err3 = [std9(3),std8(3),std6(3),std2(3),std3(3),std0(3),std7(3)];
%             figure
%             b=bar(y3);
%             set(gca, 'XTickLabel',x3);
%             xtips1 = b(1).XEndPoints;
%             ytips1 = b(1).YEndPoints;
%             labels = {'SLAM=FIFO, ALL ELSE = CFS','RRT=FIFO, ALL ELSE CFS','MPC,TSP=CFS,SLAM=FIFO1,RRT=FIFO2',...
%                 'MPC=FIFO1,SLAM=FIFO2,RRT=FIFO3','MPC=FIFO2,SLAM=FIFO3,RRT=FIFO1','MPC=FIFO3,SLAM=FIFO1,RRT=FIFO2','MPC=FIFO, ALL ELSE=CFS'};
%             text(xtips1,ytips1,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')
% %             hold on
% %             errorbar(y1, err1, '.')
%             ylabel('S-MPC');
%             xlabel('relative priority');
% 
%             %ylim([20 140]);
%             legend('S-MPC');
%             %saveas(gcf,['bar_2', '.jpg'])
%%
%             x = [{'S'},{'SP'},{'%Safety'},{'5/WCMS'},{'1/AMS'}];
%             vals = [t11(5), t9(5), t12(5), t10(5), t6(5), t0(5), t2(5); t11(7), t9(7), t12(7), t10(7), t6(7), t0(7), t2(7) ;...
%                 t11(10)/100, t9(10)/100, t12(10)/100, t10(10)/100, t6(10)/100, t0(10)/100, t2(10)/100 ;...
%                 5/t11(8), 5/t9(8), 5/t12(8), 5/t10(8), 5/t6(8), 5/t0(8), 5/t2(8);...
%                 1/t11(9), 1/t9(9), 1/t12(9), 1/t10(9), 1/t6(9), 1/t0(9), 1/t2(9)];
%             
%             b = bar(vals);
%             set(gca, 'XTickLabel',x);
%             xtips2 = b(2).XEndPoints;
%             ytips2 = b(2).YEndPoints;
% %             labels2 = {'Schd1','Schd2','Schd3','Schd4','Schd5','Schd6','Schd7'};
% %             text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
% %                 'VerticalAlignment','bottom')
%             legend('Schedu1e1','Schd2','Schd3','Schd4','Schd5','Schd6','Schd7');
%             ylabel('Normalized values');



            figure
            subplot(2,1,1)
            x = [{'S'},{'SP'}];
            vals = [t11(5), t9(5), t12(5), t10(5), t6(5), t0(5), t2(5), t13(5); t11(7), t9(7), t12(7), t10(7), t6(7), t0(7), t2(7), t13(7)];
            
            b = bar(vals);
            set(gca, 'XTickLabel',x);
            xtips2 = b(2).XEndPoints;
            ytips2 = b(2).YEndPoints;
%             labels2 = [{'S1','S2','S11','S13','S7','S8','S9','S12'},{'S1','S2','S11','S13','S7','S8','S9','S12'}];
%             text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
%                  'VerticalAlignment','bottom')
            %legend('S1','S2','S11','S13','S7','S8','S9','S12');
            ylabel('Actual values');
             %ylim([-.4 .4]);

            subplot(2,1,2)
            x = [{'4/WCMS'},{'1/AMS'}];
            vals = [ 4/t11(8), 4/t9(8), 4/t12(8), 4/t10(8), 4/t6(8), 4/t0(8), 4/t2(8), 4/t13(8);...
                1/t11(9), 1/t9(9), 1/t12(9), 1/t10(9), 1/t6(9), 1/t0(9), 1/t2(9), 1/t13(9)];
            
            b = bar(vals);
            set(gca, 'XTickLabel',x);
            xtips2 = b(2).XEndPoints;
            ytips2 = b(2).YEndPoints;
             labels2 = {'S1','S2','S11','S13','S7','S8','S9','S12'};
%             text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
%                 'VerticalAlignment','bottom')
            %legend('Schedu1e1','Schedu1e2','Schedu1e3','Schedu1e4','Schedu1e5','Schedu1e6','Schedu1e7');
            ylabel('Normalized values');
