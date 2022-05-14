get_Chord('A_maj_4_0.wav',[]);

%read_from_recording()
function read_from_recording()
    recorder=audiorecorder(44100,16,1,-1);
    disp('start speaking')
    recordblocking(recorder,1);
    disp('stop speaking');
    
    play(recorder)
    
    y=getaudiodata(recorder);
    
    get_Chord('',y)
end

function f=get_Chord(file_path,yr)
    if file_path == "" && ~isempty(yr)
        y=yr;
        Fs=44100;

    else
        [y,Fs]=audioread(file_path);
    end
    %disp(Fs)
    T=1/Fs;
    
    %Time/Pressure
    disp(size(y,1))
    t=(1:size(y,1))*T;
    Y=y(:,1);
    
    %plot time domain signal
    subplot(2,1,1);
    plot(t,Y)
    ylabel('Amplitude')
    xlabel('Time')
    
    Z=fft(Y);
    
    NoteDomiant=abs(Z);
    %disp(size(NoteDomiant))
    frequency =linspace(0,Fs,size(NoteDomiant,1));
    %disp(size(frequency))
    num_frequency_bins = int16(size(frequency,2)*0.01);
    %disp(num_frequency_bins)
    subplot(2,1,2);
    plot(frequency(1:num_frequency_bins),NoteDomiant(1:num_frequency_bins))
    ylabel('Magnitude')
    xlabel('Frequency')

    
    [~,locs] = findpeaks(NoteDomiant(1:num_frequency_bins),'SortStr','descend','NPeaks',3);
    
    locs = sort(locs);
    
    [note_name1,note_octave1]=freq2note(locs(1));
    note1 = strcat(note_name1,"_",note_octave1);

    [note_name2,note_octave2]=freq2note(locs(2));
    note2 = strcat(note_name2,"_",note_octave2);

    [note_name3,note_octave3]=freq2note(locs(3));
    note3 = strcat(note_name3,"_",note_octave3);

    disp(strcat(note1," ",note2," ",note3))



end
function Chord=noteTOChord(note_name1,note_name2,note_name3)
    T = readtable('triads.csv');



    
end

function frequency=note2freq(note)
    frequency = power((note-49)/12,2)*220;
end
function [note_name_out,note_octave_out]=freq2note(freq)
     NoteMap=containers.Map('KeyType','uint32','ValueType','char');
     NoteMap(0)='A';NoteMap(1)='A#';NoteMap(2)='B';NoteMap(3)='C';NoteMap(4)='C#';NoteMap(5)='D';NoteMap(6)='D#';NoteMap(7)='E';NoteMap(8)='F';NoteMap(9)='F#';NoteMap(10)='G';NoteMap(11)='G#';
     NOTES =  NoteMap;%["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] ;
     
     note_number = 12 * log2(freq / 220) + 49  ;
     note_number = round(note_number);
     
    

     note = mod((note_number - 1 ),length(NOTES));
     note = NOTES(note);
    
     octave = fix((note_number + 8 )/length(NOTES)); 
     note_name_out=string(note);
     note_octave_out=string(octave);
     
end
