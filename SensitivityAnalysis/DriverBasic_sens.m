clear all; close all;
addpath ..
addpath ../Optimization/shift
%%%
% This function script time varying local parameter sensitivites of the
% model. senseq is a function originally written by Tim Kelly (NCSU) that
% calculates a forward finite difference approximation.

tshift = -.31;
data = data_process(tshift);
load('shift_-0.31.mat', 'x') %optimzatized parameters to use

%To run with nominal parameter values
[x0,Init] = load_global(data); % Function returning x0 (the log of the parameters), Init (the initial conditions), 
data.Init = Init;

%senseq finds the non-weighted sensitivities
[sens,y] = senseq(x0,data);

save sens_nominal_1.mat