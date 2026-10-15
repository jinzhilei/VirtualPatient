function picture()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to output picture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

word_size = 20;
file ='./data/index.mat';
Index= cell2mat(struct2cell(load(file)));
color = ColorMatrix();
A = load(strcat('./data/1.dat'));
filename = strcat('./Result/data_','i=',num2str(Index(1)),'.dat');
B = load(filename);
data_1 = (B(1:20:(23)*20,3)+B(1:20:(23)*20,4)+B(1:20:(23)*20,5))*4/3*pi*1e-2^3;

figure(1)
plot(1:23,data_1,'LineWidth',2,'Color',cell2mat(color(1,4)));
hold on
scatter([6,13,15,17,20], A(:,2),70,cell2mat(color(1,4)),'filled');

xlabel('Time (days)','FontSize',word_size);   
ylabel('Tumor volume (mm3)','FontSize',word_size);      
text(2.5,2200,strcat('R^2=',num2str(round(Index(2),3))),"Color",cell2mat(color(1,4)),"FontSize",word_size);
xlim([1,30]);
ylim([0,3000]);
set(gca,'FontName','Arial'); 
set(gca,'FontSize',word_size)

print('-dpng','-r600','picture\picture_R2.png');

end