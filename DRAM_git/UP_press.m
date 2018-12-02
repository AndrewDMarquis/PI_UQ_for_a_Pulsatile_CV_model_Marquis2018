%clear; close all; clc;
addpath mcmcstat
addpath ..
global ALLPARS INDMAP 
%uncertainty propogation for pressure data

tshift = -.16;
data = data_process3(tshift);

EPS = 1e-6;
tcost = data.t(end)-.5; %time point to begin evaluating cost
ID = find(data.t_per<tcost+EPS, 1, 'last' );
tp = data.t_per(ID);
ID = find(data.t<tp+EPS, 1, 'last' );

INDMAP = [2 8 9 10 11];
[ALLPARS, Init] = load_global(data);
data.Init = Init;
data.xdata = data.t(ID:end);

load('DRAM_shift-.16_3.mat','DDATA','chain','results','s2chain','Ncost')

burn = 10000;
s2chainP = s2chain(burn:end,1)*mean(data.PMax)^2;% rescale variance for UP
chain = chain(burn:end,:); %remove burn-in from chain
 
% outP = mcmcpred(results,chain,s2chainP,data,@presspred,20000); %UQ
% save('UP_press_3.mat')
% exit;

load('UP_press_3_reorder.mat','outP')
mcmcpredplot_custom(outP,1)
hold on
plot(data.t,data.P,'r','linewidth',2)
set(gca,'fontsize',18)
ylabel('Pressure (mmHg)')
xlabel('time (sec)')
xlim([tcost data.t(end)])
grid on