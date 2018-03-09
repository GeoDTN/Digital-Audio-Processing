%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Digital Audio Processing %
%    Lab. 4 - Solutions    %
%   Alessio Degani, 2014   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read the MIDI file
midi = readmidi('test.mid');

% Create the notes matrix
[Notes, endtime] = midiInfo(midi,0);
% The rows of the notes matrix are the different notes
% The columns are:
    % 1.track number
    % 2.channel number
    % 3.note number (midi encoding of pitch)
    % 4.velocity ( 0 - 127 )
    % 5.start time (seconds)
    % 6.end time (seconds)
    % 7.message number of note_on   #IGNORE IT
    % 8.message number of note_off  #IGNORE IT

[ rows, cols ] = size( Notes );
    
%% Piano-Roll

% MIDI note scale, from 21 (A0) to 108 (C8)
MIDIscale   = 21:108;
% Resolution of the Piano-Roll (1 frame = 50 mSec)
hop         = .0050;
pLen        = floor( endtime/hop );
pianoRoll   = zeros( length(MIDIscale), pLen );

for r = 1:rows
    % Each row is a note
    
    % Start and end index in frames
    endIdx  = round( Notes(r,6)/hop ) + 1;
    startIdx= round( Notes(r,5)/hop ) + 1;
    % Note index with respect to the MIDIscale
    noteIdx = Notes(r,3) - ( MIDIscale(1)-1 );
    % Note amplitude
    amp     = Notes(r,4);
    pianoRoll(noteIdx, startIdx:endIdx) = amp;
end

% Plot the Piano Roll
imagesc( (1:pLen)*hop, MIDIscale, pianoRoll ); title( 'Piano Roll' );
%axis( 'xy' ); colormap( flipud(gray) ); colorbar;
axis( 'xy' ); colormap( flipud(hot) );
xlabel( 'Time (S)' ); ylabel( 'MIDI note' );

%% Synthesize the MIDI file using sinusoids
fs  = 44100;
t   = 0:1/fs:endtime;
s   = zeros( 1, length(t) );

for r = 1:rows
    % Each row is a note

    % Note frequency from MIDI number
    freq    = 440*2.^( ( Notes(r,3)-69 )/12 );

    % Amplitude of the note
    amp     = Notes(r,4) / 127;

    % Start and end index in samples
    endIdx  = round( Notes(r,6)*fs ) + 1;
    startIdx= round( Notes(r,5)*fs ) + 1;

    % Calculating "soft" envelop, soft attack-release time in order to
    % avoid clicks in note on/off transitions

    % Attack and Release Time = 45 mSec (used in samples)
    AR      = round( .0045*fs ); 
    env     = ones( 1, endIdx-startIdx + 1 );
    % env goes to 1 in 45 milli-seconds ...
    env(1:AR)=linspace(0,1,AR);
    % ... and goes back to 0 in 45 milli-seconds after the "sustain"
    % phase
    env(end-AR+1:end)=linspace(1,0,AR);

    % Add the current note with its amplitude at the correct time
    % instant
    s( startIdx:endIdx ) = s( startIdx:endIdx ) + amp * env.*cos( 2*pi*freq*t(startIdx:endIdx) );
end

% Normalize the song volume
s = 0.8 * s/max(s);

% Play the MIDI song
sound(s,fs);

