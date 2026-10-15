function solve()

sample = 10000;
t_start = 0;
t_end = 40;
h = 0.05;
addpath('../model');
addpath('../R2/data/');
path = strcat('./Result/');
pare = 5;
Drug = [1e5;1e5];
global par 
par.drug = Drug;
P = model_parameter_VP(sample,pare);  
file_P='./data/model_parameter.mat';
save(file_P,'P');

x0 = initialzation();
parameter_VP();

for i = 1:sample
    disp(i)
par.r = P(i,1);
par.c_t = P(i,2);
par.s_E= P(i,3);
par.mu_TB = P(i,4);
par.D_i = P(i,5);

RK4(t_start, h, t_end, x0,i,path);
end
select();
end