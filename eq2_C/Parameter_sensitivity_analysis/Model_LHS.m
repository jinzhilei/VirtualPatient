function Model_LHS()

%% Set parameter

runs = 1000;
var = 5;

g=0.01;
t_start =  0;                       % t_start: Start time
h = 0.05;
t_end   =  30;


global par
par.j = 5;
par.drug = [1e5;1e5];   % model.m 的 Drug() 取 drug(1)/drug(2)，须为二元向量（与 R2/VP 阶段一致）
% LHS MATRIX  %%
Parameter_settings_LHS()

mu_TB_LHS             = LHS_Call(0, mu_TB,1, 0 ,runs,'unif');
detla_D_LHS           = LHS_Call(0, detla_D,1, 0 ,runs,'unif');
c_e_LHS          = LHS_Call(1e-14, c_e,1e-13, 0 ,runs,'unif');
r_am_LHS          = LHS_Call(0, r_am,0.1, 0 ,runs,'unif');
detla_E_LHS      = LHS_Call(0, detla_E,1, 0 ,runs,'unif');
r_LHS               = LHS_Call(0, r,1, 0 ,runs,'unif');
k_LHS               = LHS_Call(1e8, k,1e10, 0 ,runs,'unif');
c_t_LHS             = LHS_Call(0, c_t,0.1, 0 ,runs,'unif');
mu_BT_LHS     = LHS_Call(1e-4, mu_BT,1e-3, 0 ,runs,'unif');
D_i_LHS          = LHS_Call(1e-4, D_i,1e-3, 0 ,runs,'unif');
s_E_LHS          = LHS_Call(1e-4, s_E,1e-3, 0 ,runs,'unif');
c_LHS          = LHS_Call(1e-3, c,1e-2, 0 ,runs,'unif');

dummy_LHS=LHS_Call(1,1,1e1, 0 ,runs,'unif'); % dummy paramete

addpath('../model');
addpath('../R2');
% LHS MATRIX and PARAMETER LABELS

LHSmatrix=[mu_TB_LHS, detla_D_LHS, c_e_LHS, r_am_LHS,...
    detla_E_LHS,r_LHS, k_LHS, c_t_LHS,mu_BT_LHS, D_i_LHS,...
    s_E_LHS, c_LHS];
B = zeros(var,runs);
path = strcat('data_prcc/');
x0 = initialzation();
for i=1:runs
    disp(i)

    par.mu_TB             = LHSmatrix(i,1);
    par.detla_D           = LHSmatrix(i,2);
    par.c_e          = LHSmatrix(i,3);
    par.r_am          = LHSmatrix(i,4);
    par.detla_E      = LHSmatrix(i,5);
    par.r               = LHSmatrix(i,6);
    par.k               = LHSmatrix(i,7);
    par.c_t             = LHSmatrix(i,8);
    par.mu_BT     = LHSmatrix(i,9);
    par.D_i          = LHSmatrix(i,10);
    par.s_E          = LHSmatrix(i,11);
    par.c          = LHSmatrix(i,12);


    y = RK4(t_start, h, t_end, x0,i,path);

    % Save the outputs at ALL time points

    B(1,i) = y(1);
    B(2,i) = y(2);
    B(3,i) = y(3);
    B(4,i) = y(4);
end

% Save the workspace
save ./data_prcc/Model_LHS.mat;



end
