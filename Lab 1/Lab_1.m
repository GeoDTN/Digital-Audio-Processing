%Digital Audio Processing
%Lab 1

clear all;
close all;
clc;

if 1==0
%1 Matlab basics

%Download sounds at freesounds.org
[Y Fs Nbits]=wavread('flute.wav');  %read a .wav file
wavwrite(Y,Fs,'new.wav');   %writes a wav file
sound(Y,Fs,Nbits);   %plays the .wav file
soundsc(Y,Fs,Nbits,[-1 1]); %plays the scaled sound as loud as possible in the scale [-1 1]
end

if 1==0
%2 Basic tone and noise synthesis

Nbits=16;
fs=44100;
t=10;
N=fs*t; %number of samples according to time duration and sampling frequency

Y=rand(1,N)-0.5;
wavwrite(Y,fs,Nbits,'noise.wav');
sound(Y,fs,Nbits);

d=2;    %time (seconds)
N=fs*d;
t=linspace(0,d,N);  %creates the time vector from t=0 to t=d with N values in between
%t=0:1/fs:d

f0=440;
s=sin(2*pi*f0*t);
sound(s,fs);
end

if 1==0
%3 Beats

d=10;
fs=44100;
N=fs*d;
t=linspace(0,d,N);
f0=440;
f1=445; %|f1-f0|<=10Hz

s=sin(2*pi*f0*t)+sin(2*pi*f1*t);
s=s/max(s);     %normalize the sequence between -1 and 1 because it is required by the function sound, otherwise i have clip
sound(s,fs);

k=5;
s_sweep=0.5*(sin(2*pi*f0*t)+sin(2*pi*f0*t+pi*k*t.^3));
s_sweep=s_sweep/max(s_sweep);
sound(s_sweep,fs);
end

if 1==0
%4 Digital Filters

h=0.5*[1 -1];   %high pass impulse response

fs=44100;
t=5;
N=fs*t;
Y=rand(1,N)-0.5;    %to have the signal between -0.5 and 0.5
Y=Y/max(Y);     %normalize for sound, otherwise i could have used soundsc that performs autoscale

Yfiltered=conv(Y,h);
sound(Y,fs);
sound(Yfiltered,fs);

F=fdesign.lowpass('N,Fc',2,0.5);    %lowpass filter
H=design(F);    %best automatic construction

Ylowpass=filter(H,Y);
sound(Ylowpass,fs);

fvtool(h);  %visualize the filters frequency response
fvtool(H);
end