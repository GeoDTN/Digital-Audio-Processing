%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Digital Audio Processing %
%    Lab. 2 - Solutions    %
%   Alessio Degani, 2014   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clf
clear

fs  = 44100;
l   = 10;
t1  = 0:1/fs:l;

l2  = 20;
t2  = 1:l2;

% Unilat. exponential
s1 = 0.5.^t2;

%%
fft1=fft(s1);
abs_fft1=abs(fft1);
f1=linspace(0,1,l2);

% frequency decimation
fft2=abs(fft(s1,l2/2));
abs_fft2=abs(fft2);
f2=linspace(0,1,l2/2);

% frequency interpolation
fft3=abs(fft(s1,2*l2));
abs_fft3=abs(fft3);
f3=linspace(0,1,l2*2);

%zero interleaving
my_zeros = zeros(1, length(s1));
s1z = matintrlv([s1  my_zeros],2,length(s1));
fft1z=fft(s1z);
abs_fft1z=abs(fft1z);
f1z=linspace(0,1,l2*2);

%interpolation
s1i = interp(s1z,2);
fft1i=fft(s1i,l2);
abs_fft1i=abs(fft1i);
f1i=linspace(0,1,l2);

% plot(f1,abs_fft1,'r');
% hold
% plot(f2,abs_fft2,'b');
% plot(f3,abs_fft3,'g');
% plot(f1z,abs_fft1z,'k');
% plot(f1i,abs_fft1i,'c');
% grid
%%
% 2 seconds @ 44.1 kHz random signal
%s2=rand(1,fs*2)*2-1;
[shine fs]=wavread('shine');

% filter response (Derivative -> High Pass)
filter=[1 -1]/2;
%filter=filter/sqrt(sum(filter.^2));

% direct filtering (convolution in time domain)
s2fd=conv(shine,filter);

% indirect filtering (using fft)
lsh=length(shine)+length(filter)-1;
% WARNING: lsh, used as legnth of fft(), in MATLAB makes automatic
% zeropadding if Nfft > lenght(signal)!
s2fi=ifft(fft(shine',lsh).*fft(filter,lsh))';

%%  echo indirect
e=zeros(1,floor(1.1*fs));
e(1)=1;
e(round(0.2*fs))=0.8;
e(round(0.4*fs))=0.5;
e(round(0.8*fs))=0.3;
e(round(1*fs))=0.1;
e=e/sqrt(sum(e.^2));
lsh=length(shine)+length(e)-1;
secho=ifft(fft(shine',lsh).*fft(e,lsh));

%% STFT

lwnd=1024;
olap=0.75;
lhop=lwnd*olap;

stft=zeros(lwnd/2,floor(length(shine)/lwnd));

for f=0:floor(length(shine)/lwnd)-1
    start=(f*lhop)+1;
    stop=((f+1)*lwnd);
    buff=shine(start:stop);
    tmp=20*log10(abs(fft(buff,lwnd)));
    stft(:,f+1)=tmp(1:end/2);
end

imagesc(stft)
axis xy