%%%
% This script runs optimizations of multiple distinct subsets. newlsq_v2 is
% an optimizer written by Tim Kelly (NCSU) - we implement the Levenberg -
% Marquardt algorithm. opt_wrap is also needed for this function to work -
% calls CVmodel (model cost function) in the directory above

addpath ..
global ALLPARS INDMAP 
tshift = .24;
data = data_process1(tshift);

%initial parameters and bounds
[x0,Init,low,hi] = load_global(data); % Function returning x0 (the log of the parameters), Init (the initial conditions), 
ALLPARS = x0;

%needed for CVmodel function
data.Init = Init;

%cell array of a bunch of subsets to to optimize
INDICES = {[ 6 8 11 2];       %Subset 1 include Esv
           [10 8 11 2];       %Subset 2 include Emin
           [10 8 11 2 5]};    %Subset 2 include Emin and Esa
           
%each iteration of this loop is a different optimization
for i = 1:3
    disp(['Subset #',num2str(i)])
    clear optx opthi optlow x xopt histout
    INDMAP = INDICES{i}; %parameters to optimize
    
    %parameters and bounds
    optx   = x0(INDMAP); 
    opthi  = hi(INDMAP);
    optlow = low(INDMAP);
    
    %optimizer settings
    maxiter = 30;                   % max number of iterations        
    mode    = 2;                    % Performs Levenberg-Marquart optimization
    nu0     = 2.d-1;                % Regularization parameter
    [xopt, histout] = newlsq_v2(optx,'opt_wrap',1.d-3,maxiter,mode,nu0,...
               opthi,optlow,data);
           
    %merging optimization results with fixed parameters       
    x = ALLPARS;                    % only optimized parameters
    x(INDMAP) = xopt;               % all parameters, including optimized one
    
    save(['opt',num2str(i),'.mat'])
    disp(['Final Cost: ',num2str(histout(end,2))])
end

%exit;