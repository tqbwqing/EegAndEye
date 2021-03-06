function [epochNum epochLatency] = TimeToEpochNumber(EEG,times,sessionNumber,useAllEvents)

% Gets the epoch number containing an event at the given time.
%
% [epochNum epochLatency] = TimeToEpochNumber(EEG,times,sessionNumber,useAllEvents)
%
% Returns NaN for times with no epochs (EEG trial was probably removed), 
% or with more than one epoch (unlikely with new sessionNumber check).
%
% INPUTS:
% - EEG is an epoched eeglab data struct.
% - times is an n-element vector of init_times
% - sessionNumber is a scalar or n-element vector of the session number (if
% EEG contains multiple sessions). [1=first or only session]
% - useAllEvents is a binary value indicating whether non-anchor (t=0)
% events should be used in the search. [0=anchor events only]
%
% OUTPUTS:
% - epochNum is an n-element vector of epoch indices
% - epochLatency is an n-element vector of latencies within the specified
% epochs (in ms).
%
% Created 3/31/11 by DJ.
% Updated 7/22/11 by DJ - added useAllEvents option, epochLatency output.
% Updated 7/25/11 by DJ - added sessionNumber input to resolve doubles.
% Updated 8/22/11 by DJ - fixed sessionNumber bug.

% Handle defaults
if nargin<3
    sessionNumber = 1;
end
if nargin<4
    useAllEvents = false;
end

% convert scalar into vector, if necessary
if numel(sessionNumber)==1
    sessionNumber = repmat(sessionNumber,size(times));
end

% find init_time of anchoring event for each 
nEpochs = EEG.trials;

if ~useAllEvents % only use anchor events
    anchorTime = zeros(1,nEpochs);
    for i=1:nEpochs
        isAnchor = find([EEG.epoch(i).eventlatency{:}]==0,1); % if there are multiple anchor events, just use first one - they'll all have the same init_time
        anchorTime(i) = EEG.epoch(i).eventinit_time{isAnchor}; % find the init_time of this event
    end
    

    % Compare to input times
    epochNum = zeros(size(times));
    for i=1:numel(times)
        matches = find(anchorTime==times(i));
        if numel(matches)>1
            warning('Two trials match time #%d',i)
            epochNum(i) = NaN;
        elseif isempty(matches)
            epochNum(i) = NaN;
        else
            epochNum(i) = matches;
        end
    end
    % assign latency of zero to every event
    epochLatency = zeros(size(epochNum));
    epochLatency(isnan(epochNum)) = NaN;
        
else % use all events
    % initialize
    eventTimes = [EEG.event(:).init_time];
    eventEpochs = [EEG.event(:).epoch];
    ureventSessions = [1+cumsum(strcmp({EEG.urevent(:).type},'boundary'))];
    eventSessions = ureventSessions([EEG.event(:).urevent]);
    eventLatencies = [];
    % get events in each epoch
    for i=1:nEpochs
        newLatencies = [EEG.epoch(i).eventlatency{:}]; % current latency within the epoch
        % add to vector
        eventLatencies = [eventLatencies, newLatencies];
    end
    
    % Compare to input times
    epochNum = zeros(size(times));
    epochLatency = zeros(size(times));
    for i=1:numel(times)
        eventMatches = (eventTimes==times(i) & eventSessions==sessionNumber(i)); % events that match this time
        matches = unique(eventEpochs(eventMatches)); % trial number of matching events
        % guard against duplicates
        if numel(matches)>1
            warning('Two trials match time #%d',i)
            epochNum(i) = NaN;
            epochLatency(i) = NaN;
        elseif isempty(matches)
            epochNum(i) = NaN;
            epochLatency(i) = NaN;
        else
            epochNum(i) = matches;
            epochLatency(i) = unique(eventLatencies(eventMatches));
        end
    end
    
end
    