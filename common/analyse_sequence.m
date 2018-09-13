function [leman, collins, collins_detail] = analyse_sequence(...
    input_wav_file_name, input_wav_dir, params, jlmtpath)
leman = leman_2000(input_wav_file_name, input_wav_dir, ...
    params.target_chord_index, params.audio_leading_time_delay_sec, ...
    params.tempo, params.leman2000_local_decay_sec, ...
    params.leman2000_global_decay_sec);
[collins, collins_detail] = collins_2014(input_wav_file_name, input_wav_dir, ...
    params.target_chord_index, params.audio_leading_time_delay_sec, ...
    params.tempo, jlmtpath, params.collins2014_use_closure);
end