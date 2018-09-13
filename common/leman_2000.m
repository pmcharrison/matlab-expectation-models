function target_local_global_cor = leman_2000(input_wav_file_name, input_wav_dir, ...
    target_chord_index, ... % 1-indexed
    audio_leading_time_delay_sec, ... 
    tempo, ...
    local_decay_sec, ... % typically 0.1 
    global_decay_sec) % typically 1.5

ioi = 60 / tempo;
target_onset_sec = audio_leading_time_delay_sec + ...
    (target_chord_index - 1) * ioi;
target_offset_sec = audio_leading_time_delay_sec + ...
    (target_chord_index) * ioi;
    

%% Run the IPEM analysis
% Read sound file
[s,fs] = IPEMReadSoundFile(input_wav_file_name, input_wav_dir);
% Convert to mono
s = (s(1,:) + s(2,:)) / 2;
% Get stimulus length
audio_length_sec = length(s) / fs;
% Express target onset/offset as a fraction of the stimulus length
target_onset_frac = target_onset_sec / audio_length_sec;
target_offset_frac = target_offset_sec / audio_length_sec;
% Calculate the auditory nerve image
[ANI,ANIFreq,ANIFilterFreqs] = IPEMCalcANI(s,fs);
% Calculate the periodicity-pitch image
[PP,PPFreq,PPPeriods,PPFANI] = IPEMPeriodicityPitch(ANI,ANIFreq);
% Calculate the contextuality index
[~,~,~,~,LocalGlobalComparison] = ... 
    IPEMContextualityIndex(PP,PPFreq,PPPeriods,[],local_decay_sec,global_decay_sec,[],0);
% Extract the contextuality index for the target chord
contextuality_vector_length = length(LocalGlobalComparison);
contextuality_onset_index = round(contextuality_vector_length * target_onset_frac);
contextuality_offset_index = round(contextuality_vector_length * target_offset_frac);
contextuality_target = LocalGlobalComparison(contextuality_onset_index:contextuality_offset_index);
% Get the fit rating
target_local_global_cor = mean(contextuality_target);
end