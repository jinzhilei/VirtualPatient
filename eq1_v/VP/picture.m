function picture()
word_size = 18;
up= load(strcat('./data/1.dat'));
down = load(strcat('./data/2.dat'));
Ave = (up(:,2)+down(:,2))./2;
Up = up(:,2) - Ave;
Down = Ave - down(:,2);
file='./data/tumor.mat';
Tumor = cell2mat(struct2cell(load(file)));
file='./data/Number_VP_patients.mat';
A = cell2mat(struct2cell(load(file)));
n = length(Ave);
errorbar(1:n,Ave,Up, Down, 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 2);
hold on

for i =1:length(A)
    disp(i)
    plot(1:n+1,Tumor(1:20:(n+1)*20,i)./1e6);
    hold on
end
ylim([0,1000])
xlabel('Time(day)');
ylabel('Tumor volume (mm3)');
legend('data')
set(gca,'FontName','Arial');  % Set font name
set(gca,'FontSize',word_size)
print('-dpng','-r600','picture/VP_r.png')
end
