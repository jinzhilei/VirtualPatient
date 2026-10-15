function picture_bar_error(p) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


color = ColorMatrix();
color_size = [7,10,4,1];
alpha_value = 0.45;
F = [1 2 3 4];
file='./data/CPSP';
CPSP=cell2mat(struct2cell(load(file)));
CR_model = CPSP(p,4);
PR_model = CPSP(p,3);
SD_model = CPSP(p,2);
PD_model = CPSP(p,1);
data_up= [26.04,42.58,34.21,2.39];
data_down = [20.81,39.58,33.33,1.04];
data_ave = (data_up+data_down)/2;
CR_data = data_ave(4);
PR_data = data_ave(3);
SD_data = data_ave(2);
PD_data = data_ave(1);
CR_error_max = data_up(4)-CR_data;
CR_error_min = CR_data-data_down(4);
PR_error_max = data_up(3)-PR_data;
PR_error_min = PR_data-data_down(3);
SD_error_max = data_up(2)-SD_data;
SD_error_min = SD_data-data_down(2);
PD_error_max = data_up(1)-PD_data;
PD_error_min = PD_data-data_down(1);

Y = zeros(4,4);
Y(1,:) = [CR_model,CR_data,CR_error_max, CR_error_min];
Y(2,:) = [PR_model,PR_data,PR_error_max, PR_error_min];
Y(3,:) = [SD_model,SD_data,SD_error_max, SD_error_min];
Y(4,:) = [PD_model,PD_data,PD_error_max, PD_error_min];
for i =1:4
    for j = 1:4
str= sprintf('%.2g', Y(i,j));
Y(i, j) = str2double(str);
    end
end
name = {'CR','PR','SD','PD'};

figure(1)
for i = 1:4
subplot(2,4,i)
h = bar(Y(i,1:2),'FaceColor', 'flat');
hold on
errorbar(2,Y(i,2),Y(i,3), Y(i,4), 'LineStyle', 'none', 'Color', 'k', 'LineWidth', 2);
hold on
title(name(i))
for j = 1:2
text(j-0.25,75,[num2str(Y(i,j)),'%'],'FontSize', 12);
end
set(gca,'YLim',[0,100]);  % Set font name
h.CData(1,:) = cell2mat(color(1,color_size(i)));
h.CData(2,:) = cell2mat(color(7,color_size(i)));
set(gca,'FontSize',12); 
set(gca,'FontName','Arial'); 
ytickformat('percentage');
xticklabels({'Model','Data'});
end

file = strcat('./data/VP_model_parameter',num2str(p),'.mat');
S=cell2mat(struct2cell(load(file)));

Xlabel = {'\beta_{X}' 'G' '\eta_D' 'd_{X}'};
for i =1:4
    subplot(2,4,4+i)
    [y,x]=ksdensity(S(:,i));
    y_max = max(y);
    y_min = min(y);
    V_alpha = alpha_value*((y-y_min)/y_max);
    hold on
    for k = 1:numel(x)-1
        V = [ x(k) y_min; x(k) y(k);
            x(k+1) y(k+1); x(k+1) y_min ];
        A = [0, V_alpha(k), V_alpha(k+1), 0]';
        patch('Faces',F,'Vertices',V,'FaceColor',cell2mat(color(1,i+3)),...
            'EdgeColor','none',...
            'FaceVertexAlphaData',A,'FaceAlpha','interp',...
            'AlphaDataMapping','none');
    end
    hold on
    box on
    plot(x,y,'LineWidth',2,'Color',cell2mat(color(1,i+3)))
    xlabel(Xlabel(i));
    ax = gca;
    ax.TickLabelInterpreter='latex';
    set(gca,'FontSize',12); 
    set(gca,'FontName','Arial'); 
end

set(gcf,'unit','centimeters','position',[1 1 30 10]); 
print('-dpng','-r600','picture\Percentage_change_bar_error.png')

end