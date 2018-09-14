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
