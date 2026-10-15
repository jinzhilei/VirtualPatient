function picture_par()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_index='./data/Number_VP_patients.mat';
Index= cell2mat(struct2cell(load(file_index)));
file_par='./data/model_parameter.mat';
Par= cell2mat(struct2cell(load(file_par)));
color = ColorMatrix();
[~,n] = size(Par);
par = Par(Index,:);
alpha_value = 0.45;
F = [1 2 3 4];
Xlabel = {'r' '$$c_t$$' '$$s_E$$' '$$\mu_{TB}$$' '$$D_i$$'};
figure(1)

for i = 1:n
    subplot(2,3,i)
    [y,x]=ksdensity(par(:,i));
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
    xlabel(Xlabel(i),'Interpreter','latex');
    ax = gca;
    ax.TickLabelInterpreter='latex';
    set(gca,'FontSize',12); 
    set(gca,'FontName','Arial'); 
end
print('-dpng','-r600','picture\picture_par_r')
end