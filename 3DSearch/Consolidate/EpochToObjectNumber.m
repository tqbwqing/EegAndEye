function objNumbers = EpochToObjectNumber(EEG,objtimes,objsessions,epNumbers)

% Gets the object number seen in the given epoch.
%
% objNumbers = EpochToObjectNumber(EEG,subject,sessions,objsessions,epNumbers)
%
% INPUTS:
% - EEG is an epoched eeglab data struct.
% - objtimes is a vector of times found with GetObjectList;
% - epNumbers is an n-element vector of epoch numbers between 1 and
% EEG.trials.
%
% OUTPUTS:
% - objNumbers is an n-element vector of object numbers.  Each object is
% then described by the 3DS data struct in x.object.
%
% Created 4/18/11 by DJ.
% Updated 12/1/11 by DJ - added objsessions input

% Declare defaults
if nargin<3 || isempty(objsessions)
    objsessions = nan(size(objtimes));
end
if nargin<4 || isempty(epNumbers)
    epNumbers=1:EEG.trials;
end

% Find boundaries between sessions
urevent_boundaries = [0 find(diff([EEG.urevent(:).init_index])<0)]; % urevent indices of boundaries
% find init_time of anchoring event for each epoch
nEpochs = numel(epNumbers);
anchorTime = zeros(1,nEpochs);
anchorSession = zeros(1,nEpochs);
GetNumbers;
for i=1:nEpochs
    isAnchor = find([EEG.epoch(epNumbers(i)).eventlatency{:}]==0,1); % if there are multiple anchor events, just use first one - they'll all have the same init_time
    anchorTime(i) = EEG.epoch(epNumbers(i)).eventinit_time{isAnchor}; % find the init_time of this event
    anchorSession(i) = sum(urevent_boundaries<EEG.epoch(epNumbers(i)).eventurevent{isAnchor}); % which session is this anchor in?
end

% Compare to input times
% objNumbers = zeros(size(epNumbers));
% eventTimes = x.eeg.object_events(:,1)/EEG.srate; % convert to units of seconds
% eventObjects = x.eeg.object_events(:,2)-Numbers.ENTERS;

objNumbers = nan(1,nEpochs);
for i=1:nEpochs
    if ~isnan(objsessions(1)) % session numbers are indicated
        % Find CLOSEST eeg anchor to the requested object time
        iThisSession = find(objsessions==anchorSession(i));
        [dist,iBest] = min(abs(objtimes(iThisSession)-anchorTime(i)));
%         fprintf('dist = %g\n',dist)
        objNumbers(i) = iThisSession(iBest);
    else % session number is unknown
        matches = find(objtimes==anchorTime(i));
        if numel(matches)>1
            warning('Two trials match time #%d',i)
            objNumbers(i) = NaN;
        elseif isempty(matches)
            objNumbers(i) = NaN;
        else
            objNumbers(i) = matches;
        end
    end
end