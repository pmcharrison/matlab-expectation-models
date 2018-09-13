% Analyses a directory of sequences
function analyse_dataset(input_dir, analysis_output_path, params)
%% General setup
addpath(input_dir);

% Load IPEM toolbox
IPEMSetup

% Load JLMT
addpath('C:\Users\Peter\Documents\jlmt\')
jlmt_startup;

%% Analysis
analysis = struct();
analysis.input_files = dir(fullfile(input_dir, '*.wav'));
analysis.input_files = transpose({analysis.input_files.name});

N = length(analysis.input_files);
assert(N > 0);
analysis.leman2000 = NaN(N, 1);
analysis.collins2014 = NaN(N, 1);

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
    [analysis.leman2000(i), analysis.collins2014(i)] = ...
        analyse_sequence(analysis.input_files{i}, input_dir, ...
        params, jlmtpath);
    save_analysis(analysis, analysis_output_path);
    waitbar(i/N,h,sprintf('%i / %i stimuli analysed', i, N));
end
delete(h)
end

function save_analysis(analysis, analysis_output_path)
fileID = fopen(analysis_output_path,'w');
N = length(analysis.input_files);
assert(N > 0);
fprintf(fileID, 'input_file,leman_2000,collins_2014\r\n');
for i = 1:N 
    fprintf(fileID, '%s,%f,%f\r\n', ...
        analysis.input_files{i}, ...
        analysis.leman2000(i), ...
        analysis.collins2014(i));
end
fclose(fileID);
end
