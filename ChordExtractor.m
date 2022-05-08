get_Chord('C.wav');

function f=get_Chord(file_path)
    [y,Fs]=audioread(file_path);
    disp(Fs)
    T=1/Fs;
    
    %Time/Pressure
    t=(0:size(y,1))*T;
    Y=y(:,1);
    subplot(2,1,1);
    
    plot(t(1,1:2000),Y(1:2000,1))
    ylabel('Amplitude')
    xlabel('Time')
    %disp(y(:,1))
    Z=fft(Y);
    
    NoteDomiant=abs(Z(1:2000,1));
    %disp(NoteDomiant(526))
    subplot(2,1,2);
    plot(NoteDomiant)
    ylabel('Amplitude')
    xlabel('Frequency')
    
    [~,locs] = findpeaks(NoteDomiant,'SortStr','descend','NPeaks',3);
    
    locs = sort(locs);
    [note_name,note_octave]=freq2note(locs(1));
    note1 = strcat(note_name,note_octave);

    [note_name,note_octave]=freq2note(locs(2));
    note2 = strcat(note_name,note_octave);

    [note_name,note_octave]=freq2note(locs(3));
    note3 = strcat(note_name,note_octave);

    disp(strcat(note1," ",note2," ",note3))



end

function [note_name_out,note_octave_out]=freq2note(frequency)
    % define constants that control the algorithm
    NOTES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"] ;
    OCTAVE_MULTIPLIER = 2;
    Note.KNOWN_NOTE_NAME="A";
    Note.KNOWN_NOTE_OCTAVE=4;
    Note.KNOWN_NOTE_FREQUENCY=440;

    % calculate the distance to the known note
    % since notes are spread evenly, going up a note will multiply by a constant
    % so we can use log to know how many times a frequency was multiplied to get from the known note to our note
    % this will give a positive integer value for notes higher than the known note, and a negative value for notes lower than it (and zero for the same note)

    note_multiplier = OCTAVE_MULTIPLIER.^(1/length(NOTES));
    frequency_relative_to_known_note = frequency ./ Note.KNOWN_NOTE_FREQUENCY;
    distance_from_known_note = log(frequency_relative_to_known_note)./log(note_multiplier);

    % round to make up for floating point inaccuracies
    distance_from_known_note = round(distance_from_known_note);
    known_note_index_in_octave = find(NOTES==Note.KNOWN_NOTE_NAME);
    known_note_absolute_index = Note.KNOWN_NOTE_OCTAVE .* length(NOTES) + known_note_index_in_octave;
    note_absolute_index = known_note_absolute_index + distance_from_known_note;
    note_octave = fix(note_absolute_index./length(NOTES));

    % using the distance in notes and the octave and name of the known note,
    % we can calculate the octave and name of our note
    % NOTE: the "absolute index" doesn't have any actual meaning, since it doesn't care what its zero point is. it is just useful for calculation
    note_index_in_octave = mod(note_absolute_index,length(NOTES));
    note_name = NOTES(note_index_in_octave);
    note_name_out = string(note_name);
    note_octave_out = string(note_octave);
    
end

