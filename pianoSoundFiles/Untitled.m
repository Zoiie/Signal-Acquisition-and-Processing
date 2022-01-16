clear;
clc;
[y,fs]=audioread('ech25.wav'); %将声音放于matlab中
info=audioinfo('ech25.wav'); %得到声音的格式、位数、频率等
%sound(y,fs);
T=1/fs; %采样时间
t=(0:length(y)-1)*T;%时间
f=(0:length(y)-1)*fs/length(y);
figure(1);
yz=y(:,1);%左声道
subplot(2,1,1);
plot(t,yz);%输入信号时域曲线
title('原始信号时域');
xlabel('时间');
ylabel('振幅');
subplot(2,1,2);
n=length(yz);%进行变换的点数
y1=fft(yz,n); %对n点进行傅里叶变换到频域
F=fs/length(yz); %谱分辨率，频谱间隔
subplot(212)
plot(f,abs(y1));%左声道频谱图
title('原始信号频谱');
xlabel('F(Hz)');
ylabel('H(jw)');
grid on