% Created 4/10/14 by DJ.

prefixes = {'sq','sf','sf3'};
events = {'Square','sf-Square','sf3-Square'};
event_weights = 1;
baseline_win = [0 -1];
iLevel = 1;
[contrastFns, contrastVar, contrastZ] = deal(cell(1,3));

for i=1:3

    eval(sprintf('results = R_%s_type;',prefixes{i}));
    event_list = events(i);

    [contrastFns{i}, contrastVar{i}, contrastZ{i}]  = SetUpTopLevelGlm_flex(results,event_list,event_weights,baseline_win,iLevel);

end

%% Run Top-Level GLMs
multcorrect = 'fdr';
[group_RF, group_P] = deal(cell(1,3));
for i=1:3
    % run level 2
    [group_RF{i},group_P{i}] = RunTopLevelGlm_EEG(contrastFns{i},contrastVar{i},multcorrect);
end

%% Get ERPs
iTimes = 1:51;
group_RF_all = [];
group_P_all = [];
for i=1:3
    group_RF_all(:,:,i) = group_RF{i}(:,iTimes);
    group_P_all(:,:,i) = group_P{i}(:,iTimes);
end
tResponse = R_sf_type(1).tResponse(iTimes);
chanlocs = R_sf_type(1).EEG.chanlocs;

%% Save results
save TopLevelGlmResults_Square group_* contrast* events event_weights baseline_win iLevel multcorrect tResponse chanlocs 


%% Plot ERPs
chansToPlot = {'FZ';'CZ';'PZ';'OZ'};
colors = {'r','g','b'};
legendstr = {'Active-2','Passive-2','Passive-3'};

figure;
% clf;
PlotResponseFnsGrid(group_RF_all,legendstr,tResponse,chanlocs,chansToPlot,colors);
for i=1:4
    subplot(4,1,i);
    ylabel(chansToPlot{i});
    title('');
end
set(gcf,'Position',[0 623 704 882]);
%% Plot Scalp Maps
tBinCenters = [125 225 425];%37.5:75:500;
tBinWidth = 50;%75;

clf;
[sm_all,sm] = GetScalpMaps(group_RF_all,tResponse,tBinCenters,tBinWidth);
PlotScalpMaps(sm_all,chanlocs,[],tBinCenters-tBinWidth/2,legendstr);

set(gcf,'Position',[684 1001 447 428]);

%% Plot Z score Scalp Maps
tBinCenters = [125 225 425];%37.5:75:500;
tBinWidth = 50;%75;
cthresh = 1.96; % z score for 2-tailed p=0.05
clim = [-5 5];
group_Z_all = norminv(group_P_all);

% figure;
clf;
set(gcf,'Position',[684 1001 447 428]);

[sm_all,sm] = GetScalpMaps(group_Z_all,tResponse,tBinCenters,tBinWidth,cthresh);
PlotScalpMaps(sm_all,chanlocs,clim,tBinCenters-tBinWidth/2,legendstr,cthresh);
