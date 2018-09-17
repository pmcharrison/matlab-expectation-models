% Parameters
params = struct;
params.target_chord_index = 6; % 1-indexed
params.audio_leading_time_delay_sec = 0.051;
params.tempo = 60;
params.leman2000_local_decay_sec = 0.1;
params.leman2000_global_decay_sec = 1.5;
params.collins2014_use_closure = false;
   
input_dir = 'C:\Users\Peter\Documents\MATLAB\matlab-expectation-models\media\example-wav-file';
input_file = 'id=1_genre=classical_c-id=1009_e-id=75_ic_category_1.wav';

% [leman, collins, collins_detail] = analyse_sequence(input_file, input_dir, params, jlmtpath);

output_dir = 'C:\Users\Peter\Documents\MATLAB\temp';
if exist(output_dir, 'dir')
    rmdir(output_dir, 's')
end
mkdir output_dir

analyse_dataset(input_dir, output_dir, params);
