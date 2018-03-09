%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Digital Audio Processing %
%    Lab. 1 - Solutions    %
%   Tadewos Somano, 2014   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;

% Sampling frequency
fs = 44100;

% Time base
t = 0:1/fs:10;

% Noise
n = rand(1, length(t));

% Pure 440 Hz Tone
s = sin(2*pi*440*t);

% Beats
b = 0.5*( sin(2*pi*440*t) + sin(2*pi*445*t) );

% Beats + sweep
b2 = 0.5*( sin(2*pi*440*t) + sin(2*pi*440*t + pi*t.^3) );

% High-pass filter
f1 = (1/2)*[-1 1];
n1 = conv(n,f1);

% Low-pass filter
d=fdesign.lowpass('N,Fc',2,.5);
%designmethods(d)
f2 = design(d);
n2 = filter(f2,n);

% Visualize the filter response
fvtool(f1)
fvtool(f2)


