clear; close all; clc;

%%% load data - using optimal shift
data1 = data_process1(-0.31);
data2 = data_process2(-0.02);
data3 = data_process3(-0.16);

EPS = 1e-6;
%%% needed for plotting
tcost1 = data1.t(end)-.5; %time point to begin evaluating cost (not done in this script), but needed for plotting.
ID1 = find(data1.t_per<tcost1+EPS, 1, 'last' );
tp1 = data1.t_per(ID1);
ID1 = find(data1.t<tp1+EPS, 1, 'last' );

tcost2 = data2.t(end)-.5; %time point to begin evaluating cost - not done inthis script, but useful for plotting.
ID2 = find(data2.t_per<tcost2+EPS, 1, 'last' );
tp2 = data2.t_per(ID2);
ID2 = find(data2.t<tp2+EPS, 1, 'last' );

tcost3 = data3.t(end)-.5; %time point to begin evaluating cost - not done inthis script, but useful for plotting.
ID3 = find(data3.t_per<tcost3+EPS, 1, 'last' );
tp3 = data3.t_per(ID3);
ID3 = find(data3.t<tp3+EPS, 1, 'last' );

%%% plots

% complete data sets condidered in this study. Black vertical lines show
% where cost function is evaluated
figure(1);clf;
subplot(2,3,1)
h=plot(data1.t,data1.P,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Pressure (mmHg)');
xlim([tcost1 data1.t(end)])
%ylim([-30 170])
grid on;
subplot(2,3,2)
h=plot(data2.t,data2.P,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
%ylabel('Pressure (mmHg)');
xlim([tcost2 data2.t(end)])
%ylim([-30 170])
grid on;
subplot(2,3,3)
h=plot(data3.t,data3.P,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
%ylabel('Pressure (mmHg)');
xlim([tcost3 data3.t(end)])
ylim([0 150])
grid on;


subplot(2,3,4)
h=plot(data1.t,data1.V,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Volume (\muL)');
xlabel('Time (sec)')
xlim([tcost1 data1.t(end)])
ylim([150 500])
grid on;
subplot(2,3,5)
h=plot(data2.t,data2.V,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
%ylabel('Volume (\muL)');
xlabel('Time (sec)')
xlim([tcost2 data2.t(end)])
ylim([150 500])
grid on;
subplot(2,3,6)
h=plot(data3.t,data3.V,'r');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
xlabel('Time (sec)')
%ylabel('Volume (\muL)');
xlim([tcost3 data3.t(end)])
ylim([150 500])
grid on;

% portion of waveforms the cost function is evaluated over
figure(2);clf;
subplot(2,3,1)
h=plot(data1.t,data1.P,'r',[tcost1 tcost1],[0 150],'k');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Pressure (mmHg)');
%xlim([0 .5])
ylim([0 150])
grid on;
subplot(2,3,2)
h=plot(data2.t,data2.P,'r',[tcost2 tcost2],[0 150],'k');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
%ylabel('Pressure (mmHg)');
%xlim([0 .5])
ylim([0 150])
grid on;
subplot(2,3,3)
h=plot(data3.t,data3.P,'r',[tcost3 tcost3],[0 150],'k');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
%ylabel('Pressure (mmHg)');
%xlim([0 .5])
ylim([0 150])
grid on;


subplot(2,3,4)
h=plot(data1.t,data1.V,'r',[tcost1 tcost1],[150 550],'k');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
ylabel('Volume (\muL)');
xlabel('Time (sec)')
%xlim([0 .5])
ylim([150 550])
grid on;
subplot(2,3,5)
h=plot(data2.t,data2.V,'r',[tcost2 tcost2],[150 550],'k');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
%ylabel('Volume (\muL)');
xlabel('Time (sec)')
%xlim([0 .5])
ylim([150 550])
grid on;
subplot(2,3,6)
h=plot(data3.t,data3.V,'r',[tcost3 tcost3],[150 550],'k');
set(h,'Linewidth',2);
set(gca,'Fontsize',18);
xlabel('Time (sec)')
%ylabel('Volume (\muL)');
%xlim([0 .5])
ylim([150 550])
grid on;