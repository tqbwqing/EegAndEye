function ApplyEyePosCorrection(subject,sessions,calibration,pixelThresholds,timeLimits)

% ApplyEyePosCorrection(subject,sessions,calibration,pixelThresholds,timeLimits)
%
% INPUTS: 
% -
%
% Created 5/13/13 by DJ.

% Handle inputs
if nargin<3 || isempty(calibration)
    warning('Applying null calibration...')
    calibration = repmat(struct('eye_offset_x',0,'eye_offset_y',0,'eye_gain_x',1,'eye_gain_y',1),1,numel(sessions));
end
if nargin<4
    pixelThresholds = 200;
end
if nargin<5
    timeLimits = [0 Inf];
end

% Declare constants
singleSuffix = '-filtered';
comboSuffix = '-all-filtered';
eventsRule = 'OddballTask';
maxSeeTime = 2000;

otherComboFiles = {'-all-filtered-noduds','-all-filtered-noduds-ica'};

N = numel(sessions);

for i=1:N
    % Load behavior file
    filename = sprintf('3DS-%d-%d.mat',subject,sessions(i));
    foo = load(filename);
    % Undo old eye calibration
    x = UndoEyeCalibration(foo.x);
    
    % Replace calibration
    x.calibration = calibration(i);
    % apply eye calibration
    x.eyelink.saccade_positions = ApplyEyeCalibration(x.eyelink.saccade_positions, x);
    x.eyelink.saccade_start_positions = ApplyEyeCalibration(x.eyelink.saccade_start_positions, x);
    x.eyelink.fixation_positions = ApplyEyeCalibration(x.eyelink.fixation_positions, x);
    % re-calculate saccade events
    x.eyelink.saccade_events = classify_saccades(x.eyelink.saccade_times,x.eyelink.saccade_positions,x.eyelink.object_limits,pixelThresholds,timeLimits);
    x = EyelinkToEegTimes(x); % to reset the x.eeg.saccade events used in MakeEyeMovie
    
    % Save result
    save(filename,'x');
    
    % Update EEG events
    % Use info to change files!
    AddEeglabEvents(subject,sessions(i),singleSuffix,eventsRule,maxSeeTime);

end

% Recombine sessions
CombineEeglabSessions(subject,sessions,singleSuffix,comboSuffix);

%% Replace events struct in other combo files
EEG0 = pop_loadset(sprintf('3DS-%d%s.set',subject,comboSuffix));
for i=1:numel(otherComboFiles)
    EEG = pop_loadset(sprintf('3DS-%d%s.set',subject,otherComboFiles{i}));
    EEG.event = EEG0.event;
    EEG.urevent = EEG0.urevent;
    EEG = pop_saveset(EEG,EEG.filename);
end