%加入白噪声的音频水印程序
clear;
kk.wave = wavread('E:\thrid1\back.wav');   %读入原始音频文件
y=kk.wave;
[c,l]=wavedec(y,3,'db4');               %三级小波分解
ca3=appcoef(c,l,'db4',3);
cd3=detcoef(c,l,3);
cd2=detcoef(c,l,2);
cd1=detcoef(c,l,1);
x=ca3;                              %提取低频系数
len=length(y);
x1=x;
s=max(abs(x))*0.2;
i=find(abs(x)>s);lx=length(x(i));         %找出大于最大值0.2倍的序列
figure;
subplot(2,2,1);
plot(ca3);                            %画出低频系数图
title('低频系数图形');
subplot(2,2,2);
plot(cd3);
title('cd3');
subplot(2,2,3);
plot(cd2);
axis([0 10e4 -0.5 0.5]);
title('cd2');
subplot(2,2,4);
plot(cd1);
title('cd1');
randn('seed',10);                      %产生随机高斯序列
mark=randn(1,lx);
ss=mark;
rr=ss*0.1;                           %设置水印嵌入强度
x(i)=x(i).*(1+2*rr');                   %嵌入水印
c1=[x',cd3',cd2',cd1'];
s1=waverec(c1,l,'db4');
file1='已加水印.wav';
dd=length(s1);                     %调整s1的长度,使之可以分成两列
s11=s1;                            %s1的值不能改变,因为后面还需要用到
if rem(dd,2)==1                    %如果s1是奇数,则去掉最后一个数,将新数组定义为s11
    s11=s1(1:dd-1);               
end
ee=reshape(s11,[],2);                %将s1调整成2列的数组
wavwrite(ee,file1);
figure;
subplot(3,1,1);plot(y);                   %画出原信号图
axis([0 18e4 -2 2]);
title('原信号的图');                    
subplot(3,1,2);plot(ss);
title('水印图');
subplot(3,1,3);plot(s1);                  %画出嵌入了水印的信号图
title('加入了水印的声音信号')
kk.wave = wavread('已加水印'); 
yc=kk.wave;
dy=length(y);
if rem(dy,2)==1                         %如果y为奇数,处理同s1,但是因为后面不需要用到y,所以不必定义一个新数组
    y=y(1:dd-1);
end
y1=reshape(y,[],2);                       %调整数组y的维数,使之可以和yc做运算
fz=sum(y1.*y1);                           %计算嵌入了水印的信号的信噪比,".*"用于实现对应元素的乘法
fm=sum((y1-yc).*(y1-yc));
SNR=-10*log(fm/fz)
yyy=randn(1,dd);                            %加入白噪声                          
b=sqrt(0.01); 
yyy=b*yyy; 
s1=s1+yyy;
if rem(length(s1),2)==1
    s1=s1(1:length(s1)-1);
end
ee=reshape(s1,[],2);
wavwrite(ee,file1);
kk.wave = wavread('已加水印');            %读入声音文件
yr=kk.wave;
[cr,lr]=wavedec(yr,3,'db4');
car3=appcoef(cr,lr,'db4',3);
cdr3=detcoef(cr,lr,3);
cdr2=detcoef(cr,lr,2);
cdr1=detcoef(cr,lr,1);
xr=car3;
figure;
rrr=((xr(i)./x1(i))-1)/2;
subplot(2,1,1);plot(rr);
title('原水印的图');
subplot(2,1,2);plot(rrr);
axis([0 1.8e3 -0.4 0.4]);
title('加入白噪声后提取水印的图');
whos('rrr');
figure;
rr1=reshape(rrr,1,lx);
syc=rr1-rr;
plot(syc);                                  %画出水印差别图
axis([0 1.8e3 -0.3 0.3]);
title('水印之差');
rrr=((xr(i)./x1(i))-1)/2;
d=length(rr);
x=0;
y=0;
z=0;
for i=1:d
        x=x+rr(i)*rrr(i);
        y=y+rr(i)^2;
        z=z+rrr(i)^2;
    end
p=x/((y^0.5)*(z^0.5))                         %计算相关度
