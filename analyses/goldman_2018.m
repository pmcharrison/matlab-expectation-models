p = struct();
% p.input_dir = 'C:\Users\Peter\Documents\MATLAB\matlab-expectation-models\media\example-wav-files';
p.input_dir = 'C:\Users\Peter\Dropbox\Academic\projects\harmony\HarmonyExpectancyEEG\input\stimuli\main\wav';
p.output_path = 'C:\Users\Peter\Dropbox\Academic\projects\harmony\HarmonyExpectancyEEG\input\models\astm.mat';
p.onsets = 0:7;
p.offsets = 1:8;
p.use_closure = true;
p.leman_2000_local_decay_sec =  [0.1 0.1 0.1 0.5 0.5 0.5];
p.leman_2000_global_decay_sec = [1.5 2.5 4.0 1.5 2.5 4.0];

analyse_dataset(...
    p.input_dir, ...
    p.output_path, ...
    p.onsets, ...
    p.offsets, ...
    p.use_closure, ...
    p.leman_2000_local_decay_sec, ...
    p.leman_2000_global_decay_sec);

