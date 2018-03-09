%Digital Audio Processing
%Lab 4

clear all;
close all;
clc;

midi = readmidi('test.mid');
[Notes, endtime]=midiInfo(midi,0);

wlength=50e-3;   %milliseconds

notes=Notes(:,3);   %extract the notes from the midi file
frequencies=440*2.^((notes-69)/12); %convert the notes into frequencies

ends=Notes(:,6);
starts=Notes(:,5);

qends=round(Notes(:,6)/wlength)+1;  %to avoid index 0
qstarts=round(Notes(:,5)/wlength)+1;

endSlot=max(qends);
velocity=Notes(:,4);

%Create the piano roll and fill it
pianoRoll=zeros(length(notes),endSlot);
for i=1:length(notes)
   pianoRoll(notes(i),qstarts(i):qends(i))=velocity(i); 
end

imagesc(pianoRoll);
axis('xy');
colormap(flipud(hot));

%Create the big piano roll that has the length of the audio track
fs=44100;
twin=linspace(0,0.05,fs*0.05);
t=linspace(0,endSlot*0.05,fs*endSlot*0.05);
fin=window(@gausswin,(size(t)));
bigRoll=zeros(length(notes),endSlot*length(twin));
freqRoll=bigRoll;

for i=1:length(notes)
   aux=repmat(pianoRoll(i,:),length(twin),1);   %repeat vertically
   bigRoll(i,:)=reshape(aux,1,[]);  %stack horizontally
   
   s=sin(2*pi*440*2.^((i-69)/12)*twin);
   freqRoll(i,:)=repmat(s,1,endSlot);
   freqRoll(i,:)=freqRoll(i,:).*fin;
end

%st=find(bigRoll(i,:)~=0,1,'first');
%en=find(bigRoll(i,:)~=0,1,'last');
%f=window(@gausswin,en-st+1)';
%fin(st:en)=f;
%N.B.: the matrix freqRoll contains the frequencies!!!

%Construct the output matrix
out=zeros(size(t));
for i=1:length(notes)
   row=bigRoll(i,:).*freqRoll(i,:);
   out=out+row;
end

soundsc(out,fs);


