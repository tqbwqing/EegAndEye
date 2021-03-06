function PlotEyeSamplesAndEvents(samples,tFirstSample,eventTimes,eventNames,tRange)

% Plots x/y eye position and events during a specified time interval.
%
% PlotEyeSamplesAndEvents(samples,tStart,events,tRange)
%
% INPUTS:
% -samples is an nx2 matrix of the x and y position of the eye over time.
% -tFirstSample is the time at which the eyelink started logging (typically
% the number after START in an eyelink .asc file).
% -eventTimes is an m-element vector of eyelink times at which events of 
% interest happened.
% -eventNames is an m-element cell array of strings, each of which is the
% name of the event that occurred at the corresponding eventTime.  If it is
% a string, it is assumed that all the events are of this type.
% -tRange is a 2-element vector indicating the time at which 
%
% Created 2/16/12 by DJ.

% Handle inputs
if nargin<4 || isempty(eventNames)
    eventNames = repmat({'event'},size(eventTimes));
elseif ischar(eventNames)
    eventNames = repmat({eventNames},size(eventTimes));
end
if nargin<5 || isempty(tRange)
    tRange = [1 length(samples)]+tFirstSample;
end

% Crop samples and events
iStart = round(tRange(1)-tFirstSample);
iEnd = round(tRange(2)-tFirstSample);
iSamples = iStart:iEnd;
iEvents = find(eventTimes>tRange(1) & eventTimes<tRange(2));

% Plot samples
cla; hold on;
plot(samples(iSamples,:));
% Plot each event type separately
linestyles = {'r:' 'g:' 'y:' 'c:' 'm:' 'k:'...
    'r.-' 'g.-' 'y.-' 'c.-' 'm.-' 'k.-' ...
    'r-' 'g-' 'y-' 'c-' 'm-' 'k-'};
uniqueEventNames = unique(eventNames(iEvents));
for i=1:numel(uniqueEventNames)
    iThisEvent = iEvents(strcmp(uniqueEventNames{i},eventNames(iEvents)));
    PlotVerticalLines(eventTimes(iThisEvent)-tRange(1),linestyles{i});
end
% Annotate plot
legend([{'xEye','yEye'} uniqueEventNames])
xlabel('Time (ms)');
ylabel('Eye Position (a.u.)')
title(sprintf('Eye and Events from %d to %d ms',tRange(1),tRange(2)))