tic;
close all;
clear;
clc;
format compact;
%% ���ݵ���ȡ��Ԥ����
A=xlsread('GFSJy.xlsx','ԭʼ����','B13887:N14606');
% ��ȡ����
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
%% ����SVM����ѵ��
Mdl = fitrsvm(X_train,Y_train,'KernelFunction','gaussian','BoxConstraint',0.3,'Epsilon',0.01,'KernelScale','auto','Standardize',true);
%%model = svmtrain(Y_train,X_train,'-s 3 -t 2 -c 2.2 -g 2.8 -p 0.01');
%%-s svm���ͣ�SVM��������(Ĭ��0)
%   0 -- C-SVC
%�� 1 -- v-SVC
% ��2 -- һ��SVM
%�� 3 -- e-SVR
%�� 4 -- v-SVR
%%-t �˺������ͣ��˺�����������(Ĭ��2)
%�� 0 �C ���ԣ�u'v
%�� 1 �C ����ʽ��(r*u'v + coef0)^degree
%�� 2 �C RBF������exp(-r|u-v|^2)
%�� 3 �C sigmoid��tanh(r*u'v + coef0)
%%-g gama���˺����е�gamma��������(��Զ���ʽ/rbf/sigmoid�˺���)
%%-c cost���ͷ�ϵ��������C-SVC��e-SVR��v-SVR�Ĳ���(��ʧ����)(Ĭ��1)
%%-n nu������v-SVC��һ��SVM��v-SVR�Ĳ���(Ĭ��0.5)
%%-p p������e-SVR����ʧ����p��ֵ(Ĭ��0.1)
%%-d degree���˺����е�degree����(��Զ���ʽ�˺���)(Ĭ��3)
%%-wi weight�����õڼ���Ĳ���CΪweight*C(C-SVC�е�C)(Ĭ��1)
%%-v n:n-fold��������ģʽ��nΪfold�ĸ�����������ڵ���2
%% ����SVM����Ԥ��
Y_predict = predict(Mdl,X_test);
%% ����ͳ��ָ��mae��mse������ӡ���
mse = sum((Y_test-Y_predict).^2)./16;
mae = sum(abs(Y_test-Y_predict))/16;
disp( ['MAE = ', num2str( mae )] );
disp( ['MSE = ', num2str( mae )] );
%% �������
figure(1);
hold on;
plot(Y_test,'-o');
plot(Y_predict,'r-^');
legend('ԭʼֵ','SVMԤ��ֵ');
hold off;
title('ԭʼ���ݺ�SVMԤ�����ݶԱ�','FontSize',12);
xlabel('ʱ��/h','FontSize',12);
ylabel('����ֵ/W','FontSize',12);
grid on;
figure(2);
error = Y_predict - Y_test;
plot(error,'-d');
title('���ͼ','FontSize',12);
xlabel('ʱ��/h','FontSize',12);
ylabel('�����/W','FontSize',12);
grid on;