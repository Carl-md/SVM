tic;
close all;
clear;
clc;
format compact;
%% 数据的提取和预处理
A = xlsread('GFSJy.xlsx','Sheet1','B2:N697');

% 载入测试数据上证指数(1990.12.19-2009.08.19)
% 数据是一个4579*6的double型的矩阵,每一行表示每一天的上证指数
% 6列分别表示当天上证指数的开盘指数,指数最高值,指数最低值,收盘指数,当日交易量,当日交易额.
load chapter14_sh.mat;

% 提取数据
[m,n] = size(sh);
ts = sh(2:m,1);
tsx = sh(1:m-1,:);

% 画出原始上证指数的每日开盘数
figure;
plot(ts,'LineWidth',2);
title('上证指数的每日开盘数(1990.12.20-2009.08.19)','FontSize',12);
xlabel('交易日天数(1990.12.19-2009.08.19)','FontSize',12);
ylabel('开盘数','FontSize',12);
grid on;

% 数据预处理,将原始数据进行归一化
ts = ts';
tsx = tsx';

% mapminmax为matlab自带的映射函数	
% 对ts进行归一化
[TS,TSps] = mapminmax(ts,1,2);	

% 画出原始上证指数的每日开盘数归一化后的图像
figure;
plot(TS,'LineWidth',2);
title('原始上证指数的每日开盘数归一化后的图像','FontSize',12);
xlabel('交易日天数(1990.12.19-2009.08.19)','FontSize',12);
ylabel('归一化后的开盘数','FontSize',12);
grid on;
% 对TS进行转置,以符合libsvm工具箱的数据格式要求
TS = TS';

% mapminmax为matlab自带的映射函数
% 对tsx进行归一化
[TSX,TSXps] = mapminmax(tsx,1,2);	
% 对TSX进行转置,以符合libsvm工具箱的数据格式要求
TSX = TSX';

%% 选择回归预测分析最佳的SVM参数c&g

% 首先进行粗略选择: 
[bestmse,bestc,bestg] = SVMcgForRegress(TS,TSX,-8,8,-8,8);

% 打印粗略选择结果
disp('打印粗略选择结果');
str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g',bestmse,bestc,bestg);
disp(str);

% 根据粗略选择的结果图再进行精细选择: 
[bestmse,bestc,bestg] = SVMcgForRegress(TS,TSX,-4,4,-4,4,3,0.5,0.5,0.05);

% 打印精细选择结果
disp('打印精细选择结果');
str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g',bestmse,bestc,bestg);
disp(str);

%% 利用回归预测分析最佳的参数进行SVM网络训练
cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 3 -p 0.01'];
model = svmtrain(TS,TSX,cmd);

%% SVM网络回归预测
[predict,mse] = svmpredict(TS,TSX,model);
predict = mapminmax('reverse',predict',TSps);
predict = predict';

% 打印回归结果
str = sprintf( '均方误差 MSE = %g 相关系数 R = %g%%',mse(2),mse(3)*100);
disp(str);

%% 结果分析
figure;
hold on;
plot(ts,'-o');
plot(predict,'r-^');
legend('原始数据','回归预测数据');
hold off;
title('原始数据和回归预测数据对比','FontSize',12);
xlabel('交易日天数(1990.12.19-2009.08.19)','FontSize',12);
ylabel('开盘数','FontSize',12);
grid on;

figure;
error = predict - ts';
plot(error,'rd');
title('误差图(predicted data - original data)','FontSize',12);
xlabel('交易日天数(1990.12.19-2009.08.19)','FontSize',12);
ylabel('误差量','FontSize',12);
grid on;

figure;
error = (predict - ts')./ts';
plot(error,'rd');
title('相对误差图(predicted data - original data)/original data','FontSize',12);
xlabel('交易日天数(1990.12.19-2009.08.19)','FontSize',12);
ylabel('相对误差量','FontSize',12);
grid on;
snapnow;
toc;