% Parameters
params = struct;
params.target_chord_index = 6; % 1-indexed
params.audio_leading_time_delay_sec = 0.051;
params.tempo = 60;
params.leman2000_local_decay_sec = 0.1;
params.leman2000_global_decay_sec = 1.5;
params.collins2014_use_closure = false;
   
input_dir = 'C:\Users\Peter\Documents\MATLAB\archive\ex_stimuli\audio\wav';
input_file = 'id=1_genre=classical_c-id=1009_e-id=75_ic_category_1.wav';

[leman, collins, collins_detail] = analyse_sequence(input_file, input_dir, params, jlmtpath);

input_dir = 'C:\Users\Peter\Dropbox\Academic\projects\idyom\studies\HarmonyPerception\interface\www\stimuli\audio\wav';
analyse_dataset(input_dir, ...
    'C:\Users\Peter\Dropbox\Academic\projects\idyom\studies\HarmonyPerception\interface\www\stimuli\matlab_analysis.csv', ...
    params);