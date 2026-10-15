function picture()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to output picture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

word_size = 18;
file ='./data/index.mat';
Index= cell2mat(struct2cell(load(file)));
file= strcat('./data/R2.mat');
    dev=cell2mat(struct2cell(load(file)));
    dev = round(dev,3);
color = ColorMatrix();
for j =1:5
A = load(strcat('./data/',num2str(j),'.dat'));
n = length(A(:,2));
filename = strcat('./Result_',num2str(j),'/','/data_','i=',num2str(Index(j)),'.dat');
B = load(filename);
C(j,:,:) = B(:,1:2);
data_1 = (B(1:20:(n+3)*20,1)+B(1:20:(n+3)*20,2))./1e6;

plot(1:n+3,data_1,'LineWidth',2,'Color',cell2mat(color(1,j+5)));
hold on
scatter(1:n, A(:,2),70,cell2mat(color(1,j+5)),'filled');
hold on
text(2.5,3500-250*j,strcat('R^2=',num2str(dev(j))),"Color",cell2mat(color(1,j+5)),'FontSize',word_size);
end

xlabel('Time (days)','FontSize',word_size);   
ylabel('Tumor volume (mm3)','FontSize',word_size);      
xlim([0,30]);
ylim([0,4000]);

text(10,3500,{'PBS'},'FontSize',word_size);
text(15,3750,{'Ad'},'FontSize',word_size);
text(20,3750,{'Ad/4-1BBL'},'FontSize',word_size);
text(22,2200,{'Ad/IL-12'},'FontSize',word_size);
text(20,1000,{'Ad/4-1BBL/IL-12'},'FontSize',word_size);

set(gca,'FontName','Arial');  % Set font name
set(gca,'FontSize',word_size)
print('-dpng','-r600','picture\picture_R2.png');
save("data/pic_R2.mat","C");

end