function [AUC,v] = ClassifierWrapper_forSFFS_xsubj_noxval(bigFeature,~,truth)

% Created 8/27/13 by DJ.
% Updated 8/28/13 by DJ - added v output

% Make bigFeature into one cell per subject
nSubjects = size(bigFeature,2);
features = cell(1,nSubjects);
for iSubj=1:nSubjects
    features{iSubj} = cat(2,bigFeature{:,iSubj});
end

% classify
% set up
samplesWindowLength = [];
samplesWindowStart = [];
cvmode = 'nocrossval';
fwdModelData = [];
nSubjects = numel(truth);
v = cell(1,nSubjects);
subjAUC = nan(1,nSubjects);
% run
for iSubj=1:numel(truth)    
    dwellFeature = features{iSubj};
    data = zeros(1,1,size(dwellFeature,1));
    [y, ~, v{iSubj}] = Run2LevelClassifier_nested(data,truth{iSubj},samplesWindowLength,samplesWindowStart,cvmode,dwellFeature,fwdModelData);
    subjAUC(iSubj) = rocarea(y,truth{iSubj});    
end
    
AUC = mean(subjAUC);