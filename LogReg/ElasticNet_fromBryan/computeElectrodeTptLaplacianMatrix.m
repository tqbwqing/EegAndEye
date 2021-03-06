function [L,AC] = computeElectrodeTptLaplacianMatrix(eegchans,ntpts,elecMode)

if ~exist('elecMode'); elecMode='startFrom43'; end;

chantptedgeval = 1;
lapmode = 'normalized';
includeblankrowcol = 1;

eegchanssave = eegchans;

if strcmp(elecMode,'startFrom34')
    AC = zeros(34,34);
    AC(1,[2,3]) = 1;
    AC(2,[1,4]) = 1;
    AC(3,[1,6]) = 1;
    AC(4,[2,8]) = 1;
    AC(5,[6,10]) = 1;
    AC(6,[3,5,11]) = 1;
    AC(7,[11,12,16]) = 1;
    AC(8,[4,9,12]) = 1;
    AC(9,[8,13]) = 1;
    AC(10,[5,14]) = 1;
    AC(11,[6,7]) = 1;
    AC(12,[7,8]) = 1;
    AC(13,[9,18]) = 1;
    AC(14,[10,15]) = 1;
    AC(15,[14,16,20]) = 1;
    AC(16,[7,15,17]) = 1;
    AC(17,[16,18,21]) = 1;
    AC(18,[13,17]) = 1;
    AC(19,[23]) = 1;
    AC(20,[15,24,25]) = 1;
    AC(21,[17,25,26]) = 1;
    AC(22,[27]) = 1;
    AC(23,[19,28]) = 1;
    AC(24,[20,29]) = 1;
    AC(25,[20,21,33]) = 1;
    AC(26,[21,30]) = 1;
    AC(27,[22,31]) = 1;
    AC(28,[23,29]) = 1;
    AC(29,[24,28,32]) = 1;
    AC(30,[26,31,34]) = 1;
    AC(31,[27,30]) = 1;
    AC(32,[29,33]) = 1;
    AC(33,[25,32,34]) = 1;
    AC(34,[30,33]) = 1;
    
    eegchans = 1:34;
elseif strcmp(elecMode,'startFrom43')
    AC = zeros(43,43);
    AC(1,[2,12,13,25]) = 1;
    AC(2,[1,3,25]) = 1;
    AC(3,[2,4]) = 1;
    AC(4,[3,5]) = 1;
    AC(5,[4,6]) = 1;
    AC(6,[5,7,9]) = 1;
    AC(7,[6,8,9]) = 1;
    AC(8,[7,37,43]) = 1;
    AC(9,[6,7,10]) = 1;
    AC(10,[9,11,12]) = 1;
    AC(11,[10,12,40,43]) = 1;
    AC(12,[1,10,11,13]) = 1;
    AC(13,[1,12,27,42]) = 1;
    AC(14,[15,16]) = 1;
    AC(15,[14,17]) = 1;
    AC(16,[14,18]) = 1;
    AC(17,[15,19,21]) = 1;
    AC(18,[16,20,22]) = 1;
    AC(19,[17,21,23]) = 1;
    AC(20,[18,22,24]) = 1;
    AC(21,[17,19,28]) = 1;
    AC(22,[18,20,29]) = 1;
    AC(23,[19,25]) = 1;
    AC(24,[20,26]) = 1;
    AC(25,[1,2,23]) = 1;
    AC(26,[24,30,31]) = 1;
    AC(27,[13,28,29,42]) = 1;
    AC(28,[21,27,29]) = 1;
    AC(29,[22,27,28]) = 1;
    AC(30,[26,31,41,42]) = 1;
    AC(31,[26,30,32]) = 1;
    AC(32,[31,33]) = 1;
    AC(33,[32,34]) = 1;
    AC(34,[33,35]) = 1;
    AC(35,[34,36,38]) = 1;
    AC(36,[35,37,38]) = 1;
    AC(37,[8,36,43]) = 1;
    AC(38,[35,36,39]) = 1;
    AC(39,[38,40,41]) = 1;
    AC(40,[11,39,41,43]) = 1;
    AC(41,[30,39,40,42]) = 1;
    AC(42,[13,27,30,41]) = 1;
    AC(43,[8,11,37,40]) = 1;
    
    eegchans = 1:43;
    
