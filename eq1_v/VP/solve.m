function solve()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to calculate the generation of virtual mice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sample = 30000;
t_start = 0;
t_end = 40;
h = 0.05;
addpath('../model');
addpath('../R2/data');
path = strcat('Result/');
pare = 5;
global par 
par.j = 5;
par.drug = 5e9;
P = model_parameter_VP(sample,pare);  
file_P='./data/model_parameter.mat';
save(file_P,'P');

x0 = initialzation();
parameter_VP();

for i = 1:sample
    disp(i)
par.beta = P(i,1);
par.detal_V = P(i,2);
par.c_k= P(i,3);
par.c_T = P(i,4);
par.r    = P(i,5);
RK4(t_start, h, t_end, x0,i,path);
end
select();
Data_processing();
end












