% SFFS_wrapper_testing
%
% Created 8/28/13 by DJ.

% Set plot parameters
fontname = 'Helvetica'; % Futura, Helvetica, Gotham, Georgia are all good
fontsize = 10;
linewidth = 2;
markersize = 20;

%%
truth_test = cell(size(truth));
for iSubj = 1:nSubjects
    for iFold=1:nFolds
        truth_test{iSubj,iFold} = truth{iSubj}(valTrials{iSubj,iFold});
    end
end

%% RUN TESTING: 10-fold xval on LEFT-OUT TRIALS (10% of original set)
[scoreTest] = deal(cell(1,nFolds));
fprintf('Started 10-fold at time: %s \n',datestr(now));
for iFold = 1:nFolds
    if ~isempty(scoreTest{iFold})
        fprintf('Skipping fold %d...\n',iFold);
        continue
    end
    tstart = tic;
    fprintf('Starting fold %d...\n',iFold);
    featcell_test = cell(size(featcell));    
    for i=1:nFeats
        for iSubj = 1:nSubjects
            featcell_test{i,iSubj} = featcell{i,iSubj}(valTrials{iSubj,iFold});            
        end
    end
    scoreTest{iFold} = nan(1,NumFeatComb);
    for j=1:NumFeatComb % # features to include in set
        if ~isempty(sffs_xsubj.features{iFold}{j})
            featcell_test_cropped = featcell_test(sffs_xsubj.features{iFold}{j},:);
            scoreTest{iFold}(j) = ClassifierWrapper_forSFFS_xsubj(featcell_test_cropped,featcell_test_cropped,truth_test(:,iFold));
        else
            scoreTest{iFold}(j) = -inf;
        end
    end
        
    fprintf('Fold %d done! took %g seconds.\n',iFold,toc(tstart));
end
fprintf('Done with 10-fold at time: %s \n',datestr(now));

%% RUN TESTING: TRAIN on TRAINING TRIALS (90% of original set), use mean weights across folds to classify testing trials
fprintf('Started 10-fold at time: %s \n',datestr(now));
y = cell(1,nSubjects);
for iFold = 1:nFolds
%     if ~isempty(scoreTest2{iFold})
%         fprintf('Skipping fold %d...\n',iFold);
%         continue
%     end
    tstart = tic;
    fprintf('Starting fold %d...\n',iFold);
    featcell_train = cell(size(featcell)); 
    featcell_test = cell(size(featcell)); 
    for i=1:nFeats
        for iSubj = 1:nSubjects
            featcell_train{i,iSubj} = featcell{i,iSubj}(incTrials{iSubj,iFold});
            featcell_test{i,iSubj} = featcell{i,iSubj}(valTrials{iSubj,iFold});            
        end
    end
    for j=1:NumFeatComb % # features to include in set
        fprintf('   set size = %d...\n',j);
        if ~isempty(sffs_xsubj.features{iFold}{j})
            % Get training weights
            featcell_train_cropped = featcell_train(sffs_xsubj.features{iFold}{j},:);
            [trainscore, v]  = ClassifierWrapper_forSFFS_xsubj_noxval(featcell_train_cropped,featcell_train_cropped,truth_train(:,iFold));
            
            % Extract mean weights across (classifier) folds
            vmean = cell(1,nSubjects);
            for iSubj = 1:nSubjects
                vmean{iSubj} = mean(v{iSubj},3);
            end
            
            % Apply to testing data
            featcell_test_cropped = featcell_test(sffs_xsubj.features{iFold}{j},:);
            subjscore = zeros(1,nSubjects);
            for iSubj = 1:nSubjects
                feats_train_cropped = cat(2,featcell_train_cropped{:,iSubj});
                feats_test_cropped = cat(2,featcell_test_cropped{:,iSubj});
                
                % Scale features
                yTrain = zeros(size(feats_train_cropped)); yTest = zeros(size(feats_test_cropped));
                for k=1:size(feats_test_cropped,2) % feature
                    [~,~,~,~,coeff] = classify(feats_test_cropped(:,k), feats_train_cropped(:,k), truth_train{iSubj,iFold});
                    wAddOn = coeff(2).linear;
                    if wAddOn==0 % Added for special case where class means are equal
                        wAddOn = eps;
                    end
                    yTrain(:,k) = feats_train_cropped(:,k)*wAddOn;
                    yTest(:,k) = feats_test_cropped(:,k)*wAddOn;

                    % Standardize stddev of each bin                
                    yTest(:,k) = yTest(:,k)/std(yTrain(:,k)); % normalize using training data
