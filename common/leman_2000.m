function res = leman_2000(...
    wav_file, ...
    wav_dir, ...
    onsets, ...
    offsets, ...
    local_decay_sec, ... % typically 0.1 
    global_decay_sec) % typically 1.5
    
%% Run the IPEM analysis
% Read sound file
[s,fs] = IPEMReadSoundFile(wav_file, wav_dir);
% Convert to mono
s = (s(1,:) + s(2,:)) / 2;
% Get stimulus length
audio_length_sec = length(s) / fs;
% Calculate the auditory nerve image
[ANI,ANIFreq,ANIFilterFreqs] = IPEMCalcANI(s,fs);
% Calculate the periodicity-pitch image
[PP,PPFreq,PPPeriods,PPFANI] = IPEMPeriodicityPitch(ANI,ANIFreq);
% Calculate the contextuality index
[~,~,~,~,LocalGlobalComparison] = ... 
    IPEMContextualityIndex(PP,PPFreq,PPPeriods,[],local_decay_sec,global_decay_sec,[],0);
% Calculate fit ratings for each onset and offset
assert(isequal(size(onsets), size(offsets)));
assert(size(onsets, 1) == 1);
res = arrayfun(@(onset, offset) extract_cor(...
    onset, offset, audio_length_sec, LocalGlobalComparison), ...
    onsets, offsets);
end

function cor = extract_cor(...
    onset, offset, audio_length, ... % in seconds
    LocalGlobalComparison ...
)
% Express target onset/offset as a fraction of the stimulus length
onset_frac = onset / audio_length;
offset_frac = offset / audio_length;
% Extract the contextuality index for the target chord
L = length(LocalGlobalComparison);
onset_index = min(max(round(L * onset_frac), 1), L);
offset_index = min(max(round(L * offset_frac), 1), L);
cor_seq = LocalGlobalComparison(onset_index:offset_index);
% Get the fit rating
cor = mean(cor_seq);
end