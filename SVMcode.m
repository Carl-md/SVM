tic;
close all;
clear;
clc;
format compact;
%% ���ݵ���ȡ��Ԥ����
A = xlsread('GFSJy.xlsx','Sheet1','B2:N697');

% �������������ָ֤��(1990.12.19-2009.08.19)
% ������һ��4579*6��double�͵ľ���,ÿһ�б�ʾÿһ�����ָ֤��
% 6�зֱ��ʾ������ָ֤���Ŀ���ָ��,ָ�����ֵ,ָ�����ֵ,����ָ��,���ս�����,���ս��׶�.
load chapter14_sh.mat;

% ��ȡ����
[m,n] = size(sh);
ts = sh(2:m,1);
tsx = sh(1:m-1,:);

% ����ԭʼ��ָ֤����ÿ�տ�����
figure;
plot(ts,'LineWidth',2);
title('��ָ֤����ÿ�տ�����(1990.12.20-2009.08.19)','FontSize',12);
xlabel('����������(1990.12.19-2009.08.19)','FontSize',12);
ylabel('������','FontSize',12);
grid on;

% ����Ԥ����,��ԭʼ���ݽ��й�һ��
ts = ts';
tsx = tsx';

% mapminmaxΪmatlab�Դ���ӳ�亯��	
% ��ts���й�һ��
[TS,TSps] = mapminmax(ts,1,2);	

% ����ԭʼ��ָ֤����ÿ�տ�������һ�����ͼ��
figure;
plot(TS,'LineWidth',2);
title('ԭʼ��ָ֤����ÿ�տ�������һ�����ͼ��','FontSize',12);
xlabel('����������(1990.12.19-2009.08.19)','FontSize',12);
ylabel('��һ����Ŀ�����','FontSize',12);
grid on;
% ��TS����ת��,�Է���libsvm����������ݸ�ʽҪ��
TS = TS';

% mapminmaxΪmatlab�Դ���ӳ�亯��
% ��tsx���й�һ��
[TSX,TSXps] = mapminmax(tsx,1,2);	
% ��TSX����ת��,�Է���libsvm����������ݸ�ʽҪ��
TSX = TSX';

%% ѡ��ع�Ԥ�������ѵ�SVM����c&g

% ���Ƚ��д���ѡ��: 
[bestmse,bestc,bestg] = SVMcgForRegress(TS,TSX,-8,8,-8,8);

% ��ӡ����ѡ����
disp('��ӡ����ѡ����');
str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g',bestmse,bestc,bestg);
disp(str);

% ���ݴ���ѡ��Ľ��ͼ�ٽ��о�ϸѡ��: 
[bestmse,bestc,bestg] = SVMcgForRegress(TS,TSX,-4,4,-4,4,3,0.5,0.5,0.05);

% ��ӡ��ϸѡ����
disp('��ӡ��ϸѡ����');
str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g',bestmse,bestc,bestg);
disp(str);

%% ���ûع�Ԥ�������ѵĲ�������SVM����ѵ��
cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 3 -p 0.01'];
model = svmtrain(TS,TSX,cmd);

%% SVM����ع�Ԥ��
[predict,mse] = svmpredict(TS,TSX,model);
predict = mapminmax('reverse',predict',TSps);
predict = predict';

% ��ӡ�ع���
str = sprintf( '������� MSE = %g ���ϵ�� R = %g%%',mse(2),mse(3)*100);
disp(str);

%% �������
figure;
hold on;
plot(ts,'-o');
plot(predict,'r-^');
legend('ԭʼ����','�ع�Ԥ������');
hold off;
title('ԭʼ���ݺͻع�Ԥ�����ݶԱ�','FontSize',12);
xlabel('����������(1990.12.19-2009.08.19)','FontSize',12);
ylabel('������','FontSize',12);
grid on;

figure;
error = predict - ts';
plot(error,'rd');
title('���ͼ(predicted data - original data)','FontSize',12);
xlabel('����������(1990.12.19-2009.08.19)','FontSize',12);
ylabel('�����','FontSize',12);
grid on;

figure;
error = (predict - ts')./ts';
plot(error,'rd');
title('������ͼ(predicted data - original data)/original data','FontSize',12);
xlabel('����������(1990.12.19-2009.08.19)','FontSize',12);
ylabel('��������','FontSize',12);
grid on;
snapnow;
toc;