%                     yTrain(:,k) = yTrain(:,k)/std(yTrain(:,k));
                end
                
                % Apply training weights to testing data
                y{iSubj,j}(valTrials{iSubj,iFold}) = yTest*vmean{iSubj}';                
            end            
        end
    end
        
    fprintf('Fold %d done! took %g seconds.\n',iFold,toc(tstart));
end
disp('Getting AUC values...')
%
disp('Calculating AUC values...')
scoreTest3 = nan(nSubjects,NumFeatComb);
for iSubj=1:nSubjects
    for j=1:NumFeatComb
        scoreTest3(iSubj,j) = rocarea(y{iSubj,j},truth{iSubj});
    end
end       
fprintf('Done with 10-fold at time: %s \n',datestr(now));


%% Plot Testing Az values
% allscores = cat(1,scoreTest{:});
allscores = scoreTest3;
meanscore = mean(allscores(:,1:NumFeatComb),1);
stderrscore = std(allscores(:,1:NumFeatComb),[],1)/sqrt(nFolds);
% figure(336); clf; hold on
set(gca,'box','on','fontname',fontname,'fontsize',fontsize);
% h = errorbar(1:NumFeatComb, meanscore,stderrscore);
% set(h,'linewidth',linewidth);
ErrorPatch(0:NumFeatComb,[0.5 meanscore],[0 stderrscore],'r','r');
xlabel('set size');
ylabel('AUC')
plot([0 nFeats+1],[0.5 0.5],'k--','LineWidth',linewidth)
ylim([0.3 1]);
xlim([0 nFeats+1]);

%% Plot Testing Az for each subject at different NumFeatComb's

figure(337); clf; hold on
set(gca,'box','on','fontname',fontname,'fontsize',fontsize);

[~,subjOrder] = sort(scoreTest3(:,end),'descend');

setSizes = 1:6;%1:5:nFeats;
[~,subjOrder] = sort(scoreTest3(:,setSizes(end)),'descend');

plot(scoreTest3(subjOrder,setSizes),'.-','linewidth',linewidth);
legendstr = cell(1,numel(setSizes));
for i=1:numel(setSizes)
    legendstr{i} = sprintf('Set size = %d',setSizes(i));
end

% plot(setSizes,scoreTest3(:,setSizes)','.-','linewidth',linewidth);
% legendstr = cell(1,numel(setSizes));
% for i=1:numel(subjects)
%     legendstr{i} = sprintf('Subject %d',i);
% end


xlabel('# features included');
ylabel('Testing AUC')
plot([0 nFeats+1],[0.5 0.5],'k--','LineWidth',linewidth)
ylim([0.3 1]);
xlim([0 numel(subjects)+1])
% xlim([0 nFeats]);
legend(legendstr)

%% Get statistics... does adding a feature improve AZ?

allscores = scoreTest3;
fprintf('One-tailed SignRank tests on Testing data...\n')
p = zeros(1,NumFeatComb);
pp = cell(1,NumFeatComb);
for i=2:NumFeatComb
    pp{i} = zeros(1,i-1);
    for j=1:i-1        
        if median(allscores(:,i) - allscores(:,j)) > 0
            pp{i}(j) = signrank(allscores(:,i) - allscores(:,j),0)/2;%,'tail','right');
        else
            pp{i}(j) = 1-signrank(allscores(:,i) - allscores(:,j),0)/2;
        end        
    end
    p(i) = max(pp{i});
    fprintf('AUC(%d) > AUC(<%d): p = %g\n',i,i,p(i));
end