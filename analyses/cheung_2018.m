res = struct();

% Options
res.par = struct();
res.par.stimulus_dir = '/Users/peter/Dropbox/Academic/projects/entropy-surprisal/entropy_surprisal_fmri/input/final-experiment-stimuli';
res.par.pitch_dir = fullfile(res.par.stimulus_dir, 'pitches');
res.par.audio_dir = fullfile(res.par.stimulus_dir, 'audio');
res.par.output_file = fullfile(res.par.stimulus_dir, 'astm-analyses.mat');
res.par.n_stim = 30;
res.par.n_rhythm = 3;
res.par.use_closure = true;
res.par.leman_2000_local_decay_sec =  [0.1 0.1 0.1 0.5 0.5 0.5];
res.par.leman_2000_global_decay_sec = [1.5 2.5 4.0 1.5 2.5 4.0];

% Set up
IPEMSetup
addpath('C:\Users\Peter\Documents\jlmt\')
jlmt_startup;

bar = waitbar(0,...
    sprintf('0 / %i stimuli analysed', num_stimuli), ...
    'Name','Computing Leman/Collins analyses...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(bar,'canceling',0)

counter = 0;
num_analyses = res.par.n_stim * res.par.n_rhythm;
res.data = cell(num_analyses, 1);

for stim_id = 1:res.par.n_stim
    for rhythm_id = 1:res.par.n_rhythm
        if getappdata(bar, 'canceling')
            break
        end
        
        res_ij = struct();
        
        counter = counter + 1;
        res_ij.analysis_id = counter;
        
        res_ij.stim_id = stim_id;
        res_ij.rhythm_id = rhythm_id;
        
        res_ij.audio_file = sprintf('merged_wav_stim%02d_rhythm%02d.wav', ...
            res_ij.stim_id, res_ij.rhythm_id);
        res_ij.pitch_file = sprintf('pitches_merged_wav_stim%02d.txt', res_ij.stim_id);
        
        fid = fopen(fullfile(res.par.pitch_dir, res_ij.pitch_file));
        out = textscan(fid, '%d %f %f %f %f %f %f', ...
            'HeaderLines', 1);
        fclose(fid);
        
        res_ij.onsets = out{2};
        res_ij.ioi = mean(diff(res_ij.onsets));
        res_ij.offsets = res_ij.onsets + res_ij.ioi;
        
        res_ij.pitches = out(3:7);
        
        [res_ij.leman, res_ij.collins, res_ij.collins_detail] = analyse_sequence(...
            res_ij.audio_file, ...
            res.par.audio_dir, ...
            res_ij.onsets, ...
            res_ij.offsets, ...
            res.par.use_closure, ...
            res.par.leman_2000_local_decay_sec, ...
            res.par.leman_2000_global_decay_sec, ...
            jlmtpath);
        
        res{counter} = res_ij;
        
        save(res.par.output_file, res);
        
        waitbar(counter / num_analyses, bar, ...
            sprintf('%i / %i stimuli analysed', counter, num_analyses));
    end
end

