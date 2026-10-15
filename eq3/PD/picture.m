function picture(j)

z = 1000;
file = strcat('./data/VP_model_parameter',num2str(j),'.mat');
p=cell2mat(struct2cell(load(file)));
S = zeros(z,4);
S(:,1) = Beta_distribution(0.1,1,p(1,1),p(1,2),z);       % G_X1         %1.5e9
S(:,2) = Beta_distribution(1e12,1e14,p(2,1),p(2,2),z);      % \beta_X1     %0.15
S(:,3) = Beta_distribution(1e-4,1e-2,p(3,1),p(3,2),z);      % \d_X1       %0.04
S(:,4) = Beta_distribution(0.001,0.1,p(4,1),p(4,2),z);       % G_X2         %8e8
Xlabel = {'\beta_{X}' 'G' '\beta_{Tc}' '\eta_D' 'd_{X}'};
figure(1)

for i =1:4
    subplot(2,2,i)
    [y,x]=ksdensity(S(:,i));
    plot(x,y);
    xlabel(Xlabel(i));
    ax = gca;
    ax.TickLabelInterpreter='latex';
end

print('-dpng','-r600','picture\picture_par')
end

