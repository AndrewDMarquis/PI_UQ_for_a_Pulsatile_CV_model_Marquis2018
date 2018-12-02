function Vout = volpred(data,pars)
global ALLPARS INDMAP

tpars = ALLPARS;
tpars(INDMAP) = pars;
[~, ~, ~, ~, ~, ~, Vout] = CVmodel(tpars,data);
end