clear;
%%%
% this script implements the sturctured correlation analysis algorithm to
% determine an ideal subset of parameters to optimize. Needs a sensitivity
% matrix as an input.

% Ra Rs Rv Ela Esa Esv Elv Tsf Trf Emin Emax
% 1  2  3  4   5   6   7   8   9   10   11

%I sens 1: 9 6 10 8 11 2 5 3 7 4 1
load sens_nominal_1.mat %load sens matrix

INDMAP = [9 6 10 8 11 2 5 3 7 4 1]; %parameter indices ordered from most to least sensitive (Isens in .mat file)
INDMAP = [9 6 10 8 11 2 5];         %remove Ra(1) and Eao(4) a priori - very insensitive parameters
                                    %remove Rv(3) and Elv(7) upper body
                                    %parameters fixed
%correlation (10 6)          
%Remove 6
INDMAP = [9 10 8 11 2 5];          %Remove Emin(10) or Esv(6) either gives a subset
%correlation (10,5)
INDMAP = [9 10 8 11 2];            %Remove Esa(5) 

%Remove 10
INDMAP = [9 6 8 11 2 5];           %Remove Emin(10) or Esv(6) either gives a subset
%correlation (6,5)
INDMAP = [9 6 8 11 2];             %Remove Esa(5) 

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
[i,j] = find(abs(rn) > 0.8); % 


disp('correlated parameters');
for k = 1:length(i)
   disp([INDMAP(i(k)),INDMAP(j(k)),rn(i(k),j(k))]);
end