function solve()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to determine the ambiguity parameter values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sample  =  3000;                   % sample: Virtual patients number
pare    =  4;                      % pare: Model heterogeneity parameters number
t_start =  1;                       % t_start: Start time
h = 0.05;
t_end   =  30;                     % t_end: End time
Drug = [1e5;1e5];
Index = zeros(1,2);

global par

%% Parameter Sample
rng(123)
P = model_parameter(sample,pare);  
file_P='./data/model_parameter.mat';
save(file_P,'P');
addpath('../model');

% scond
par.drug = Drug;
path = strcat('./Result/');
x0 = initialzation();
parameter();
for i = 1:sample
par.mu_BT     = P(i,1);
par.D_i          = P(i,2);
par.s_E          = P(i,3);
par.c          = P(i,4);
RK4(t_start, h, t_end, x0,i,path);
end

[max_value,beta,index] = R2();
Par = beta;
Index(1) = index;
Index(2) = max_value;

file_Par='./data/Par.mat';
save(file_Par,'Par');

file_index='./data/index.mat';
save(file_index,'Index');



end