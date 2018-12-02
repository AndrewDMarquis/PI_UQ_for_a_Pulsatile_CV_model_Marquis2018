function Pout = presspred(data,pars)
global ALLPARS INDMAP

tpars = ALLPARS;
tpars(INDMAP) = pars;
[~, ~, ~, ~, ~, Pout] = CVmodel(tpars,data);
end