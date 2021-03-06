function [icaweights, icasphere, icawinv] = ApplyIcaToGlmInput(results)

% Finds ICs for the data used as input to a given GLM (the 'relevant' data)
%
% [icaweights, icasphere, icawinv] = ApplyIcaToGlmInput(results)
%
% INPUTS:
% -results is a struct of GLM results saved by RunGlmGui or RunGlmLikeGui.
%  It must have fields EEG, regressor_events, iLevel, influence,
%  artifact_events, and stddev.
%
% OUTPUTS:
% -icaweights, icasphere, and icawinv are equivalent to the EEGLAB struct
%  fields of the same names when you run ica from the eeglab gui.
%
% NOTES:
% -options on the type of ica and the pre-processing done can be modified
% in the code.
%
% Created 2/1/13 by DJ.
% Updated 3/22/13 by DJ - include artifact influence, use GetGlmRegressors_v2p0
% Updated 4/22/13 by DJ - fixed rejectepoch default

% Parse input
EEG = results.EEG;
event_types = results.regressor_events{results.iLevel};
event_influence_ms = results.influence;
artifact_types = results.artifact_events;
if isfield(results,'artifact_influence')
    artifact_influence_ms = results.artifact_influence;
else
    artifact_influence_ms = results.influence;
end
stddev = results.stddev;

%% GLM Section (pasted from RunEegGlm.m)

% Reshape data, if necessary
reshapeddata = reshape(EEG.data,size(EEG.data,1),size(EEG.data,2)*size(EEG.data,3));

% Find constants
dt = 1000/EEG.srate;
regressor_range = round(event_influence_ms/dt); % how many samples should each response function extend?
artifact_range = round(artifact_influence_ms/dt); % how many samples should each artifact influence?
t = (1:size(reshapeddata,2))*dt; % time vector for EEG

% Find event times
Nr = numel(event_types);
event_times = cell(1,Nr);
event_weights = cell(1,Nr);
if ~isfield(EEG.etc,'rejectepoch') % Add rejectepoch field if it's not there already
    EEG.etc.rejectepoch = zeros(EEG.trials,1);
end
for i=1:Nr
    isGoodEvent = strcmp(event_types{i},{EEG.event(:).type}) & ~EEG.etc.rejectepoch([EEG.event(:).epoch])';
    event_times{i} = [EEG.event(isGoodEvent).latency]*dt;
    event_weights{i} = EEG.etc.ureventweights([EEG.event(isGoodEvent).urevent]);
end

% Find blink events
artifact_times = [EEG.event(ismember({EEG.event(:).type}, artifact_types)).latency]*dt;

disp('Getting regressors...');
% Get regressors
% [~,S] = GetGlmRegressors(t,event_times,artifact_times,regressor_range,event_weights,stddev);
[~,S] = GetGlmRegressors_v2p0(t,event_times,artifact_times,regressor_range,artifact_range,event_weights,stddev);

% Crop data
isRelevantTime = sum(S,2)>0;
% Scrop = S(isRelevantTime,:);
Ecrop = reshapeddata(:,isRelevantTime);
% tcrop = t(isRelevantTime);


%% ICA section (pasted from ApplyIcaToGlmResults.m)

% set up
x = Ecrop; % data to use for ICA

% Declare options
avgref = 0; % Re-reference to average
zeromean = 0; % subtract mean of each channel
icatype = 'runica'; % ica algorithm to use
scalerms = 0; % Re-scale components so their root-mean-square value is 1
scalerss = 0; % Re-scale components so their root-SUM-square value is 1


% Re-reference to average
if avgref
    disp('Re-referencing to average...');
    x = x-repmat(mean(x,1),size(x,1),1);
end

% subtract mean of each channel
if zeromean
    disp('Subtracting mean from ICA input...');
%     meanx = mean(x,2);
    x = x-repmat(mean(x,2),1,size(x,2));
%     h = h-repmat(meanx,[1,size(h,2),size(h,3)]);
end

% Convert to double for added precision
x = double(x);

% Perform subspace analysis
switch icatype
    case 'fastica'
        [~,icawinv,icaweights] = fastica(x);
        icasphere = eye(size(icaweights,2));
    case 'runica'
        [icaweights,icasphere] = runica( x, 'lrate', 0.001, 'interupt', 'on', 'extended',1 );
        icawinv = pinv(icaweights*icasphere);
end

% Re-scale components so vectors are equal lengths
if scalerms
    disp('Scaling components to RMS microvolt');
    scaling = repmat(sqrt(mean(icawinv(:,:).^2))', [1 size(icaweights,2)]);
    icaweights = icaweights .* scaling;
    icawinv = pinv(icaweights * icasphere);
end
% Re-scale components so power of timecourse is the same
if scalerss
    disp('Scaling components to RSS microvolt');
    scaling = repmat(sqrt(sum(icawinv(:,:).^2))', [1 size(icaweights,2)]);
    icaweights = icaweights .* scaling;
    icawinv = pinv(icaweights * icasphere);
end