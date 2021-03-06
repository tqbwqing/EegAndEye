function [EEG, eventsToRedact] = RedactArtifacts_events(EEG,artifact_events,tRange)

% Find the events around artifacts and append ' - REDACTED' to their names.
%
% [EEG, eventsToRedact] = RedactArtifacts_events(EEG,artifact_events,tRange)
%
% INPUTS:
% -EEG is an eeglab data struct (not epoched) with events already added.
% -artifact_events is a string or cell array of strings indicating the
% events.
% -tRange is a 2-element vector indicating the minimum and maximum time (in
% ms, relative to the event time) that should be redacted.
%
% OUTPUTS:
% -EEG is the same as the EEG input, but with every event within tRange ms 
% of any artifact event having ' - REDACTED' appended to its name.
% -eventsToRedact is a vector of EEG.event indices that were too close to
% an artifact event.
%
% Created 3/20/13 by DJ.

if ~iscell(artifact_events)
    artifact_events = {artifact_events};
end
% if size(EEG.data,3)>1
%     error('This function is for use with continuous datasets only!');
% end

sampleRange = tRange/1000*EEG.srate;
iEvents = find(ismember({EEG.event.type},artifact_events));
problemEvents = cell(1,numel(iEvents));

% hWait = waitbar(0,sprintf('Dealing with %d artifacts...',numel(iEvents)));
for i=1:numel(iEvents) % for each event
%     waitbar(i/numel(iEvents),hWait);
    sampleEvent = EEG.event(iEvents(i)).latency; % time when event occurred
%     eventsToRedact = find([EEG.event.latency]>sampleEvent+sampleRange(1),1):find([EEG.event.latency]<sampleEvent+sampleRange(2),1,'last');
    iFirstProblem = (1+find([EEG.event(1:iEvents(i)).latency]<sampleEvent+sampleRange(1),1,'last')); % fast find for ordered data
    iLastProblem = (iEvents(i)-2+find([EEG.event(iEvents(i):end).latency]>sampleEvent+sampleRange(2),1)); % fast find for ordered data
    if isempty(iFirstProblem), iFirstProblem=1; end
    if isempty(iLastProblem), iLastProblem=length(EEG.event); end
    problemEvents{i} = iFirstProblem:iLastProblem;  % fast find for ordered data
    if isfield(EEG.event,'epoch')
        problemEvents{i} = problemEvents{i}([EEG.event(problemEvents{i}).epoch] == EEG.event(iEvents(i)).epoch);
    end
end
% close(hWait);

eventsToRedact = unique([problemEvents{:}]);
for j=1:numel(eventsToRedact)
    if isempty(strfind(EEG.event(eventsToRedact(j)).type, 'REDACTED'));
        EEG.event(eventsToRedact(j)).type = strcat(EEG.event(eventsToRedact(j)).type, ' - REDACTED'); % REDACTED!
    end
end
% newtypes = arrayfun(@strcat,{EEG.event(eventsToRedact).type},repmat({' - REDACTED'},size(eventsToRedact))); % REDACTED!
% [EEG.event(eventsToRedact).type] = deal(newtypes{:});
