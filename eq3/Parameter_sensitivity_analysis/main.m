function main()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to calculate PRCC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set parameter

runs = 1000;
var = 4;

g=0.01;
t_start =  0;                       % t_start: Start time
h = 1;
t_end   =  365;
t_vec = t_start:h:t_end;
t_v = 100;
picture_width = 60;
picture_hight = 30;

global par
% LHS MATRIX  %%
Parameter_settings_LHS()

beta_X_LHS = LHS_Call(0.1,beta_X, 1, 0 ,runs,'unif');
G_LHS = LHS_Call(1e12, G, 1e14, 0 ,runs,'unif');
eta_Th_LHS = LHS_Call(1e-13, eta_Th, 1e-12, 0 ,runs,'unif');
eta_Tc_LHS = LHS_Call(1e-11, eta_Tc, 1e-9, 0 ,runs,'unif');
K_Tr_LHS = LHS_Call(1e8, K_Tr, 1e10, 0 ,runs,'unif');
d_x_LHS = LHS_Call(0.01, d_x, 0.1, 0 ,runs,'unif');
beta_T_h_LHS = LHS_Call(0, beta_T_h, 1, 0 ,runs,'unif');
K_X_LHS = LHS_Call(1e9, K_X, 1e11, 0 ,runs,'unif');
d_T_h_LHS = LHS_Call(0.001, d_T_h, 1, 0 ,runs,'unif');
K_ThTr_LHS = LHS_Call(1e9, K_ThTr, 1e11, 0 ,runs,'unif');
beta_T_r_LHS = LHS_Call(0, beta_T_r, 1, 0 ,runs,'unif');
d_T_r_LHS = LHS_Call(0.01, d_T_r, 1, 0 ,runs,'unif');
beta_T_c_LHS = LHS_Call(0, beta_T_c, 1, 0 ,runs,'unif');
d_T_c_LHS = LHS_Call(1e-4, d_T_c, 4e3, 1 ,runs,'unif');
lamda_T_r_LHS = LHS_Call(0.1, lamda_T_r, 1, 0 ,runs,'unif');
K_TcTr_LHS = LHS_Call(1e9, K_TcTr, 1e11, 0 ,runs,'unif');

dummy_LHS=LHS_Call(1,1,1e1, 0 ,runs,'unif'); % dummy paramete

addpath('../model/');

% LHS MATRIX and PARAMETER LABELS

LHSmatrix=[beta_X_LHS ,G_LHS,eta_Th_LHS,eta_Tc_LHS,K_Tr_LHS,d_x_LHS,...
    beta_T_h_LHS,K_X_LHS,d_T_h_LHS,K_ThTr_LHS,...
    beta_T_r_LHS,d_T_r_LHS,beta_T_c_LHS,d_T_c_LHS,lamda_T_r_LHS,...
    K_TcTr_LHS];
B = zeros(var,runs);
path = strcat('./data_prcc/');
x0 = initialzation();
for i=1:runs
    disp(i)

    par.beta_X = LHSmatrix(i,1);
    par.G = LHSmatrix(i,2);
    par.eta_Th = LHSmatrix(i,3);
    par.eta_Tc = LHSmatrix(i,4);
    par.K_Tr = LHSmatrix(i,5);
    par.d_x = LHSmatrix(i,6);
    par.beta_T_h = LHSmatrix(i,7);
    par.K_X = LHSmatrix(i,8);
    par.d_T_h = LHSmatrix(i,9);
    par.K_ThTr = LHSmatrix(i,10);
    par.beta_T_r = LHSmatrix(i,11);
    par.d_T_r = LHSmatrix(i,12);
    par.beta_T_c = LHSmatrix(i,13);
    par.d_T_c = LHSmatrix(i,14);
    par.lamda_T_r = LHSmatrix(i,15);
    par.K_TcTr = LHSmatrix(i,16);


    [~, y] = ode45(@(t,x) model(t,x), t_vec, x0);

    % Save the outputs at ALL time points

    B(1,i) = y(end,1);
    B(2,i) = y(end,2);
    B(3,i) = y(end,3);
    B(4,i) = y(end,4);
end

% Save the workspace
save ./data_prcc/Model_LHS.mat;


end