elseif strcmp(elecMode,'startFrom79') % Sensorium System
    % The list was created using the 4 closes electrodes to each electrode,
    % and adjusted to create well-distributed pairings.
    % ---Comment Legend:---
    % -x: electrode x was removed from the "top 4" list
    % x>y: elec. x replaced elec. y in the "top 4" list.
    AC = zeros(79);
    AC(1,[69,32,61]) = 1; %-3
    AC(2,[62,33,69]) = 1; %-3
    AC(3,[69,33,6,32]) = 1; 
    AC(4,[61,34,9,63]) = 1;
    AC(5,[32,35,10,34]) = 1;
    AC(6,[3,36,11,35]) = 1;
    AC(7,[33,37,12,36]) = 1;
    AC(8,[62,64,13,37]) = 1;
    AC(9,[4,38,14,74]) = 1;
    AC(10,[5,39,15,38]) = 1;
    AC(11,[6,40,16,39]) = 1;
    AC(12,[7,41,17,40]) = 1;
    AC(13,[8,70,18,41]) = 1;
    AC(14,[9,42,19,75]) = 1;
    AC(15,[10,43,20,42]) = 1;
    AC(16,[11,44,21,43]) = 1;
    AC(17,[12,45,22,44]) = 1;
    AC(18,[13,76,23,45]) = 1;
    AC(19,[14,46,24]) = 1; %-50
    AC(20,[15,47,25,46]) = 1;
    AC(21,[16,48,26,47]) = 1;
    AC(22,[17,49,27,48]) = 1;
    AC(23,[18,28,49]) = 1; %-53
    AC(24,[19,50,54,66]) = 1;
    AC(25,[20,51,56,50]) = 1;
    AC(26,[21,52,57,51]) = 1;
    AC(27,[22,53,58,52]) = 1;
    AC(28,[23,65,60,53]) = 1;
    AC(29,[56,30,67,54]) = 1; %67>55
    AC(30,[57,31,73,29]) = 1;
    AC(31,[58,60,68,30]) = 1; %68>59
    AC(32,[1,5,3,61]) = 1;
    AC(33,[2,7,3,62]) = 1;
    AC(34,[5,4,38]) = 1; %-61
    AC(35,[6,5,39]) = 1; %-32
    AC(36,[6,7,40]) = 1; %-33
    AC(37,[7,8,41]) = 1; %-62
    AC(38,[34,42,9,10]) = 1;
    AC(39,[10,11,43,35]) = 1;
    AC(40,[12,11,44,36]) = 1;
    AC(41,[37,45,13,12]) = 1;
    AC(42,[38,46,15,14]) = 1;
    AC(43,[47,39,15,16]) = 1;
    AC(44,[48,40,16,17]) = 1;
    AC(45,[41,49,17,18]) = 1;
    AC(46,[50,42,19,20]) = 1;
    AC(47,[20,43,21,51]) = 1;
    AC(48,[22,21,44,52]) = 1;
    AC(49,[53,45,23,22]) = 1;
    AC(50,[25,24,55,46]) = 1;
    AC(51,[26,25,78,47]) = 1;
    AC(52,[26,27,71,48]) = 1;
    AC(53,[27,28,59,49]) = 1;
    AC(54,[55,24,29,77]) = 1; %77>50
    AC(55,[56,54,50]) = 1; %-29
    AC(56,[55,78,29,25]) = 1;
    AC(57,[71,78,26,30]) = 1; %26,30 > 56,58
    AC(58,[59,71,31,27]) = 1;
    AC(59,[58,60,53]) = 1; %-31
    AC(60,[59,28,31,72]) = 1; %72>53
    AC(61,[4,1,32]) = 1; %-34
    AC(62,[8,2,33]) = 1; %-37
    AC(63,[74,4]) = 1; %-9,61
    AC(64,[70,8]) = 1; %-13,62
    AC(65,[72,28]) = 1; %-23,60
    AC(66,[77,24]) = 1; %-19,54
    AC(67,[77,79,73,29]) = 1;
    AC(68,[79,72,73,31]) = 1;
    AC(69,[1,2,3]) = 1; %-32
    AC(70,[64,76,13]) = 1; %-18
    AC(71,[57,58,52]) = 1; %-59
    AC(72,[65,68,60]) = 1; %-28
    AC(73,[30,79,68,67]) = 1;
    AC(74,[63,75,9]) = 1; %-14
    AC(75,[74,14]) = 1; %-9,19
    AC(76,[70,18]) = 1; %-13,23
    AC(77,[66,67,54]) = 1; %-24
    AC(78,[57,56,51]) = 1; %-55
    AC(79,[73,68,67]) = 1; %-30
    
    eegchans = 1:43;
else
    error('unknown mode!');
end
if max(max(abs(AC-AC'))) > 0
    error('AC is not symmetric!');
end

% First step is to remove unwanted channels
chansout = setdiff(1:43,eegchans);
AC(chansout,:) = [];
AC(:,chansout) = [];

% Now we can renumber the channels
nchans = length(eegchans);
eegchans = 1:length(eegchans);

ntot = ntpts*nchans;
W = sparse(ntot,ntot);
for chan = 1:nchans
    % First step is to connect this electrode with all its neighboring
    % electrodes across all time
    currchan = chan + (0:(ntpts-1))*nchans;
    nbrchans = find(AC(:,chan));
    edgevals = AC(nbrchans,chan);
        
    currchan = repmat(currchan,length(nbrchans),1);
    nbrchans = repmat(nbrchans,1,ntpts) + repmat((0:(ntpts-1))*nchans,length(nbrchans),1);
    edgevals = repmat(edgevals,1,ntpts);
    
    winds = sub2ind(size(W),currchan(:),nbrchans(:));
    winds2 = sub2ind(size(W),nbrchans(:),currchan(:));
    
    W(winds) = edgevals(:);
    W(winds2) = edgevals(:);
    
    
    % Now we must connect this electrode with past and future time
    currchanprev = chan + (0:(ntpts-2))*nchans;
    currchan = chan + (1:(ntpts-1))*nchans;
    
    winds = sub2ind(size(W),currchanprev(:),currchan(:));
    winds2 = sub2ind(size(W),currchan(:),currchanprev(:));
    
    W(winds) = chantptedgeval;
    W(winds2) = chantptedgeval;
end    

% OK, now let's generate the Laplacian
if strcmp(lapmode,'standard')
    % Then L = D - W
    D = sum(W)';
    L = -W;
    L = spdiags(D,0,L);
elseif strcmp(lapmode,'normalized')
    % Then L = I - D^(-1/2)*W*D^(-1/2)
    Dnegsqrt = 1./sqrt(sum(W)');
    Dnegsqrt = spdiags(Dnegsqrt,0,ntot,ntot);
    
    L = spdiags(ones(ntot,1),0,ntot,ntot) - Dnegsqrt*W*Dnegsqrt;
elseif strcmp(lapmode,'row_stochastic')
    % Then L = I - D^(-1)*W
    
else
    error('Unknown lapmode');
end

if includeblankrowcol == 1
    L = [L,zeros(size(L,1),1);zeros(1,size(L,1)+1)];
end
