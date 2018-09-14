% Analyses a directory of sequences
function analyse_dataset(input_dir, output_dir, params)
%% General setup
addpath(input_dir);

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Load IPEM toolbox
IPEMSetup

% Load JLMT
addpath('C:\Users\Peter\Documents\jlmt\')
jlmt_startup;

%% Analysis
res = struct();
res.input_files = dir(fullfile(input_dir, '*.wav'));
res.input_files = transpose({res.input_files.name});

N = length(res.input_files);
assert(N > 0);
res.leman_2000 = NaN(N, 1);
res.collins_2014 = NaN(N, 1);
res.collins_2014_detail = cell(N, 1);

h = waitbar(0,...
    sprintf('0 / %i stimuli analysed', N), ...
    'Name','Computing Leman/Collins analyses...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

for i = 1:N 
    if getappdata(h,'canceling')
        break
    end
    [res.leman_2000(i), res.collins_2014(i), res.collins_2014_detail{i}] = ...
        analyse_sequence(res.input_files{i}, input_dir, ...
        params, jlmtpath);
    % save_analysis(res, analysis_output_path);
    waitbar(i/N,h,sprintf('%i / %i stimuli analysed', i, N));
end
delete(h)

save(fullfile(output_dir, 'res.mat'), 'res');
save(fullfile(output_dir, 'params.mat'), 'params');

save_csv_summary(fullfile(output_dir, 'res_summary.csv'), res);
save_csv_collins_detail(fullfile(output_dir, 'res_collins_detail.csv'), res);
end

function save_csv_summary(path, res)
con = fopen(path,'w');
N = length(res.input_files);
assert(N > 0);
fprintf(con, 'i,input_file,leman_2000,collins_2014\r\n');
for i = 1:N 
    fprintf(con, '%i,%s,%f,%f\r\n', ...
        i, ...
        res.input_files{i}, ...
        res.leman_2000(i), ...
        res.collins_2014(i));
end
fclose(con);
end

function save_csv_collins_detail(path, res)
con = fopen(path,'w');
N = length(res.input_files);
assert(N > 0);
fprintf(con, ['i,id,representation,time_constant_1,time_constant_2,' ...
    'calculation_type,window,' ...
    'post_target_window_begin,post_target_window_end,' ...
    'value\r\n']);
for i = 1:N
    x = res.collins_2014_detail{i};
    M = size(x.representation, 1);
    assert(M > 0);
    for j = 1:M
        fprintf(con, '%i,%s,%s,%d,%d,%s,%s,%d,%d,%d\r\n', ...
            i, ...
            res.input_files{i}, ...
            x.representation(j, :), ...
            x.time_constant_1(j), ...
            x.time_constant_2(j), ...
            char(x.calculation_type(j)), ...
            char(x.window(j)), ...
            x.post_target_window_begin(j), ...
            x.post_target_window_end(j), ...
            x.value(j));
    end
end
fclose(con);
end


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
