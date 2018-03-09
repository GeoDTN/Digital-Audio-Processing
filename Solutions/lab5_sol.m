%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Digital Audio Processing %
%    Lab. 5 - Solutions    %
%   Tadewos Somano, 2014   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clf

[song1 fs1]=wavread('lab5');

%% PCP parameters

% Reference frequency
fRef=440;

% decimation factor for multirate filter bank
d = 5;

% PCP window length and step for fs sampled signals
w1=501;
d1=250;

% PCP window length and step for fs/5 sampled signals
w2=ceil(w1/d);
d2=d1/d;

% PCP window length and step for fs/25 sampled signals
w3=ceil(w2/d);
d3=d2/d;

%% Filterbank parameters
% Sampling frequencies for multi-rate filter bank
fs2 = fs1/d;
fs3 = fs2/d;

% Q factor of band-pass filters
Q = 25;

% Passband ripple (dB)
PBr = 1;

% Stopband attenuation (dB)
SBa = 50;

% Band-pass filter order
O = 8;

%% Anti Aliasing filter
AA = fir1(1000,0.2);

% filter and decimate (new sampling freq. fs/5)
song_AA1=filter(AA,1,song1);
song2=song_AA1(1:5:end);

% filter and decimate again (new sampling freq. fs/25)
song_AA2=filter(AA,1,song2);
song3=song_AA2(1:5:end);

%% PCP sub-bands

% midi note numbers
M1 = 96:108;  % for sample rate=fs (22050 Hz)
M2 = 60:95;   % for sample rate=fs/5 (4410 Hz)
M3 = 21:59;   % for sample rate=fs/25 (882 Hz)

% Normalized center frequency of band-pass filters
nf1 = 2.^((M1-69)/12)*fRef/(fs1/2);
nf2 = 2.^((M2-69)/12)*fRef/(fs2/2);
nf3 = 2.^((M3-69)/12)*fRef/(fs3/2);

% Side bandwidth (BW/2) of band-pass filters
sbw1 = (nf1/Q)/2;
sbw2 = (nf2/Q)/2;
sbw3 = (nf3/Q)/2;

% memory allocation
S1=zeros(length(M1),length(song1));
S2=zeros(length(M2),length(song2));
S3=zeros(length(M3),length(song3));

%% Filter design and filtering

% For fs sampled signal...
S1d=zeros(length(M1),floor(length(S1(1,:))/d1));

for f=1:length(M1)
    % Filter design
    [B, A] = ellip(O/2,PBr,SBa,[nf1(f)-sbw1(f) nf1(f)+sbw1(f)]);
    F1(f)=dfilt.df2(B,A);
    % Filtering
    S1(f,:)=filtfilt(B,A,song1);
    % Downsampling
    for i=1:floor(length(S1(f,:))/d1-d1)
        start=(i-1)*d1+1;
        S1d(f,i)=sum(S1(f,start:start+w1).^2);
    end
end

% For fs/5 sampled signal...
S2d=zeros(length(M2),floor(length(S2(1,:))/d2));

for f=1:length(M2)
    % Filter design
    [B, A] = ellip(O/2,PBr,SBa,[nf2(f)-sbw2(f) nf2(f)+sbw2(f)]);
    %F2(f)=dfilt.df2(B,A);
    % Filtering
    S2(f,:)=filtfilt(B,A,song2);
    % Downsampling
    for i=1:floor(length(S2(f,:))/d2-d2)
        start=(i-1)*d2+1;
        S2d(f,i)=sum(S2(f,start:start+w2).^2);
    end
end

% For fs/25 sampled signal...
S3d=zeros(length(M3),floor(length(S3(1,:))/d3));

for f=1:length(M3)
    % Filter design
    [B, A] = ellip(O/2,PBr,SBa,[nf3(f)-sbw3(f) nf3(f)+sbw3(f)]);
    %F3(f)=dfilt.df2(B,A);
    % Filtering
    S3(f,:)=filtfilt(B,A,song3);
    % Downsampling
    for i=1:floor(length(S3(f,:))/d3-d3)
        start=(i-1)*d3+1;
        S3d(f,i)=sum(S3(f,start:start+w3).^2);
    end
end

%% STMPS Matrix (Before the octave folding summation)

STMPS=[25*S3d;5*S2d;S1d];

%% PCP Matrix

PCP = zeros(12,size(STMPS,2));

for c = 1:12
    PCP(c,:) = sum(STMPS(c:12:end,:));
end

PCP = circshift(PCP,-3);
maxs = max(PCP);
PCP = PCP./repmat(maxs,12,1);

% Plotting...
t = linspace(0, length(song1)/fs1, fs1/d1); % Time axis
n = 1:12; % Pitch Class
imagesc(t,n,PCP)
axis xy % Flip image
xlabel('Time (s)')
ylabel('Pitch Class')
title('PCP')
