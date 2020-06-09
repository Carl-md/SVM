tic;
close all;
clear;
clc;
format compact;
%% 数据的提取和预处理
A=xlsread('GFSJy.xlsx','原始数据','B13887:N14606');
% 提取数据
A(find(A(:,1)==0),:)=[];
A=A';
[B,ps]=mapminmax(A,0,1);
B=B';
[m,n] = size(B);
Y = B(1:m,1);
Y_train = Y(1:450,:);
Y_test = Y(451:end,:);
X = B(1:m,2:13);
X_train = X(1:450,:);
X_test = X(451:end,:);
%% 进行SVM网络训练
Mdl = fitrsvm(X_train,Y_train,'KernelFunction','gaussian','BoxConstraint',0.3,'Epsilon',0.01,'KernelScale','auto','Standardize',true);
%%model = svmtrain(Y_train,X_train,'-s 3 -t 2 -c 2.2 -g 2.8 -p 0.01');
%%-s svm类型：SVM设置类型(默认0)
%   0 -- C-SVC
%　 1 -- v-SVC
% 　2 -- 一类SVM
%　 3 -- e-SVR
%　 4 -- v-SVR
%%-t 核函数类型：核函数设置类型(默认2)
%　 0 – 线性：u'v
%　 1 – 多项式：(r*u'v + coef0)^degree
%　 2 – RBF函数：exp(-r|u-v|^2)
%　 3 – sigmoid：tanh(r*u'v + coef0)
%%-g gama：核函数中的gamma函数设置(针对多项式/rbf/sigmoid核函数)
%%-c cost：惩罚系数，设置C-SVC，e-SVR和v-SVR的参数(损失函数)(默认1)
%%-n nu：设置v-SVC，一类SVM和v-SVR的参数(默认0.5)
%%-p p：设置e-SVR中损失函数p的值(默认0.1)
%%-d degree：核函数中的degree设置(针对多项式核函数)(默认3)
%%-wi weight：设置第几类的参数C为weight*C(C-SVC中的C)(默认1)
%%-v n:n-fold交互检验模式，n为fold的个数，必须大于等于2
%% 进行SVM网络预测
Y_predict = predict(Mdl,X_test);
%% 计算统计指标mae和mse，并打印结果
mse = sum((Y_test-Y_predict).^2)./16;
mae = sum(abs(Y_test-Y_predict))/16;
disp( ['MAE = ', num2str( mae )] );
disp( ['MSE = ', num2str( mae )] );
%% 结果分析
figure(1);
hold on;
plot(Y_test,'-o');
plot(Y_predict,'r-^');
legend('原始值','SVM预测值');
hold off;
title('原始数据和SVM预测数据对比','FontSize',12);
xlabel('时间/h','FontSize',12);
ylabel('功率值/W','FontSize',12);
grid on;
figure(2);
error = Y_predict - Y_test;
plot(error,'-d');
title('误差图','FontSize',12);
xlabel('时间/h','FontSize',12);
ylabel('误差量/W','FontSize',12);
grid on;