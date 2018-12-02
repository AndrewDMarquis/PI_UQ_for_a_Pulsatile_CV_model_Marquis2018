clear; close all; clc;

load('RUNFILE_RECENT.mat')

%%% things needed for plotting
tcost = data.t(end)-.5; %time point to begin evaluating cost - not done in
% this script, but needed for plotting.
ID = find(data.t_per<tcost+EPS, 1, 'last' );
tp = data.t_per(ID);
ID = find(data.t<tp+EPS, 1, 'last' );
N = length(plvS(ID:end));

D0 = data_process1(0);  %data stuct w/o shifting


%%%plots
%illlustrating relative data shift
figure(1);
subplot(2,1,1)
h=plot(data.t(1:10:end),plvS(1:10:end),'b',data.t(1:10:end),data.P(1:10:end),'r',D0.t(1:10:end),D0.P(1:10:end),'k:');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Pressure (mmHg)');
legend('model', [num2str(tshift),' shift'],'original data')
xlim([0 1])
grid on;
subplot(2,1,2)
h=plot(data.t(1:10:end),VlvS(1:10:end),'b',data.t(1:10:end),data.V(1:10:end),'r',D0.t(1:10:end),D0.V(1:10:end),'k:');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Volume (\muL)');
xlabel('Time (sec)')
%legend('model', [num2str(tshift),' shift'],' original data')
xlim([0 1])
grid on;
print -depsc ShiftL.eps
figure(2);clf;
subplot(2,1,1)
h=plot(data.t(ID:end),paoS(ID:end),'k',data.t(ID:end),psaS(ID:end),'k:');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('pressure (mmHg)');
xlim([tcost data.t(end)])
legend('Aorta', 'Systemic Arteries')
grid on;
subplot(2,1,2)
h=plot(data.t(ID:end),psvS(ID:end),'k',data.t(ID:end),pvcS(ID:end),'k:');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('pressure (mmHg)');
legend('Systemic Veins','Vena Cava')
xlim([tcost data.t(end)])
grid on;


%pressure-volume loop
I = find(data.t <= 4, 1, 'last');
figure(3);clf;
h=plot(data.V(I:end),data.P(I:end),'r',VlvS(I:end),plvS(I:end),'b');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Pressure (mmHg)');
xlabel('Volume (\mul)')
legend('model','data')
ylim([-10 150])
grid on;

%"Wiggers diagram"
figure(4);
plot(data.t,[paoS' psaS' psvS' pvcS' plvS'],'linewidth',2)
grid on
legend('la','sa','sv','lv','lh')
xlim([15 16])

%%% freq UQ calculations
addpath SensitivityAnalysis %need access to sensitivity matrix
load sens_opt_1 sens  %load sensitivty matrix using optimized parameter values for data set 1
INDMAP = sort([9 10 8 11 2]); %vector of indicies denoted the subset of optimized parmeters 
S = sens(:,INDMAP); %total sens matrix - extract parameters we optimized
%remove log scale from sensitivites (dr/dln(theta) = theta*dr/dtheta)
for i = 1:length(INDMAP)
    S(:,i) = S(:,i)/pars(INDMAP(i));
end
Sp = S(1:N,:)*mean(data.PMax); %pressure sensitivity - rescale for UQ
Sv = S((N+1):end,:)*mean(data.VMax-data.Vmin); %volume sensitivity - rescale for UQ

%this loop performs all the calculations involving the sens matrix
VP = inv(Sp'*Sp);
VV = inv(Sv'*Sv);
ldp = zeros(1,N);
ldv = zeros(1,N);
for i = 1:N %iterate for each time stamp
   tempP = Sp(i,:); 
   tempV = Sv(i,:); %extract row from matrix for the given time stamp
   
   ldp(i) = tempP*VP*tempP'; %linear algebra magic
   ldv(i) = tempV*VV*tempV';
end

T = tinv(0.95,N); %student t-distribution cdf

rP    = (plvS(ID:end) -  data.P(ID:end)')'; %unscaled residuals
rV    = (VlvS(ID:end) -  data.V(ID:end)')';
sigP = sqrt(rP'*rP/(N-length(INDMAP))); %OLS variance estimate - pressure
sigV = sqrt(rV'*rV/(N-length(INDMAP))); %OLS variance estimate - volume

%+/- for each interval
conP = T*sigP*sqrt(ldp);
conV = T*sigV*sqrt(ldv);
predP = T*sigP*sqrt(1+ldp);
predV = T*sigP*sqrt(1+ldv);

% results from DRAM uncertinaty propogation
addpath DRAM %need access to data files with UQ results
addpath DRAM/mcmcstat %need access do some of the DRAM source code
load('UP_press_reorder.mat','outP') %load DRAM UQ results for pressure and volume data sets
load('UP_vol_reorder.mat','outV')

%%% UQ plot - showing both Bayesian and frequentist results
figure(5)
subplot(2,1,1)
mcmcpredplot(outP)
hold on
h = plot(data.t(ID:end),plvS(ID:end)+conP,'b--',data.t(ID:end),plvS(ID:end)-conP,'b--',...
    data.t(ID:end),plvS(ID:end)+predP,'g--',data.t(ID:end),plvS(ID:end)-predP,'g--',...
    data.t,data.P,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Pressure (mmHg)');
%legend('model','data')
xlim([tcost data.t(end)])
ylim([-30 170])
grid on;

subplot(2,1,2)
mcmcpredplot(outV)
hold on
h = plot(data.t(ID:end),VlvS(ID:end)+conV,'b--',data.t(ID:end),VlvS(ID:end)-conV,'b--',...
    data.t(ID:end),VlvS(ID:end)+predV,'g--',data.t(ID:end),VlvS(ID:end)-predV,'g--',...
    data.t,data.V,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Volume (\muL)');
xlabel('time (sec)')
%legend('model','data')
xlim([tcost data.t(end)])
ylim([150 500])
grid on;
