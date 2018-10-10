% Analyses a directory of sequences
function analyse_dataset(...
    input_dir, ...
    output_path, ... % should end in .mat
    onsets, ...
    offsets, ...
    use_closure, ...
    leman_2000_local_decay_sec, ... % typically 0.1; may be vectorised
    leman_2000_global_decay_sec) ... % typically 1.5; may be vectorised

jlmtpath = setup(input_dir);
[res, num_stimuli] = init_res(input_dir);
% paths = get_paths(output_dir);
bar = init_progress_bar(num_stimuli);
% init_output_files(paths);

for i = 1:num_stimuli 
    if getappdata(bar, 'canceling')
        break
    end
    [leman_2000, collins_2014, collins_2014_detail] = ...
        analyse_sequence(...
        res.input_files{i}, ...
        input_dir, ...
        onsets, ...
        offsets, ...
        use_closure, ...
        leman_2000_local_decay_sec, ...
        leman_2000_global_decay_sec, ...
        jlmtpath, ...
        true);
    res.leman_2000{i} = {leman_2000};
    res.collins_2014{i} = {collins_2014};
    res.collins_2014_detail{i} = {collins_2014_detail};
    save_results(res, output_path, onsets, offsets, use_closure, ...
        leman_2000_local_decay_sec, leman_2000_global_decay_sec);
    update_progress_bar(i, num_stimuli, bar);
end
delete(bar);
% write_mat(res, params, output_dir);
end

function save_results(res, output_path, onsets, offsets, use_closure, ...
        leman_2000_local_decay_sec, leman_2000_global_decay_sec)
data = struct();
data.res = res;
data.params = struct();    
data.params.onsets = onsets;
data.params.offsets = offsets;
data.params.use_closure = use_closure;
data.params.leman_2000_local_decay_sec = leman_2000_local_decay_sec;
data.params.leman_2000_global_decay_sec = leman_2000_global_decay_sec;
save(output_path, 'data');
end

% function write_csv(res, i, paths)
% save_csv_summary(paths.csv.summary, res, i);
% save_csv_collins_detail(paths.csv.collins_detail, res, i);
% end
% 
% function write_mat(res, params, output_dir)
% save(fullfile(output_dir, 'res.mat'), 'res');
% save(fullfile(output_dir, 'params.mat'), 'params');
% end

function update_progress_bar(i, num_stimuli, bar)
waitbar(i / num_stimuli, bar, ...
    sprintf('%i / %i stimuli analysed', i, num_stimuli));
end

function jlmtpath = setup(input_dir)
addpath(input_dir);

% if ~exist(output_dir, 'dir')
%     mkdir(output_dir);
% end

% Load IPEM toolbox
IPEMSetup

% Load JLMT
addpath('C:\Users\Peter\Documents\jlmt\')
jlmt_startup;
end

function [res, num_stimuli] = init_res(input_dir)
res = struct();
res.input_files = dir(fullfile(input_dir, '*.wav'));
res.input_files = transpose({res.input_files.name});

num_stimuli = length(res.input_files);
assert(num_stimuli > 0);
res.leman_2000 = cell(num_stimuli, 1);
res.collins_2014 = cell(num_stimuli, 1);
res.collins_2014_detail = cell(num_stimuli, 1);
end

% function paths = get_paths(output_dir)
% paths = struct();
% paths.mat = struct();
% % paths.csv = struct();
% 
% paths.mat.summary = fullfile(output_dir, 'summary.mat');
% % paths.csv.summary = fullfile(output_dir, 'summary.csv');
% paths.mat.collins_detail = fullfile(output_dir, 'collins_detail.mat');
% % paths.csv.collins_detail = fullfile(output_dir, 'collins_detail.csv');
% end

function h = init_progress_bar(num_stimuli)
h = waitbar(0,...
    sprintf('0 / %i stimuli analysed', num_stimuli), ...
    'Name','Computing Leman/Collins analyses...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)
end

% function init_output_files(paths)
% begin_csv_summary(paths.csv.summary);
% begin_csv_collins_detail(paths.csv.collins_detail);
% end

% function begin_csv_summary(path)
% mode = 'w';
% con = fopen(path, mode);
% fprintf(con, 'i,input_file,leman_2000,collins_2014\r\n');
% end

% Saves the ith row of res to CSV
% function save_csv_summary(path, res, i)
% mode = 'a';
% con = fopen(path, mode);
% fprintf(con, '%i,%s,%f,%f\r\n', ...
%     i, ...
%     res.input_files{i}, ...
%     res.leman_2000(i), ...
%     res.collins_2014(i));
% fclose(con);
% end

% function begin_csv_collins_detail(path)
% mode = 'w';
% con = fopen(path, mode);
% fprintf(con, ['i,id,representation,time_constant_1,time_constant_2,' ...
%     'calculation_type,window,' ...
%     'post_target_window_begin,post_target_window_end,' ...
%     'value\r\n']);
% end

% function save_csv_collins_detail(path, res, i, begin)
% mode = 'a';
% con = fopen(path, mode);
% x = res.collins_2014_detail{i};
% M = size(x.representation, 1);
% assert(M > 0);
% for j = 1:M
%     fprintf(con, '%i,%s,%s,%d,%d,%s,%s,%d,%d,%d\r\n', ...
%         i, ...
%         res.input_files{i}, ...
%         x.representation(j, :), ...
%         x.time_constant_1(j), ...
%         x.time_constant_2(j), ...
%         char(x.calculation_type(j)), ...
%         char(x.window(j)), ...
%         x.post_target_window_begin(j), ...
%         x.post_target_window_end(j), ...
%         x.value(j));
% end
% fclose(con);
% end


% function save_analysis(res, analysis_output_path)
% fileID = fopen(analysis_output_path,'w');
% N = length(res.input_files);
% assert(N > 0);
% fprintf(fileID, 'input_file,leman_2000,collins_2014\r\n');
% for i = 1:N 
%     fprintf(fileID, '%s,%f,%f\r\n', ...
%         res.input_files{i}, ...
%         res.leman_2000(i), ...
%         res.collins_2014(i));
% end
% fclose(fileID);
% end
