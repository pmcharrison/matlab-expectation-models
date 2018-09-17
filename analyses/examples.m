par = struct();
par.model = struct();

% Model parameters
par.model = struct();
par.model.leman_2000 = struct();
par.model.collins_2014 = struct();

par.model.leman_2000.local_decay_sec = 0.1;
par.model.leman_2000.global_decay_sec = 1.5;
par.model.collins_2014.use_closure = false;

% Dataset parameters
par.audio = struct();
par.audio.onsets = 0:7;
par.audio.offset = 1:8;
par.audio.dir = 'C:\Users\Peter\Documents\MATLAB\matlab-expectation-models\media\example-wav-file';

output_dir = 'C:\Users\Peter\Documents\MATLAB\temp';
if exist(output_dir, 'dir')
    rmdir(output_dir, 's')
end
mkdir output_dir

analyse_dataset(input_dir, output_dir, params);



% input_file = 'id=1_genre=classical_c-id=1009_e-id=75_ic_category_1.wav';
% [leman, collins, collins_detail] = analyse_sequence(input_file, input_dir, params, jlmtpath);