clear;
addpath ../sens
%%%
% this script implements the sturctured correlation analysis algorithm to
% determine an ideal subset of parameters to optimize. Needs a sensitivity
% matrix as an input.

% Ra Rs Rv Ela Esa Esv Elv Tsf Trf Emin Emax
% 1  2  3  4   5   6   7   8   9   10   11

load sens_nominal.mat %load sens matrix

INDMAP = [9 6 10 8 11 2 5 3 7 4 1]; %parameter indices ordered from most to least sensitive (Isens in .mat file)
INDMAP = [9 6 10 8 11 2 5 3 7]; %remove Ra(1) and Eao(4) a priori - very insensitive parameters
% INDMAP = [9 10 8 11 2 5 3 7]; %remove Esv(6) - correlated
% INDMAP = [9 10 8 11 2 5 7]; %remove Rv(3) - correlated and least sensitive
% INDMAP = [9 10 8 11 2 7]; %remove Esa(5) - correlated and least sensitive
% INDMAP = [9 10 8 11 2]; %remove Evc(7) - correlated and least sensitive - results in a good subset

INDMAP = [9 6 10 8 11 2 5 3]; %remove 7 (Elv)
INDMAP = [9 6 10 8 11 2 5]; %remove 3 (Rv) - dropped threshold to 0.7
INDMAP = [9 10 8 11 2 5]; %remove 6 (Esv) - dropped threshold to 0.7
%INDMAP = [9 10 8 11 2]; %remove 5 (Esa) - dropped threshold to 0.7

%INDMAP = [9 6 8 11 2 5]; %remove 10 (Emin) - dropped threshold to 0.7

S = sens(:,INDMAP); %extract subset of parametrs
[m,n] = size(S);

A  = S'*S;
Ai = inv(A);
D  = diag(Ai);

disp('condition number of A = transpose(S)S and S');
disp([ cond(A) cond(S) ] );

[a,b] = size(Ai);
r = zeros(a);
for i = 1:a
    for j = 1:b
        r(i,j)=Ai(i,j)/sqrt(Ai(i,i)*Ai(j,j)); % covariance matrix
    end
end

rn = triu(r,1); % extract upper triangular part of the matrix
[i,j] = find(abs(rn) > 0.85); % 


disp('correlated parameters');
for k = 1:length(i)
   disp([INDMAP(i(k)),INDMAP(j(k)),rn(i(k),j(k))]);
end