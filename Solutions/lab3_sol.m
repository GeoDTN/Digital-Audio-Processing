%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Digital Audio Processing %
%    Lab. 3 - Solutions    %
%   Tadewos Somano, 2014   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear

fs  = 44100;
l   = 10;
t   = 0:1/fs:l;

f0  = 440;

% Binaural beats

bl = sin(2*pi*f0*t);
br = sin(2*pi*f0*t + pi*t.^2);

b = [bl ; br]';

% Missing foundamental

h = 1:20;
w = 1./h;

m1 = w*sin(2*pi*120*h'*t);
m2 = w(3:end)*sin(2*pi*120*h(3:end)'*t);

% Shepard–Risset glissando

% Linear weighting
% w1 = fliplr(linspace(0,0.5,length(t)));
% w2 = fliplr(linspace(0.5,1,length(t)));
% w3 = fliplr(linspace(1,0.5,length(t)));
% w4 = fliplr(linspace(0.5,0,length(t)));

% Gaussian weighting
g=(gausswin(l*fs*2)-0.0439)/(max(gausswin(l*fs*2)-0.0439));
w1 = fliplr(g(1:end/2+1)'/2);
w2 = fliplr(g(1:end/2+1)'/2+0.5);
w3 = fliplr(g(end/2:end)'/2+0.5);
w4 = fliplr(g(end/2:end)'/2);

gliss = w1.*sin(2*pi*f0*t- pi*f0/(2*l)*t.^2) + w2.*sin(2*pi*2*f0*t- pi*f0/l*t.^2) + ...
    w3.*sin(2*pi*4*f0*t- pi*2*f0/l*t.^2) + w4.*sin(2*pi*8*f0*t- pi*4*f0/l*t.^2) ;

s=[gliss(1:end-1) gliss(1:end-1) gliss(1:end-1) gliss(1:end-1)];

