%close all
%clear command windows
CDIR=dir('pianoSoundFiles/*.wav');

YB_dir_cell=struct2cell(CDIR)' ;

file_name=YB_dir_cell(:,1);

Ngh=5000;
fnghber=size(file_name,1);

for N=1:1:fnghber
CFN=char(file_name(N,1));

CFN=strcat('pianoSoundFiles/',CFN);

[Y,Fs]=audioread(CFN,Ngh);

DATA_Y(N,:) = Y(:,1);

DATA_F(N,:) = Fs;

end

for N=1:1:fnghber
yy = fft(DATA_Y(N,:),Ngh);

FFT_Y(N,:) = 20*log10(abs(yy));

figure;

ff = linspace(0,DATA_F(N),Ngh);

plot(ff,FFT_Y(N,:),'r');

grid on;
axis([21 5001 -41 91]);

set(gcf,'Position',[1 1 700 300]);

tt = strcat(file_name(N,:),'-ÆµÆ×·ÖÎöÍ¼');
title(tt);

xlabel('Frequency£¨Hz£©','FontSize',9,'FontName');

ylabel('Amplitude£¨dB£©','FontSize',9,'FontName');

set(gca,'FontSize',9);

set(gcf,'visible','on');

tt=ngh2str(N);
saveas(gcf,tt,'emf');

end

function data_sjf = fft(data_sj,nnum,varargin)
if isempty(data_sj)
data_sjf = data_sj;
data_sjf.Domain = 'Frequency';
return
end
if nargin == 3
rnfeg = 1;
else
rnfeg = 0;
end
if nargin<2
nnum =[];
end
if isempty(nnum)
nnum = size(data_sj,'Num');
end
Nume = size(data_sj,'Nume');
if length(nnum)~=Nume
if length(nnum)==1
nnum = nnum*ones(1,Nume);
else
ctrlMsgUtils.error('Ident:dataprocess:fftLength')
end
end
if strcmpi(data_sj.Domain,'frequency')
ctrlMsgUtils.error('Ident:dataprocess:fftDataDomain')
end
y = data_sj.OutputData;
u = data_sj.InputData;
ts = data_sj.Ts;
for pkxe = 1:length(ts)
if isempty(ts{pkxe})
ctrlMsgUtils.error('Ident:dataprocess:fftSampling')
end
end
ss = data_sj.TimeUnit;
if isempty(ss), ss= 's';end
for pkxe = 1:length(y)
Num = nnum(pkxe);
if floor(Num)~=Num || Num<=0
ctrlMsgUtils.error('Ident:dataprocess:fftLength2')
end
Ts = ts{pkxe};
if isreal(data_sj) && ~rnfeg
if fix(Num/2)==Num/2
nnum1 = Num/2+1;
freq{pkxe} = (0:Num/2)'/Ts*2*pi/Num;
else
nnum1 = (Num+1)/2;
freq{pkxe} = (0:(Num-1)/2)'/Ts*2*pi/Num;
end
else
if fix(Num/2)==Num/2
freq{pkxe} = [(-Num/2+1:-1),(0:Num/2)]'/Ts*2*pi/Num;
else
freq{pkxe} = [(-(Num+1)/2+1:-1),(0:(Num-1)/2)]'/Ts*2*pi/Num;
end
end
Y1 = fft(y{pkxe},Num,1)/sqrt(min(Num));
U1 = fft(u{pkxe},Num,1)/sqrt(min(Num));
if length(y{pkxe})==1 || length(u{pkxe})==1
if isempty(Y1), Y1 = zeros(size(U1,1),0);end
if isempty(U1), U1 = zeros(size(Y1,1),0);end
end
if isreal(data_sj) && ~rnfeg
Y{pkxe}= Y1(1:nnum1,:);
U{pkxe}= U1(1:nnum1,:);
else
if fix(Num/2)==Num/2
Y{pkxe} = Y1([(Num/2+2:Num),1+(0:Num/2)],:);
U{pkxe} = U1([(Num/2+2:Num),1+(0:Num/2)],:);
else
Y{pkxe} = Y1([((Num+1)/2+1:Num),1+(0:(Num-1)/2)],:);
U{pkxe} = U1([((Num+1)/2+1:Num),1+(0:(Num-1)/2)],:);
end
end
unit{pkxe} = ['rad/',ss];
end
data_sjf = data_sj;
data_sjf.Name = '';
data_sjf.Notes = {};
data_sjf.UserData = [];
data_sjf.InputData = U;
data_sjf.OutputData = Y;
data_sjf.SamplingInstants = freq;
data_sjf.Domain = 'Frequency';
data_sjf.Tstart = unit;
data_sjf = timemark(data_sjf,'c');
function Y = fft(NX, n_um, N_dim)
if nargin < 3
N_dim = distributedutil.Sizes.firstNonSingletonDimension(size(NX));
else
N_dim = distributedutil.CodistParser.gatherIfCodistributed(N_dim);
end
if nargin < 2 || (nargin > 1 && isempty(n))
n_um = size(NX,N_dim);
else
n_um = distributedutil.CodistParser.gatherIfCodistributed(n_um);
end
if ~isa(NX, 'codistributed')
Y = fft(NX, n_um, N_dim);
return;
end
codistributed.pVerifyUsing1d('fft', NX);
xDist = getCodistributor(NX);
if xDist.Dimension ~= N_dim
localY = fft(getLocalPart(NX),n_um,N_dim);
sz = xDist.Cached.GlobalSize;
sz(N_dim) = n_um;
codistr = codistributor1d(xDist.Dimension, xDist.Partition, sz);
Y = codistributed.pDoBuildFromLocalPart(localY, codistr);
else
Y = dist_fft(NX,n_um,N_dim); %fft on codistributed data
end
function Y = dist_fft(NX,n_um,N_dim)
if N_dim == 1
Y = redistribute(NX,codistributor('1d', 2));
else
Y = redistribute(NX,codistributor('1d', N_dim-1));
end
Y = fft(Y,n_um,N_dim);
if size(NX,N_dim) == n_um
Y = redistribute(Y, getCodistributor(NX));
else
Y = redistribute(Y,codistributor('1d',N_dim));
end
end
end
end

