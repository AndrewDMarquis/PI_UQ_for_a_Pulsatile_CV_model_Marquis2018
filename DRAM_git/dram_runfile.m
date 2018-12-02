%%%
% This file runs the DRAM optimizer - uses code original written by Haario
%%%

clear; close all; clc;
addpath mcmcstat   % files made by Haario - needed for DRAM
addpath ..         % base model files
addpath ../Optimization/shift % results from lev-mar optimizations

%these global variables are used to merge whatever paramters are being
%sampled with the parameters that are remaining fixed at their a priori
%value (SS_wrapped)
global  ALLPARS INDMAP ODE_TOL

tshift = -.31;
data = data_process1(tshift);

%initial model parameters and variance
%load('shift_-0.31.mat', 'x') %optimzitized parameters to use
[x0,Init,low,hi] = load_global(data);
x = x0;
data.Init = Init;
ODE_TOL = 1e-4; %reduce ODE tolerance to speed up DRAM - this is as low as we can go before ode15s is unable to solve the model


[~, ~, ~, S2, Ncost] = CVmodel(x,data);
% S2(1) = S2(1)*mean(data.PMax)^2;
% S2(2) = S2(2)*(mean(data.VMax)-mean(data.Vmin))^2;
% S2 is the normalized variance estimate for pressure and volume, Ncost is
% the number of data points used to when estimating the cost

%putting data in the DRAM struct (DDATA)
Vdata = data.V;
Pdata = data.P;
PV_data = [Vdata Pdata];

DDATA.P = data.P;
DDATA.V = data.V;
DDATA.t = data.t;
DDATA.t_per = data.t_per;
DDATA.xdata = data.t;
DDATA.ydata = PV_data;
DDATA.Init = Init;
DDATA.VMax = data.VMax;
DDATA.Vmin = data.Vmin;
DDATA.PMax = data.PMax;
% Haario's code will not run without particular inputs, this DDATA struct
% is one such example - needs xdata and ydata fields in particular for
% uncertainty propogation

% model pars
ALLPARS = x;

% IMPORTANT FOR THE CODE TO RUN:
%
% If you are going to remove parameters from 'param' by commenting them
% out, you need ro remove the corresponding indcies from 'INDMAP'
%
% Example:
% I comment out parameters 'Ra', and 'Esv'
% then you need to have 'INDMAP = [2 3 4 5 7 8 9 10 11];'

INDMAP = [2 8 9 10 11]; % indices of the parameters you want to sample from

params = {
    %{'Ra',  ALLPARS(1), low(1), hi(1)}
    {'Rs',  ALLPARS(2), low(2), hi(2)}
    %{'Rv',  ALLPARS(3), low(3), hi(3)}
    %{'Eao', ALLPARS(4), low(4), hi(4)}
    %{'Esa', ALLPARS(5), low(5), hi(5)}
    %{'Esv', ALLPARS(6), low(6), hi(6)}
    %{'Evc', ALLPARS(7), low(7), hi(7)}
    {'Tsf', ALLPARS(8), low(8), hi(8)}
    {'Trf', ALLPARS(9), low(9), hi(9)}
    {'Emin',ALLPARS(10),low(10),hi(10)}
    {'Emax',ALLPARS(11),low(11),hi(11)}
             };
    
% settings and options
model.ssfun      = @SS_wrapped; % sum of squares function
model.sigma2     = S2;
model.N          = [Ncost Ncost];

options.method      = 'dram'; % adaptation method (mh,am,dr,dram)
nsimu = 100000;
options.nsimu       = nsimu;  % # of simulations
options.updatesigma = 1;      % update error variance - this is necesary if you want to do uncertainty quantification, you need a parameter density for variance(s)
options.waitbar = 0;          % no waitbar

% DRAM
tic; 
results = [];
[results,chain,s2chain,sschain]=mcmcrun_displayprogress(model,DDATA,params,options,results,100);
time = toc/60/60;

save DRAM_-.31_1.mat
