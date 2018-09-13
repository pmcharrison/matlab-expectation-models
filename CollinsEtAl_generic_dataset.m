% Peter Harrison - 11/8/2017
% This function is a substitute for CollinsEtAl_datasets that defines
% a generic dataset.

function dset = CollinsEtAl_generic_dataset(chord_onsets_until_target_sec) % e.g. 0:789.5:5526.5;

% Copyright (c) 2012-2013 The Regents of the University of California
% All Rights Reserved.

% This function sets a variable called dset, short for datasets, which
% contains category names, stimulus names, and other details about material
% used in seven tonal priming experiments. See the paper cited in the
% script CollinsEtAl_analysis for more details.

% Tom Collins, 2011.10.28

nd = 0;
dset = struct();

nd = nd+1;
dset(nd).id = 'generic_dataset';
dset(nd).description = 'Generic dataset.';
dset(nd).stimCategoryLabels = {'NA',};
dset(nd).stimCategoryLabelsShort = {'NA'};
dset(nd).stimCategoryMembership.NA = {'generic_stimulus'};
dset(nd).zeroMeanRTobs = 0;
dset(nd).event_onsets = chord_onsets_until_target_sec * 1000;

end
