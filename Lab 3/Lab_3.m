%Digital Audio Processing
%Lab 3

clear all;
close all;
clc;

if 1==0
%Pure tones masked by narrow-band noise

[x fs] = wavread('track_10.wav');
sound(x,fs);
end

if 1==0
% Beats reloaded: Binaural Beats

fs=44100;
f0=440;
t=0:1/fs:10;

bl=sin(2*pi*f0*t);
br=sin(2*pi*f0*t+pi*t.^2);

b=[bl; br]';
sound(b,fs)
end

if 1==0
%Virtual Pitch: Missing Fundamental

fs=44100;
f0=120;
t=0:1/fs:5;
c1=zeros(size(t));

for i=1:20
   c1=c1+1/i*sin(2*pi*i*f0*t);
end
c1=c1/max(c1);

sound(c1,fs);

c2=zeros(size(t));
for i=3:20
   c2=c2+1/i*sin(2*pi*i*f0*t);
end
c2=c2/max(c2);

sound(c2,fs);
end

if 1==0
%The Endless Fall: Sheperd-Risset glissando

[x f] = wavread('shepard.wav');
y = wavread('rising_melody.wav');
z = wavread('echoes.wav');
%sound(y,f);

fs=44100;
l=5;
t=linspace(0,l,fs*l);
f0=440;

s=zeros(size(t));
%these coefficients represents a triangle that modulates the amplitude of
%the sound signal (try with a gaussian!)
a0=linspace(0.5,0,fs*l);
a1=linspace(1,0.5,fs*l);
a2=linspace(0.5,1,fs*l);
a3=linspace(0,0.5,fs*l);
a=[a0; a1; a2; a3];

for i=0:3
   s=s+a(i+1,:).*sin(2*pi*2^i*f0*t-pi*(2^(i-1)*f0)/l*t.^2); 
end

shepard=[s(1:end-1) s(1:end-1)];
sound(shepard,fs);
end

