
%clear; close all; clc;
addpath mcmcstat

% loading DRAM results. Make sure you are only loading one set of results.
load('DRAM_shift-.31_1.mat','chain','results','INDMAP','s2chain','DDATA')
results.names = {'R_{S}', 'T_s', 'T_r','E_{min}', 'E_{Max}'};
results.limits = exp(results.limits);
chain = exp(chain);

burn = 20000;
p_chain = chain(burn:end,:); %"plot chain" - removing the burn in period from the parameter chain

figure(1);
mcmcplot(chain,[],results,'chainpanel');
figure(2);
plot(s2chain,'.')
figure(3);
mcmcplot(p_chain,[],results,'pairs');
figure(4);
mcmcplot(p_chain,[],results,'denspanel');
subplot(3,2,1);
title('');
ylabel('Rs');
xlim([0.145 0.175]);
subplot(3,2,2);
title('');
xlim([0.435 0.4675]);
ylabel('Ts');
subplot(3,2,3);
title('');
ylabel('Tr');
subplot(3,2,4);
title('');
ylabel('Em');
subplot(3,2,5);
title('');
ylabel('EM');
