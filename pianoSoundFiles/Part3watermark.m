clc;
clear;
close all;
[y1,fs1]=audioread('ech15AfterButterworth.wav'); 

ech15 = which('ech15AfterButterworth.wav'); 
fileID1=fopen(ech15); 
header=fread(fileID1,40,'uint8'); 
data_size=fread(fileID1,1,'uint32');   
M=fread(fileID1,Inf,'uint16'); 

lsb=1;
text='Xu Qiping is happy in ISEP';
text_b=de2bi(double(text),8);
[m,n]=size(text_b);          
text_b1=reshape(text_b,m*n,1);
b_m=de2bi(m,10)';
b_n=de2bi(n,10)';
bin_len=length(text_b1);
M(1:10)=bitset(M(1:10),lsb,b_m(1:10));
M(11:20)=bitset(M(11:20),lsb,b_n(1:10));
M(21:20+bin_len)=bitset(M(21:20+bin_len),lsb,text_b(1:bin_len)');

fileID2=fopen('ech15AfterWatermark.wav','w');
fwrite(fileID2,header,'uint8');
fwrite(fileID2,data_size,'uint32');
fwrite(fileID2,M,'uint16');
fclose(fileID2);
disp('This audio has been watermarked');

[y2,fs2]=audioread('ech15AfterWatermark.wav');
ech15 = which('ech15AfterWatermark.wav');
fileID3=fopen(ech15); 
header=fread(fileID3,40,'uint8');
data_size=fread(fileID3,1,'uint32');
M=fread(fileID3,Inf,'uint16');
len_binary=zeros(20,1);
b_m=zeros(10,1);
b_n=zeros(10,1);
b_m(1:10)=bitget(M(1:10),lsb);
b_n(1:10)=bitget(M(11:20),lsb);
bin_len=bi2de(b_m')*bi2de(b_n');
text_dec=zeros(bin_len,1);
text_dec(1:bin_len)=bitget(M(21:20+bin_len),lsb);
text_dec_combine=reshape(text_dec,bin_len/8,8);
text_dec_output=bi2de(text_dec_combine);
txt=char(text_dec_output)';

disp('The watermark is : ')
disp(txt);






