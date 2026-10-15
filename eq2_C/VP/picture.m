function picture()
up= load(strcat('./data/1.dat'));
down = load(strcat('./data/2.dat'));
day = [13,15,17,20];
Ave = (up(:,2)+down(:,2))./2;
Up = up(:,2) - Ave;
Down = Ave - down(:,2);
file='./data/Number_VP_patients.mat';
A = cell2mat(struct2cell(load(file)));
n = length(Ave);
figure(1)
for i =1:length(A)
    data = load(strcat('Result/data_i=',num2str(A(i)),'.dat'));
    errorbar(day,Ave,Up, Down, 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 2);
    hold on
    plot(1:22,(data([1:22]*20,3)+data([1:22]*20,4)+data([1:22]*20,5))*4/3*pi*1e-2^3);
    hold on
end
xlim([1,22]);
xlabel('Time(day)','FontSize',18);
ylabel('Tumor volume (mm3)','FontSize',18);
legend('data','Location','northwest','Fontsize',18)
set(gca,'FontName','Arial');  % Set font name
set(gca,'FontSize',18)
end