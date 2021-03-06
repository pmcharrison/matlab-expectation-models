% This function is a modified version of CollinsEtAl_analysis.m
% from the JLMT source code.

% Copyright (c) 2013 The Regents of the University of California
% All Rights Reserved.

% Refactoring and generalisation by Peter M. C. Harrison (Sep 2018)

function [pred, formatted_features] = collins_2014(...
    wav_file, wav_dir, ...
    onset, ... % in seconds
    use_closure, ... % whether or not to use the model that incorporates closure
    jlmtpath ...
    )
manage_files(wav_dir, wav_file, jlmtpath);
[params, in_data] = init_params(onset);
jlmt_out = jlmt_proc_series(in_data, params.jlmt);
features = CollinsEtAl_calc_attributes(in_data, params, jlmt_out);
[exp_vars2, alphaHat, betaHat] = get_coefs(use_closure);
x = get_feature_vector(in_data, features, exp_vars2);
pred = alphaHat + betaHat * x;
formatted_features = format_collins_features(features);
end

function  manage_files(wav_dir, wav_file, jlmtpath)
input_dataset_path = fullfile(jlmtpath, 'data', 'CollinsEtAl', 'generic_dataset');
if exist(input_dataset_path, 'dir')
    rmdir(input_dataset_path, 's');
end;
mkdir(input_dataset_path);
input_stimulus_path = fullfile(input_dataset_path, 'generic_stimulus');
if ~exist(input_stimulus_path, 'dir')
    mkdir(input_stimulus_path);
end;
input_audio_path = fullfile(input_stimulus_path, 'audio');
if ~exist(input_audio_path, 'dir')
    mkdir(input_audio_path);
end;
input_audio_file_path = fullfile(input_audio_path, 'generic_stimulus.wav');
addpath(input_dataset_path);
addpath(input_stimulus_path);
addpath(input_audio_path);
copyfile(fullfile(wav_dir, wav_file), ...
    input_audio_file_path, 'f');
end

function [params, in_data] = init_params(onset)
params = modified_collins_globals(struct, onset);
location = fullfile(params.paths.data_root, params.datasets(1).id);
params.paths.stim_root = location;
in_data = init_in_data(location);
end

function in_data = init_in_data(location)
in_data = ensemble_init_data_struct;
in_data.vars = {'path', 'filename', 'path_no_ext', 'name_no_ext'};
ic = set_var_col_const(in_data.vars);

in_data.data{ic.path} = {};
in_data.data{ic.filename} = {};
in_data.data{ic.path_no_ext} = {};
in_data.data{ic.name_no_ext} = {};

in_data.data{ic.path}(end+1) = {fullfile(location, 'generic_stimulus', 'audio');};
in_data.data{ic.filename}(end+1) = {'generic_stimulus.wav'};
in_data.data{ic.path_no_ext}(end+1) = {fullfile(location, 'generic_stimulus')};
in_data.data{ic.name_no_ext}(end+1) = {'generic_stimulus'};
end

function [exp_vars2, alphaHat, betaHat] = get_coefs(use_closure)
if use_closure
    [exp_vars2, alphaHat, betaHat] = coef_with_closure();
else
    [exp_vars2, alphaHat, betaHat] = coef_without_closure();
end
end

function [exp_vars2, alphaHat, betaHat] = coef_with_closure()
    exp_vars2 = {...
        'TS' [.1 4] 'MC' 'rel' [0 200] 7;...            % x_TS
        'TS' [.1 4] {'CL' 'hypo'} 'NA' [100 300] 25;... % p_clos
        'PP' [.1 4] 'MC' 'rel' [0 200] 3;...            % x_PP
        'PP' [.1 4] 'MC' 'abs' [201 600] 2;...          % z_PP
        'PP' 4 'MV' 'abs' [201 600] 14;...              % y_PP
        'CV' 4 'MV' 'abs' [0 200] 21};                  % y_CV
    % The commented column above is the label used in the paper. The last
    % column in the cell is for checking that the current results match a
    % previous analysis.
    % Coefficient values from equation (2).
    alphaHat = -57.370601599275098;
    betaHat = [-1.117975643676257e+02 -1.415175120627715e+04...
        -3.570081944978055e+02 2.258324648389623e+02 0.141210000049002...
        -3.444465129538324];
end

function [exp_vars2, alphaHat, betaHat] = coef_without_closure()
% Use equation 1, which doesn't incorporate closure
        exp_vars2 = {...
        'TS' [.1 4] 'MC' 'rel' [0 200] 7;...            % x_TS
        'PP' [.1 4] 'MC' 'rel' [0 200] 3;...            % x_PP
        'PP' 4 'MV' 'abs' [201 600] 14;...              % y_PP
        'CV' 4 'MV' 'abs' [0 200] 21};                  % y_CV
    % The commented column above is the label used in the paper. The last
    % column in the cell is for checking that the current results match a
    % previous analysis.
    
    % Coefficient values from equation (2).
    alphaHat = 110.77;
    betaHat = [-97.94 -245.20 0.13 -4.09];
end

function x = get_feature_vector(in_data, results, exp_vars2)
stim_names2 = in_data.data{4}';
nexp_vars = size(exp_vars2, 1);
nresults = size(results, 1);
x = zeros(nexp_vars, 1);
for ivar = 1:nexp_vars
    % Find the relevant row for this stimulus and variable combination.
    rel_row = [];
    irow = 2;
    while irow <= nresults
        % Test match on stimulus string.
        if strcmp(results{irow, 2}, stim_names2{1}) &&...
                ... % Test match on representational space.
                strcmp(results{irow, 3}, exp_vars2{ivar, 1}) &&...
                ... % Test match on time constants.
                sum(results{irow, 4} == exp_vars2{ivar, 2})...
                == size(exp_vars2{ivar, 2}, 2) &&...
                ... % Test match on calculation type.
                sum(strcmp(results{irow, 5}, exp_vars2{ivar, 3}))...
                == size(exp_vars2{ivar, 2}, 3) &&...
                ... % Test match on window comparison.
                strcmp(results{irow, 6}, exp_vars2{ivar, 4}) &&...
                ... % Test match on post-target window.
                sum(results{irow, 7} == exp_vars2{ivar, 5})...
                == size(exp_vars2{ivar, 5}, 2)
            rel_row = irow;
            irow = nresults;
        end
        irow=irow+1;
    end
    % Found the relevant row. Now assign the value to the variable.
    x(ivar) = results{rel_row, 8};
end
end