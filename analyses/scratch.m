% Parameters
params = struct;
params.target_chord_index = 6; % 1-indexed
params.audio_leading_time_delay_sec = 0.051;
params.tempo = 60;
params.leman2000_local_decay_sec = 0.1;
params.leman2000_global_decay_sec = 1.5;
params.collins2014_use_closure = false;

% input_dir = 'C:\Users\Peter\Documents\MATLAB\ex_stimuli\audio\wav';

% analyse_dataset(input_dir, ...
  %  'C:\Users\Peter\Documents\MATLAB\temp\ex_stimuli_analysis.csv', ...
   % params)
   
input_dir = 'C:\Users\Peter\Dropbox\Academic\projects\idyom\studies\HarmonyPerception\interface\www\stimuli\audio\wav';
analyse_dataset(input_dir, ...
    'C:\Users\Peter\Dropbox\Academic\projects\idyom\studies\HarmonyPerception\interface\www\stimuli\matlab_analysis.csv', ...
    params);