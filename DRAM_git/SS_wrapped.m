function SS = SS_wrapped(pars, data)
%%%
% wrapper to merge parameter we want to sample from with all parameters
global ALLPARS INDMAP

tpars = ALLPARS;
tpars(INDMAP) = pars;

[~, ~, SS] = CVmodel(tpars,data);
% SS(1) = SSu(1)*mean(data.PMax)^2;
% SS(2) = SSu(2)*(mean(data.VMax)-mean(data.Vmin))^2;
end