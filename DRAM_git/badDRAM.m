
%clear; close all; clc;
addpath mcmcstat

% loading DRAM results. Make sure you are only loading one set of results.
load('DRAM_unident.mat','chain','results','INDMAP','s2chain','DDATA')
%results.names = {'R_{S}', 'T_s', 'E_{sa}', 'T_r', 'E_{min}', 'E_{Max}'};
results.limits = exp(results.limits);
chain = exp(chain);

burn = 12000;
p_chain = chain(burn:end,:); %"plot chain" - removing the burn in period from the parameter chain

figure(1);
mcmcplot(chain,[],results,'chainpanel');
figure(2);
plot(s2chain,'.')
figure(3);
mcmcplot(p_chain,[],results,'pairs');
figure(4);
mcmcplot(p_chain,[],results,'denspanel');
