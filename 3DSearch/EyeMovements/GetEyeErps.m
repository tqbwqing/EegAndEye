function data = GetEyeErps(eyepos,pupilsize,x,epochRange)

% Get the eye position and pupil size from a single session and put it into
% a data struct for use by functions like EyeErpMovie().
%
% data = GetEyeErps(eyepos,pupilsize,x,epochRange)
%
% Inputs:
%   - eyepos is an nx2 matrix, where n is the number of samples of eye
% position data. Each row is the (x,y) position of the eye at that time.
% This will be the position of the dot on the screen.
%   - pupilsize is an n-element vector, where each element is the size of
% the subject's pupil (in unknown units).  This will be the size of the dot
% on the screen.
%   - x is a 3DSearch data structure as imported by Import_3DS_Data_v3.
%   - epochRange is a 2-element vector indicating the start and end of the
% epoch you want to study (in samples).  [Default = [-500 3000]]
%
% Outputs:
%   - data is a structure with fields:
% + epochSamples: 1xT vector containing the number of samples away from
% the epoching event for each point.
% + epochTimes: 1xT vector containing the number of ms away from the 
% epoching event for each point.
% + targetEyeEpochs - nxT matrix of cells, each of which contains [x;y]
% position of eye for that trial (row) and time (column).
% + targetPupEpochs - nxT matrix, in which each entry is the pupil size for
% that trial (row) and time (column).
% + targetObjEpochs - nxT matrix of cells, each of which contains the
% boundaries [xmin, ymin, width, height] of the object for that trial (row)
% and time (column).
% + distractor versions of the three 'target' things listed above.
% + screen_res - the width and height, in pixels, of the screen in this
% session.
%
% Created 3/29/11 by DJ.
% Updated 11/3/11 by DJ - added epochRange input to avoid end-of-session 
%   error.
% Updated 11/4/11 by DJ - epochTimes are in eyelink time now.

%% -------- SETUP -------- %
if nargin<4 || isempty(epochRange)
    epochRange = [-500 3000];
end
fs = 1000;
screen_res = [1024, 768]; % In the future, we should get this from the data struct x.
% global epochSamples h;
epochSamples = epochRange(1):epochRange(2);
epochTimes = epochSamples*1000/fs;
% Parse inputs
object_limits = x.eyelink.object_limits;
record_time = x.eyelink.record_time; % time 'offset' - the time when eyelink started recording.
isTarget = strcmp('TargetObject',{x.objects(:).tag});

% -------- EPOCH -------- %
% Get sample numbers around when targets or distractors came onscreen
GetNumbers;
targetOnset = x.eyelink.object_events(ismember(x.eyelink.object_events(:,2),Numbers.ENTERS+find(isTarget)),1);
distractorOnset = x.eyelink.object_events(ismember(x.eyelink.object_events(:,2),Numbers.ENTERS+find(~isTarget)),1);
targetSamples = nan(numel(targetOnset),numel(epochSamples));
targetEventTimes = nan(numel(targetOnset),1);
distractorSamples = nan(numel(distractorOnset),numel(epochSamples));
distractorEventTimes = nan(numel(distractorOnset),1);
for i=1:numel(targetOnset)
    targetSamples(i,:) = targetOnset(i) + epochSamples;
    targetEventTimes(i,:) = targetOnset(i);
end
for i=1:numel(distractorOnset)
    distractorSamples(i,:) = distractorOnset(i) + epochSamples;
    distractorEventTimes(i,:) = distractorOnset(i);
end

targetEyeEpochs = cell(size(targetSamples));
targetPupEpochs = zeros(size(targetSamples));
targetObjEpochs = cell(size(targetSamples));
distractorEyeEpochs = cell(size(distractorSamples));
distractorPupEpochs = zeros(size(distractorSamples));
distractorObjEpochs = cell(size(distractorSamples));

for i=1:numel(targetSamples)
    sample =  targetSamples(i)-record_time+1;
    if sample<=length(eyepos);
        targetEyeEpochs{i} = eyepos(sample,:)';
        targetPupEpochs(i) = pupilsize(sample);
    else
        targetEyeEpochs{i} = [NaN; NaN];
        targetPupEpochs(i) = NaN;
    end
    iLim = find(object_limits(:,1)>targetSamples(i)-20 & object_limits(:,1)<targetSamples(i),1,'last');
    targetObjEpochs{i} = object_limits(iLim,3:6);
end
for i=1:numel(distractorSamples)
    sample =  distractorSamples(i)-record_time+1;
    if sample<=length(eyepos);
        distractorEyeEpochs{i} = eyepos(sample,:)';
        distractorPupEpochs(i) = pupilsize(sample);
    else
        distractorEyeEpochs{i} = [NaN; NaN];
        distractorPupEpochs(i) = NaN;
    end

    iLim = find(object_limits(:,1)>distractorSamples(i)-20 & object_limits(:,1)<distractorSamples(i),1,'last');
    distractorObjEpochs{i} = object_limits(iLim,3:6);
end

% add to data struct
data.epochSamples = epochSamples;
data.epochTimes = epochTimes;
data.targetEventTimes = targetEventTimes; % EyelinkToEegTimes(targetEventTimes,x)/x.eeg.eventsamplerate;
data.targetEyeEpochs = targetEyeEpochs;
data.targetPupEpochs = targetPupEpochs;
data.targetObjEpochs = targetObjEpochs;
data.distractorEventTimes = distractorEventTimes; % EyelinkToEegTimes(distractorEventTimes,x)/x.eeg.eventsamplerate;
data.distractorEyeEpochs = distractorEyeEpochs;
data.distractorPupEpochs = distractorPupEpochs;
data.distractorObjEpochs = distractorObjEpochs;
data.screen_res = screen_res;