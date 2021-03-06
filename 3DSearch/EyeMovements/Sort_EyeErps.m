function [Ldata, Rdata] = Sort_EyeErps(data)

% Sort an Eye ERP by the side on which the object appeared.
%
% [Ldata, Rdata] = Sort_EyeErps(data)
%
% INPUTS:
% -data is an eye position data struct from PlotEyeErps_MultiSession (or
% just GetEyeErps).
% 
% OUTPUTS:
% -Ldata and Rdata are the subsets of trials from input data that have the
% object appearing on the right or left side.
%
% Created 7/29/11 by DJ.

% copy
Ldata = data;
Rdata = data;

% sort
x_middle = data.screen_res(1)/2; % x position of middle of screen
tzero = find(data.epochTimes>0,1); % index of first positive sample
tPos = cat(1,data.targetObjEpochs{:,tzero});
tL = (tPos(:,1)<x_middle); % target trials on L side
tR = (tPos(:,1)>x_middle); % target trials on R side
dPos = cat(1,data.distractorObjEpochs{:,tzero});
dL = (dPos(:,1)<x_middle); % distractor trials on L side
dR = (dPos(:,1)>x_middle); % distractor trials on R side

% crop Ldata
Ldata.targetEventSessions = Ldata.targetEventSessions(tL,:);
Ldata.targetEventTimes = Ldata.targetEventTimes(tL,:);
Ldata.targetEyeEpochs = Ldata.targetEyeEpochs(tL,:);
Ldata.targetPupEpochs = Ldata.targetPupEpochs(tL,:);
Ldata.targetObjEpochs = Ldata.targetObjEpochs(tL,:);

Ldata.distractorEventSessions = Ldata.distractorEventSessions(dL,:);
Ldata.distractorEventTimes = Ldata.distractorEventTimes(dL,:);
Ldata.distractorEyeEpochs = Ldata.distractorEyeEpochs(dL,:);
Ldata.distractorPupEpochs = Ldata.distractorPupEpochs(dL,:);
Ldata.distractorObjEpochs = Ldata.distractorObjEpochs(dL,:);

% crop Rdata
Rdata.targetEventSessions = Rdata.targetEventSessions(tR,:);
Rdata.targetEventTimes = Rdata.targetEventTimes(tR,:);
Rdata.targetEyeEpochs = Rdata.targetEyeEpochs(tR,:);
Rdata.targetPupEpochs = Rdata.targetPupEpochs(tR,:);
Rdata.targetObjEpochs = Rdata.targetObjEpochs(tR,:);

Rdata.distractorEventSessions = Rdata.distractorEventSessions(dR,:);
Rdata.distractorEventTimes = Rdata.distractorEventTimes(dR,:);
Rdata.distractorEyeEpochs = Rdata.distractorEyeEpochs(dR,:);
Rdata.distractorPupEpochs = Rdata.distractorPupEpochs(dR,:);
Rdata.distractorObjEpochs = Rdata.distractorObjEpochs(dR,:);

clear tL tR dL dR tPos dPos