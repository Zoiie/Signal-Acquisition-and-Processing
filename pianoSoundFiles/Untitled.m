clear;
clc;
[y,fs]=audioread('ech25.wav'); %����������matlab��
info=audioinfo('ech25.wav'); %�õ������ĸ�ʽ��λ����Ƶ�ʵ�
%sound(y,fs);
T=1/fs; %����ʱ��
t=(0:length(y)-1)*T;%ʱ��
f=(0:length(y)-1)*fs/length(y);
figure(1);
yz=y(:,1);%������
subplot(2,1,1);
plot(t,yz);%�����ź�ʱ������
title('ԭʼ�ź�ʱ��');
xlabel('ʱ��');
ylabel('���');
subplot(2,1,2);
n=length(yz);%���б任�ĵ���
y1=fft(yz,n); %��n����и���Ҷ�任��Ƶ��
F=fs/length(yz); %�׷ֱ��ʣ�Ƶ�׼��
subplot(212)
plot(f,abs(y1));%������Ƶ��ͼ
title('ԭʼ�ź�Ƶ��');
xlabel('F(Hz)');
ylabel('H(jw)');
grid on