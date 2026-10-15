function solve()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to determine the ambiguity parameter values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sample  =  3000;                   % sample: Virtual patients number
pare    =  5;                      % pare: Model heterogeneity parameters number
t_start =  0;                       % t_start: Start time
h = 0.05;
t_end   =  30;                     % t_end: End time
Index = zeros(1,5);
Par = zeros(5,5);
global par

%% Parameter Sample

P = model_parameter(sample,pare);  
file_P='./data//model_parameter.mat';
save(file_P,'P');
addpath('../model');


% first

par.j = 1;
par.drug = 0;
path = strcat('Result_',num2str(par.j),'/');
x0 = initialzation();
parameter();
for i = 1:sample
par.r = P(i,1);
par.beta = 0;
par.c_k = 0;
par.c_T = 0;
par.c_A = 0;
RK4(t_start, h, t_end, x0,i,path);
end

[max_value,r,index] = R2(path);
Par(1,1) = r(1);
Index(1,par.j) = index;
R(par.j) = max_value;


% scond
par.j = 2;
par.drug = 1e10;
path = strcat('Result_',num2str(par.j),'/');
x0 = initialzation();
parameter();
for i = 1:sample
par.r = P(i,1);
par.beta = P(i,2);
par.c_k = 0;
par.c_T = 0;
par.c_A = 0;
RK4(t_start, h, t_end, x0,i,path);
end

[max_value,beta,index] = R2(path);
Par(2,1) = beta(1);
Par(2,2) = beta(2);
Index(1,par.j) = index;
R(par.j) = max_value;
% third

par.j = 3;
par.drug = 1e10;
path = strcat('Result_',num2str(par.j),'/');
x0 = initialzation();
parameter();
for i = 1:3000
par.r = P(i,1);
par.beta =P(i,2);
par.c_k = P(i,3);
par.c_T = P(i,4);
par.c_A = 0;
RK4(t_start, h, t_end, x0,i,path);
end

[max_value,c_1,index] = R2(path);
Par(3,1) = c_1(1);
Par(3,2) = c_1(2);
Par(3,3) = c_1(3);
Par(3,4) = c_1(4);
Index(1,par.j) = index;
R(par.j) = max_value;

% fourth

par.j = 4;
par.drug = 5e9;
path = strcat('Result_',num2str(par.j),'/');
x0 = initialzation();
parameter();
for i = 1:sample
par.r = P(i,1);
par.beta = P(i,2) ;
par.c_k = P(i,3);
par.c_T = 0;
par.c_A = P(i,5);
RK4(t_start, h, t_end, x0,i,path);
end

[max_value,c_2,index] = R2(path);
Par(4,1) = c_2(1);
Par(4,2) = c_2(2);
Par(4,3) = c_2(3);
Par(4,5) = c_2(5);
Index(1,par.j) = index;
R(par.j) = max_value;

% fifth

par.j = 5;
par.drug = 5e9;
path = strcat('Result_',num2str(par.j),'/');
x0 = initialzation();
parameter();
for i = 1:sample
par.r = P(i,1);
par.beta = P(i,2);
par.c_k = P(i,3);
par.c_T = P(i,4);
par.c_A = P(i,5);
RK4(t_start, h, t_end, x0,i,path);
end

[max_value,c_3,index] = R2(path);
Par(5,1) = c_3(1);
Par(5,2) = c_3(2);
Par(5,3) = c_3(3);
Par(5,4) = c_3(4);
Par(5,5) = c_3(5);
Index(1,par.j) = index;
R(par.j) = max_value;

file_Par='./data/Par.mat';
save(file_Par,'Par');

file_index='./data/index.mat';
save(file_index,'Index');

file_R='./data/R2.mat';
save(file_R,'R');


end