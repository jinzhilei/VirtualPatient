function picture_line()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot: Time courses of the selected virtual patients (no drug)
%%%%        Tumor burden and immune-cell ratios, median + IQR band
%%%%        （为便于单独重绘图，此处按入选参数重新积分，
%%%%          不依赖 main_VP.m 并行阶段的 VP_parallel 临时文件）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set parameters

t_start = 1;
t_end   = 300;
word_size = 12;
color = ColorMatrix();

%% Load the selected virtual patients and their sampled parameters

file = './VP_immune/Number_VP_patients.mat';
Index = cell2mat(struct2cell(load(file)));
file = './VP_immune/VP_model_parameter.mat';
M = cell2mat(struct2cell(load(file)));

n = numel(Index);
fprintf('picture_line: re-simulating %d selected virtual patients ...\n', n);

%% Re-simulate the selected cohort
% M 列顺序（与 main_VP.m 一致）: beta_Th, beta_Tr, beta_Tc, d_Th, d_Tr, d_Tc
% 模型变量 x = [X; T_h; T_r; T_c]，其中 T_h=CD4, T_r=Treg, T_c=CD8

x0 = initialzation();
X   = zeros(n, t_end);
R18 = zeros(n, t_end);
R4  = zeros(n, t_end);
R8  = zeros(n, t_end);

for i = 1:n
    if i == 1 || mod(i,100) == 0
        fprintf('  VP %d / %d\n', i, n);
    end
    p = M(Index(i),:);
    [~, x] = ode45(@(t,x) model(t,x,p(1),p(2),p(3),p(4),p(5),p(6)),...
                   t_start:1:t_end, x0);
    X(i,:)   = x(:,1)';
    R18(i,:) = log(x(:,4)./x(:,2))';   % CD8/CD4
    R4(i,:)  = log(x(:,2)./x(:,3))';   % CD4/Treg
    R8(i,:)  = log(x(:,4)./x(:,3))';   % CD8/Treg
end

t = t_start:t_end;

%% Plot

figure(1)

% ---- tumor burden (log scale) ----
subplot(1,2,1)
medX = median(X,1);
q1X  = quantile(X,0.25,1);
q3X  = quantile(X,0.75,1);
fill([t, fliplr(t)], [q1X, fliplr(q3X)], cell2mat(color(7,1)),...
    'EdgeColor','none','FaceAlpha',0.5);
hold on
plot(t, medX, 'LineWidth', 2, 'Color', cell2mat(color(3,1)));
set(gca,'YScale','log')
grid on
xlabel('Time (day)','FontSize',word_size);
ylabel('Tumor burden (cell)','FontSize',word_size);
title('Tumor cells','FontSize',word_size);
legend('IQR','Median','Location','northwest','FontSize',word_size,'box','off');
set(gca,'FontName','Arial');
set(gca,'FontSize',word_size);

% ---- immune-cell ratios (log-transformed) ----
subplot(1,2,2)
R = {R18, R4, R8};
names = {'CD8/CD4','CD4/Treg','CD8/Treg'};
cc = {color(1,11), color(3,7), color(1,13)};
for k = 1:3
    medR = median(R{k},1);
    q1R  = quantile(R{k},0.25,1);
    q3R  = quantile(R{k},0.75,1);
    fill([t, fliplr(t)], [q1R, fliplr(q3R)], cell2mat(cc{k}),...
        'EdgeColor','none','FaceAlpha',0.15);
    hold on
    plot(t, medR, 'LineWidth', 2, 'Color', cell2mat(cc{k}));
end
grid on
xlabel('Time (day)','FontSize',word_size);
ylabel('Log-transformed ratio','FontSize',word_size);
title('Immune-cell ratios','FontSize',word_size);
legend(names,'Location','northwest','FontSize',word_size,'box','off');
set(gca,'FontName','Arial');
set(gca,'FontSize',word_size);

set(gcf,'unit','centimeters','position',[1 1 20 7]);
print('-dpng','-r600','picture/VP_line.png')

end
