%%%
% for reasons beyond me, the struct mcmcpred returns for uncertainty
% propogation is not properly formatted - it contains the proper
% information, so this script simply reorganizes the cell arrays. Presumaby
% there is a better way for UP_press and UP_vol to be set up so that I
% don't have to do this yet here we are
%%%

load('UP_press_3.mat','outP')

N = size(outP.predlims{1},2);
X = zeros(N,3);
Y = X;
for i =1:N
    X(i,:) = outP.predlims{1}{i};
    Y(i,:) = outP.obslims{1}{i};
end

predlims{1}{1} = X';
obslims{1}{1}  = Y';


outP.predlims = predlims;
outP.obslims = obslims;
save('UP_press_3_reorder.mat','outP')