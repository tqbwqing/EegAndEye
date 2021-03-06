function [cLbest,maxJ,X,C]=SequentialForwardFloatingSelection_DJ(class1,class2,CostFunction,NumFeatComb,otherInputs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%  [cLbest,maxJ]=SequentialForwardFloatingSelection_DJ(class1,class2,CostFunction,NumFeatComb);
%  Feature vector selection by means of the Sequential Forward Floating
%  Selection technique, given the desired number of features in the best combination.
%
% INPUT ARGUMENTS:
%   class1:         matrix of data for the first class, one pattern per column.
%   class2:         matrix of data for the second class, one pattern per column.
%   CostFunction:   class separability measure.
%   NumFeatComb:    desired number of features in best combination.
%   otherInputs:    cell array of other arguments used as input to cost fn.
%
% OUTPUT ARGUMENTS:
%   cLbest:         selected feature subset. Vector of row indices.
%   maxJ:           value of the class separabilty measure.
%   X:              NumFeatComb-element cell array of feature sets
%   C:              NumFeatComb-element vector of classification scores
%
% (c) 2010 S. Theodoridis, A. Pikrakis, K. Koutroumbas, D. Cavouras
%
% Updated 8/23/13 by DJ - added otherInputs input
% Updated 8/26/13 by DJ - commented and re-coded for simplification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning('off');
m=size(class1,1);   % total # features
k=1;                % current # features
X = cell(1,m);      % current set of features
C = repmat(-inf,1,m); % classification score of current feature set
% Initialization
[X{k},C(k)]=SequentialForwardSelection(class1,class2,CostFunction,k,otherInputs); % best k features and classification score
% Print current feature set
fprintf('---Set size %d: [%s], score = %g\n',k, num2str(X{k}),C(k))

% Initialize flags
% add_helped = 1;
% sub_helped = 1;
while k<NumFeatComb %&& (add_helped || sub_helped)
    
    % Step I: Add    
    Ct=[]; % classification score of each option
    Y=setdiff(1:m,X{k}); % features NOT in current set
    for i=1:length(Y)
        t=[X{k} Y(i)]; % add each out feature to set
        Ct=[Ct eval([CostFunction '(class1(t,:),class2(t,:),otherInputs{:});'])]; % get classification score
    end
    [Ja,ind]=max(Ct); % Find best one
    xa=Y(ind); % Find additional feature
    fprintf('------best feature to add: %d\n',xa)
    % ADD NEW FEATURE
    if Ja > C(k+1) % If this size-K+1 set is better than any previous K+1s...
        X{k+1}=[X{k} xa];% Add to feature set
        C(k+1) = Ja;    % Update classification score        
        fprintf('---Set size %d: [%s], score = %g\n',k+1,num2str(X{k+1}),C(k+1))
%         add_helped = 1;
%     else
%         add_helped = 0;
    end
    k = k+1;            % Update # features
    
    
    % Step II: Subtract    
    sub_helped = 0;
    while k>=2         
        Ct = [];
        for i=1:length(X{k})
            t=setdiff(X{k}, X{k}(i));
            Ct=[Ct eval([CostFunction '(class1(t,:),class2(t,:),otherInputs{:});'])];
        end
        [Js,ind] = max(Ct);
        xs = X{k}(ind);
        fprintf('------best feature to subtract: %d\n',xs)
        if Js > C(k-1) % If this size-K-1 set is better than any previous K-1s...
            X{k-1} = setdiff(X{k},xs);   % Subtract from feature set
            C(k-1) = Js;                  % Update classification score
            k=k-1;                      % Update # features
            fprintf('---Set size %d: [%s], score = %g\n',k, num2str(X{k}),C(k))
%             sub_helped = 1;
        else
            break
        end
    end

end

if k>NumFeatComb
    k=k-1;
end
% Print final feature set
fprintf('FINAL SET = [%s], score = %g\n',num2str(X{k}),C(k))
% Prepare outputs
cLbest=sort(X{k},'ascend');
maxJ=C(k);

