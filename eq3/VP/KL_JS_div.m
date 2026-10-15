function  KL_JS_div()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% calculate: divergence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set parameter

score_KL = zeros(3,1);
score_JS = zeros(3,1);

%% Loda data
file = ['./VP_immune/','Number_VP_patients.mat'];
number=cell2mat(struct2cell(load(file)));
file=['./VP_immune/','VP_sample_immune.mat'];
A=cell2mat(struct2cell(load(file)));
CD4 = A(number,2) ;
CD8 = A(number,4);
Treg = A(number,3);
B(:,1) = CD8./CD4;
B(:,2) = CD4./Treg;
B(:,3) = CD8./Treg;
B = log(B);

%% Load the ksdensity of the true data
% PDF: odd rows = evaluation grids (xi), even rows = densities of the real data
file = './data/True_data_ksdensity.mat';
PDF=cell2mat(struct2cell(load(file)));

%% Estimate the VP densities ON THE SAME grids as the real data
% ksdensity 的默认网格由各自数据的 [min,max] 生成（等距 100 点），
% 真实数据与 VP 样本的网格起点/终点/间距均不同，逐点配对等于把
% 不同 x 位置上的密度值相除。此处显式传入真实数据的固定网格，
% 保证两个密度在同一套网格点上计算。
for d = 1:3
    xi_d = PDF(2*d-1,:);                  % fixed grid from the real data
    PDF_VP(2*d-1,:) = xi_d;
    PDF_VP(2*d,:)   = ksdensity(B(:,d), xi_d);
end

PDF_P = PDF_VP;
for i = 2:2:6
    xi = PDF(i-1,:);                      % common fixed grid
    % real / VP densities, normalized so that the integral equals 1
    q = PDF(i,:);   q = q./trapz(xi,q);   % real data
    p = PDF_P(i,:); p = p./trapz(xi,p);   % virtual patients
    m = (p+q)/2;
    % Compute Kullback-Leibler Divergence  D(real || VP)
    score_KL(i/2) = trapz(xi, q.*log((q+eps)./(p+eps)));
    % Compute Jensen-Shannon Divergence
    score_JS(i/2) = 0.5*trapz(xi, q.*log((q+eps)./(m+eps))) ...
                  + 0.5*trapz(xi, p.*log((p+eps)./(m+eps)));
end

%% Save data
file='./VP_immune/score_KL.mat';
save(file,'score_KL');
file='./VP_immune/score_JS.mat';
save(file,'score_JS');
file='./VP_immune/PDF_VP.mat';
save(file,'PDF_VP');

end
