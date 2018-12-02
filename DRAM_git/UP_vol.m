%clear; close all; clc;
addpath mcmcstat
addpath ..
global ALLPARS INDMAP 
%uncertainty propogation for volume data

tshift = -.02;
data = data_process2(tshift);

EPS = 1e-6;
tcost = data.t(end)-.5; %time point to begin evaluating cost
ID = find(data.t_per<tcost+EPS, 1, 'last' );
tp = data.t_per(ID);
ID = find(data.t<tp+EPS, 1, 'last' );

INDMAP = [2 8 9 10 11];
[ALLPARS, Init] = load_global(data);
data.Init = Init;
data.xdata = data.t(ID:end);

load('DRAM_shift-.02_2.mat','DDATA','chain','results','s2chain','Ncost')

burn = 10000;
s2chainV = s2chain(burn:end,2)*((mean(data.VMax)-mean(data.Vmin)))^2;% rescale variance for UP
chain = chain(burn:end,:); %remove burn-in from chain
 
% outV = mcmcpred(results,chain,s2chainV,data,@volpred,20000); %UQ
% save('UP_vol_3.mat')
% exit;

load('UP_vol_2_reorder.mat','outV')
mcmcpredplot_custom(outV,1)
hold on
plot(data.t,data.V,'r','linewidth',2)
xlim([tcost data.t(end)])