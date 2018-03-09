%Digital Audio Processing
%Lab 2

clear all;
close all;
clc;

if 1==0
%1 FFT

N=20;
n=0:N-1;

%signal
s=0.5.^n;

%frequency decimation
Sdeci=fft(s,10);

%frequency interpolation
Sinterp=fft(s,40);

%temporal zero-interleaving
szint=zeros(1,2*length(s));
szint(1:2:end)=s(1:end);
Szint=fft(szint);

%temporal interpolation
stinterp=interp(s,2);
Stinterp=fft(stinterp);

figure;
stem(n,s); xlabel('n'); ylabel('s[n]'); title('Sequence');

figure;
stem((0:length(Sdeci)-1)/length(Sdeci),abs(Sdeci)); xlabel('k'); ylabel('|X[k]|'); title('10-point FFT of s[n]');

figure;
stem((0:length(Sinterp)-1)/length(Sinterp),abs(Sinterp)); xlabel('k'); ylabel('|X[k]|'); title('40-point FFT of s[n]');

figure;
stem((0:length(Szint)-1)/length(Szint),abs(Szint)); xlabel('k'); ylabel('|X[k]|'); title('Temporal zero interleaving');

figure;
stem((0:length(Stinterp)-1)/length(Stinterp),abs(Stinterp)); xlabel('k'); ylabel('|X[k]|'); title('Temporal interpolation by a factor of 2');
end

if 1==0
%2 Filtering using DFT

[y fs]=wavread('shine.wav');

%time filtering
h=0.5*[1 -1];   %derivative FIR filter
timefilter=conv(y,h);

%frequency filtering
dftsize=length(y)+length(h)-1;  %to avoid aliasing
Y=fft(y,dftsize);
H=fft(h,dftsize).';
YFILTERED=Y.*H;
freqfilter=ifft(YFILTERED);

sound(y,fs);
sound(timefilter,fs);
sound(freqfilter,fs);

%N.B.: BE VERY CAREFUL!!! ' is the transpose complex conjugate!!!
%the non conjugate transpose is .'
end

if 1==0
%3 Sound Effect: simple echo

[y fs]=wavread('shine.wav');
n=0:length(y)-1;
%e=zeros(size(n))';

a=0.7;
m=0.2;    %time lag in seconds
tau=fs*m;

for t=0:4
    e(n==t*tau)=a^t;
end

dftsize=length(y)+length(e)-1;
echo=ifft(fft(y,dftsize).*fft(e,dftsize).');
echoconv=conv(y,e);

sound(echo,fs);
sound(echoconv,fs);
end

if 1==0
% Spectrogram: Short Time Fourier Transform
[y fs nbits]=wavread('shine.wav');

Lw=1024;
T=256;
N=1000;
X=zeros(N,length(y)/Lw);

m=1;
for i=1:floor(length(y)/(Lw-T))
   X(:,i)=fft(y(m:m+Lw),N);
   m=m+T;
end

Wm=window(@rectwin,Lw);
X1=spectrogram(y,Wm,T,N-1);

figure;
subplot(2,1,1); imagesc(20*log(abs(X))); shading('interp'); axis([0 length(y)/(Lw-T) 0 N/2]);
subplot(2,1,2); imagesc(20*log(abs(X1))); shading('interp');
end







