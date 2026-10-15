function picture_VP_NoDrug()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot: Plausible virtual patients
%%%%        Full simulated population (no drug, before selection)
%%%%        vs the immunogenomic (clinical) data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set parameters

bin_number = 20;
lengthe = 7;
hight = 5;
word_size = 6.5;
fitting_size = 8;
color = ColorMatrix();

%% Load the full simulated population (30000 x 4: X, T_h, T_r, T_c)

file = './VP_immune/VP_sample_immune.mat';
A = cell2mat(struct2cell(load(file)));
CD4  = A(:,2);
Treg = A(:,3);
CD8  = A(:,4);
S(:,1) = log(CD8./CD4);
S(:,2) = log(CD4./Treg);
S(:,3) = log(CD8./Treg);

%% Load the ksdensity of the true (immunogenomic) data
% PDF: odd rows = evaluation grids (xi), even rows = densities of the real data

file = './data/True_data_ksdensity.mat';
PDF = cell2mat(struct2cell(load(file)));

%% Plot

titles  = {'CD8/CD4','CD4/Treg','CD8/Treg'};
xlabels = {'Log-transformed CD8/CD4 Ratio', ...
           'Log-transformed CD4/Treg Ratio', ...
           'Log-transformed CD8/Treg Ratio'};
fnames  = {'VPNoDrugCD8CD4.png','VPNoDrugCD4Treg.png','VPNoDrugCD8Treg.png'};

for k = 1:3
    figure(k)

    Histogram = histogram(S(:,k),'FaceAlpha',0.5,'Normalization','pdf');
    Histogram.NumBins = bin_number;
    Histogram.FaceColor = cell2mat(color(7,1));
    hold on
    plot(PDF(2*k-1,:), PDF(2*k,:), 'LineWidth', 2, 'Color', cell2mat(color(3,1)))
    grid on

    set(gca,'Linewidth',1);   % Set outer border
    set(gca,'FontSize',word_size);   % Set font size
    set(gca,'FontName','Arial');  % Set font name
    xlabel(xlabels{k}); % Set Xlabel
    ylabel('Density'); % Set Ylabel
    title(titles{k},'FontSize',word_size);
    legend('Simulated population','Immunogenomic data',...
        'Location','northwest','FontSize',word_size,'box','off'); % Set legend
    set(gcf,'unit','centimeters','position',[1 1 lengthe hight]);
    print('-dpng','-r600',['picture/',fnames{k}])
    close(gcf)

end

end
