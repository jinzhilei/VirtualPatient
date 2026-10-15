function picture_select()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot: Patient virtual data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set parameters

bin_number = 20;
lengthe = 7;
hight = 5;
word_size = 6.5;
fitting_size = 8;
color = ColorMatrix();

file = ['./VP_immune/','score_JS.mat'];
JS=cell2mat(struct2cell(load(file)));
file = ['./VP_immune/','score_KL.mat'];
KL=cell2mat(struct2cell(load(file)));

file = ['./VP_immune/','Number_VP_patients.mat'];
number=cell2mat(struct2cell(load(file)));
c= length(number);
B = zeros(c,3);
file=['./VP_immune/','VP_sample_immune.mat'];
A=cell2mat(struct2cell(load(file)));
B = log(B);
for i = 1:c
    CD4 = A(number(i),2);
    CD8 = A(number(i),4);
    Treg = A(number(i),3);
    B(i,1) = CD8/CD4;
    B(i,2) = CD4/Treg;
    B(i,3) = CD8/Treg;
end
B = log(B);

file = './data/True_data_ksdensity.mat';
PDF=cell2mat(struct2cell(load(file)));

% 提取数据列
vector_data_CD8CD4 = PDF(1,:);
PDF_CD8CD4 = PDF(2,:); 
vector_data_CD4Treg = PDF(3,:);
PDF_CD4Treg = PDF(4,:);
vector_data_CD8Treg = PDF(5,:);
PDF_CD8Treg = PDF(6,:);

%% Plot
%CD8/CD4
figure(4)

Histogram_CD8CD4 = histogram(B(:,1),'FaceAlpha',0.5,'Normalization','pdf');
Histogram_CD8CD4.NumBins = bin_number;
hold on
text(-5.25,0.35,['JS: ',num2str(JS(1),'%.4f')],'FontSize',fitting_size,'FontName','Airal','FontWeight','bold');
text(-5.25,0.25,['KL: ',num2str(KL(1),'%.4f')],'FontSize',fitting_size,'FontName','Airal','FontWeight','bold');
Histogram_CD8CD4.FaceColor = cell2mat(color(7,1));
hold on
plot(vector_data_CD8CD4,PDF_CD8CD4,'LineWidth',2,'Color',cell2mat(color(3,1)))
grid on
% Output image setting

set(gca,'XLim',[-6 4]);   % Set coordinate range (X)
% set(gca,'YLim',[0 0.7]);  % Set coordinate range (Y)
set(gca,'Linewidth',1);   % Set outer border
set(gca,'FontSize',word_size);   % Set font size
set(gca,'FontName','Airal');  % Set font name
xlabel('Log-transformed CD8/CD4 Ratio'); % Set Xlabel
ylabel('Density'); % Set Ylabel
title('CD8/CD4','FontSize',word_size);
legend('VP data','Immunogenomic data','Location','northwest','FontSize',word_size,'box','off'); % Set legend
set(gcf,'unit','centimeters','position',[1 1 lengthe hight]); 
print('-dpng','-r600','picture\VPCD8CD4.png')

% CD4/Treg
figure(5)

Histogram_CD4Treg = histogram(B(:,2),'FaceAlpha',0.5,'Normalization','pdf');
Histogram_CD4Treg.NumBins = bin_number;
hold on
text(-3.25,0.35/0.7*0.6,['JS: ',num2str(JS(2),'%.4f')],'FontSize',fitting_size,'FontName','Airal','FontWeight','bold');
text(-3.25,0.25/0.7*0.6,['KL: ',num2str(KL(2),'%.4f')],'FontSize',fitting_size,'FontName','Airal','FontWeight','bold');
Histogram_CD4Treg.FaceColor = cell2mat(color(7,1));
hold on
plot(vector_data_CD4Treg,PDF_CD4Treg,'LineWidth',2,'Color',cell2mat(color(3,1)))
grid on
% Output image setting

% set(gca,'XLim',[-3 5]);   % Set coordinate range (X)
% set(gca,'YLim',[0 0.6]);  % Set coordinate range (Y)
set(gca,'Linewidth',1);   % Set outer border
set(gca,'FontSize',word_size);   % Set font size
set(gca,'FontName','Airal');  % Set font name
xlabel('Log-transformed CD4/Treg Ratio'); % Set Xlabel
ylabel('Density'); % Set Ylabel
title('CD4/Treg','FontSize',word_size);
set(gcf,'unit','centimeters','position',[1 1 lengthe hight]); 
print('-dpng','-r600','picture\VPCD4Treg.png')

% Treg/M

figure(6)

Histogram_TregM = histogram(B(:,3),'FaceAlpha',0.5,'Normalization','pdf');
Histogram_TregM.NumBins = bin_number;
Histogram_TregM.FaceColor = cell2mat(color(7,1));
hold on
text(-5.25,0.35/0.7*0.6,['JS: ',num2str(JS(3),'%.4f')],'FontSize',fitting_size,'FontName','Airal','FontWeight','bold');
text(-5.25,0.25/0.7*0.6,['KL: ',num2str(KL(3),'%.4f')],'FontSize',fitting_size,'FontName','Airal','FontWeight','bold');
hold on
plot(vector_data_CD8Treg,PDF_CD8Treg,'LineWidth',2,'Color',cell2mat(color(3,1)))
grid on
% Output image setting

set(gca,'XLim',[-6 3]);   % Set coordinate range (X)
% set(gca,'YLim',[0 0.8]);  % Set coordinate range (Y)
set(gca,'Linewidth',1);   % Set outer border
set(gca,'FontSize',word_size);   % Set font size
set(gca,'FontName','Airal');  % Set font name
xlabel('Log-transformed CD8/Treg Ratio'); % Set Xlabel
ylabel('Density'); % Set Ylabel
title('CD8/Treg','FontSize',word_size);
set(gcf,'unit','centimeters','position',[1 1 lengthe hight]); 
print('-dpng','-r600','picture/VPCD8Treg.png')


end