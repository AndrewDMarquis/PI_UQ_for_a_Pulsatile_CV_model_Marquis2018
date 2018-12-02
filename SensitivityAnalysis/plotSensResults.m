clear; close all; clc;

load sens_nominal_1.mat

% ranked classical sensitivitiesd
[~,NS] = size(sens);
sens_norm = zeros(1,NS);
for i = 1:NS
  sens_norm(i)=norm(sens(:,i),2);
end
[Rsens,Isens] = sort(sens_norm,'descend');

pname = {'R_A','R_S','R_V','E_{ao}','E_{sa}','E_{sv}','E_{vc}','T_S','T_R','E_{min}','E_{Max}'};
npname{length(x0)} = [];
for j = 1:length(x0)
    npname{j} = pname{Isens(j)};
end

%ranked sensitivites
figure(1);
p = 1:11;
h = semilogy(p,Rsens./max(Rsens),'bx');
set(h,'linewidth',3);
set(h,'Markersize',15);
set(gca,'Fontsize',20);
set(gca,'XTick',p)
set(gca,'XTickLabel',npname)
ylabel('Sensitivites');
xlim([0 12]);
ylim([1e-2 1.2])
grid on;

%time varying sensitivites
%note that the first 557 elements of a colum in "sens" correspond to pressure
%sensitivity, and the final 557 elements of a column in "sens" correspond
%to volume sensitivity
figure(2);
plot(sens,'linewidth',2)
legend(pname)
grid on
