%�������������Ƶˮӡ����
clear;
kk.wave = wavread('E:\thrid1\back.wav');   %����ԭʼ��Ƶ�ļ�
y=kk.wave;
[c,l]=wavedec(y,3,'db4');               %����С���ֽ�
ca3=appcoef(c,l,'db4',3);
cd3=detcoef(c,l,3);
cd2=detcoef(c,l,2);
cd1=detcoef(c,l,1);
x=ca3;                              %��ȡ��Ƶϵ��
len=length(y);
x1=x;
s=max(abs(x))*0.2;
i=find(abs(x)>s);lx=length(x(i));         %�ҳ��������ֵ0.2��������
figure;
subplot(2,2,1);
plot(ca3);                            %������Ƶϵ��ͼ
title('��Ƶϵ��ͼ��');
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
randn('seed',10);                      %���������˹����
mark=randn(1,lx);
ss=mark;
rr=ss*0.1;                           %����ˮӡǶ��ǿ��
x(i)=x(i).*(1+2*rr');                   %Ƕ��ˮӡ
c1=[x',cd3',cd2',cd1'];
s1=waverec(c1,l,'db4');
file1='�Ѽ�ˮӡ.wav';
dd=length(s1);                     %����s1�ĳ���,ʹ֮���Էֳ�����
s11=s1;                            %s1��ֵ���ܸı�,��Ϊ���滹��Ҫ�õ�
if rem(dd,2)==1                    %���s1������,��ȥ�����һ����,�������鶨��Ϊs11
    s11=s1(1:dd-1);               
end
ee=reshape(s11,[],2);                %��s1������2�е�����
wavwrite(ee,file1);
figure;
subplot(3,1,1);plot(y);                   %����ԭ�ź�ͼ
axis([0 18e4 -2 2]);
title('ԭ�źŵ�ͼ');                    
subplot(3,1,2);plot(ss);
title('ˮӡͼ');
subplot(3,1,3);plot(s1);                  %����Ƕ����ˮӡ���ź�ͼ
title('������ˮӡ�������ź�')
kk.wave = wavread('�Ѽ�ˮӡ'); 
yc=kk.wave;
dy=length(y);
if rem(dy,2)==1                         %���yΪ����,����ͬs1,������Ϊ���治��Ҫ�õ�y,���Բ��ض���һ��������
    y=y(1:dd-1);
end
y1=reshape(y,[],2);                       %��������y��ά��,ʹ֮���Ժ�yc������
fz=sum(y1.*y1);                           %����Ƕ����ˮӡ���źŵ������,".*"����ʵ�ֶ�ӦԪ�صĳ˷�
fm=sum((y1-yc).*(y1-yc));
SNR=-10*log(fm/fz)
yyy=randn(1,dd);                            %���������                          
b=sqrt(0.01); 
yyy=b*yyy; 
s1=s1+yyy;
if rem(length(s1),2)==1
    s1=s1(1:length(s1)-1);
end
ee=reshape(s1,[],2);
wavwrite(ee,file1);
kk.wave = wavread('�Ѽ�ˮӡ');            %���������ļ�
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
title('ԭˮӡ��ͼ');
subplot(2,1,2);plot(rrr);
axis([0 1.8e3 -0.4 0.4]);
title('�������������ȡˮӡ��ͼ');
whos('rrr');
figure;
rr1=reshape(rrr,1,lx);
syc=rr1-rr;
plot(syc);                                  %����ˮӡ���ͼ
axis([0 1.8e3 -0.3 0.3]);
title('ˮӡ֮��');
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
p=x/((y^0.5)*(z^0.5))                         %������ض�
