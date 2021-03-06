function SaccadeDelayHistogram(subjects, fileSuffix, tBins)

% A histogram of the time between the appearance of an object and the first
% saccade to that object.
%
% SaccadeDelayHistogram(subjects, fileSuffix, tBins)
%
% INPUTS:
% -subjects is a vector of the subjects being studied
% -fileSuffix is a string specifying the filename after '3DS-<subject>' and
% before '.set'
% -tBins is a vector of time bin centers to be used in the histogram.
%
% Created 1/11/11 by DJ.
% Updated 2/17/11 by DJ - made a function. TO DO: comment better!
% Updated 5/12/11 by DJ - fixed eventLatencies so they use sampling rate

%% HANDLE INPUTS
if nargin<1
    subjects = [6 2 7];
end
if nargin<2 || isempty(fileSuffix)
    fileSuffix = '-all-filtered-noduds';
end
if nargin<3
    tBins = 50:100:950;
end

%% SET UP
GetNumbers; % Load constants in form of Numbers struct
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[]; % initialize EEGLAB stuff
targPctInBin = zeros(numel(subjects),numel(tBins));
disPctInBin = zeros(numel(subjects),numel(tBins));

%% MAIN LOOP
for i=1:numel(subjects);
    % Load
    EEG = pop_loadset('filename',sprintf('3DS-%d%s.set',subjects(i),fileSuffix));
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % get info
    eventTypes = [str2double({EEG.event(:).type})];
    eventLatencies = [EEG.event(:).latency] * 1000/EEG.srate;
    
    % get event latencies
    targSacLatencies = eventLatencies(eventTypes == Numbers.SACCADE_TO+Numbers.TARGET);
    disSacLatencies = eventLatencies(eventTypes==Numbers.SACCADE_TO+Numbers.DISTRACTOR);
    targAppLatencies = eventLatencies(eventTypes == Numbers.ENTERS+Numbers.TARGET);
    disAppLatencies = eventLatencies(eventTypes==Numbers.ENTERS+Numbers.DISTRACTOR);

    % Get delays between appearances and saccades
    targSacDelays = NaN(1,numel(targSacLatencies));
    disSacDelays = NaN(1,numel(disSacLatencies));
    for j=1:numel(targSacLatencies)
        iLastApp = find(targAppLatencies<targSacLatencies(j),1,'last');
        targSacDelays(j) = targSacLatencies(j) - targAppLatencies(iLastApp);
    end
    for j=1:numel(disSacLatencies)
        iLastApp = find(disAppLatencies<disSacLatencies(j),1,'last');
        disSacDelays(j) = disSacLatencies(j) - disAppLatencies(iLastApp);
    end
    
    % Get hist
    targPctInBin(i,:) = hist(targSacDelays,tBins)/numel(targSacDelays)*100; % percent of saccade delays in this time bin
    disPctInBin(i,:) = hist(disSacDelays,tBins)/numel(disSacDelays)*100; % percent of saccade delays in this time bin
end
  
%% PLOT HIST
targPctMean = mean(targPctInBin,1);
disPctMean = mean(disPctInBin,1);
cla;
hold on;
plot([0 tBins],[0 cumsum(targPctMean)],'b');
plot([0 tBins],[0 cumsum(disPctMean)],'r');
legend('targets','distractors');
xlabel('delay (ms)');
ylabel('% trials');
title(sprintf(['Delay between stimulus onset and saccade to stimulus\n'...
    '(Cumulative histogram for subjects [%s])'], num2str(subjects)));