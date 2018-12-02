clear; clc;
addpath shift
%%%
%this script processes the optimization results of 
%various data shifts - this ultimately a way in which we can circumvent
%estimating the initial conditions as parameters. shift folder contains the
%.mat files of the results from shift_opt.m

tshift = -.4:.01:.4;
N = length(tshift);

grad = zeros(1,N); %norm of gradient of cost
cost = grad;       %cost
for i = 1:N
   clear histout
   load(['shift_',num2str(tshift(i)),'_1.mat'], 'histout');
   grad(i) = histout(end,1);
   cost(i) = histout(end,2);
end

[scost, Ic] = sort(cost);
[sgrad, Ig] = sort(grad);

figure(2); clf;
subplot(2,1,1)
plot(tshift, grad, 'o', 'markersize',5,'linewidth',2)
set(gca, 'fontsize', 20)
ylabel('||\nablaJ(\theta)||')
grid on

subplot(2,1,2)
plot(tshift, cost, 'o', 'markersize',5,'linewidth',2)
hold on
plot(tshift(Ic(1)), scost(1),'rx', 'markersize',20,'linewidth',2)
set(gca, 'fontsize', 20)
xlabel('Relative data shift')
ylabel('J(\theta)')
grid on
