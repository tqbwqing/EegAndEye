function [erp,times,epochs] = GetSquaresErps(EEG,eventtypes,timerange)

% [erp,times,epochs] = GetSquaresErps(EEG,eventtypes,timerange)
% 
% INPUTS:
% -EEG is an eeglab data struct.
% -eventtypes is a cell array of length nT of strings, each indicating an 
% event type you want an ERP for.
% -timerange is a 2-element vector indicating the start and end time in ms 
% of the erp you want to see (relative to the time of the event).
%
% OUTPUTS:
% - erp is an [EEG.nbchan x nT x nTypes] matrix, where nT is the number of
% samples in the specified time range.
% - times is a [1xnT] matrix containing the latency of each erp time point
% releative to the anchoring event (in ms).
% - epochs is a 1xnTypes cell array, in which epochs{i} contains an
% [EEG.nbchan x nT x nEvents] matrix of the activity around event
% eventtypes{i}.
%
% Created 7/23/12 by DJ.
% Updated 8/2/12 by DJ - added epochs output.

nTypes = numel(eventtypes);
nT = round(diff(timerange)/1000*EEG.srate)+1; % # time points per epoch
times = timerange(1):(1000/EEG.srate):(timerange(1)+(nT-1)*1000/EEG.srate);

erp = nan([EEG.nbchan,nT,nTypes]);
epochs = cell(1,nTypes);
for i=1:nTypes
    event_times = [EEG.event(strcmp(eventtypes{i},{EEG.event.type})).latency];
    iEpochStart = round(event_times+timerange(1)/1000*EEG.srate);    
    epochs{i} = nan([EEG.nbchan,nT,numel(event_times)]);
    for j=1:numel(iEpochStart)
        epochs{i}(:,:,j) = EEG.data(:,iEpochStart(j)-1+(1:nT));
    end
    erp(:,:,i) = mean(epochs{i},3);
end
