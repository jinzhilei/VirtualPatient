function Model_LHS()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script is used to calculate sensitivity analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set parameter

runs = 1000;
var = 5;

g=0.01;
t_start =  0;                      
h = 0.05;
t_end   =  30;          


global par
par.j = 5;
par.drug = 5e9;
% LHS MATRIX  %%
Parameter_settings_LHS()

alpha_LHS = LHS_Call(3e3, alphal, 4e3, 0 ,runs,'unif');
detal_I_LHS = LHS_Call(0, detal_I, 1.5, 0 ,runs,'unif');
detal_V_LHS = LHS_Call(1, detal_V, 4, 0 ,runs,'unif');
detal_T_LHS = LHS_Call(0, detal_T, 0.5, 0 ,runs,'unif');
detal_A_LHS = LHS_Call(0, detal_A, 0.5, 0 ,runs,'unif');
p_LHS = LHS_Call(0, p, 2, 0 ,runs,'unif');
r_LHS = LHS_Call(0, r, 1, 0 ,runs,'unif');
beta_LHS = LHS_Call(1e-4, betal, 1e-3, 0 ,runs,'unif');
c_k_LHS = LHS_Call(1e-7, c_k, 1e-6, 0 ,runs,'unif');
c_T_LHS = LHS_Call(1, c_T, 7, 0 ,runs,'unif');
c_A_LHS = LHS_Call(0, c_A, 7, 0 ,runs,'unif');

dummy_LHS=LHS_Call(1,1,1e1, 0 ,runs,'unif'); % dummy paramete

addpath('../model');
addpath('../R2');
% LHS MATRIX and PARAMETER LABELS

LHSmatrix=[alpha_LHS,detal_I_LHS,detal_V_LHS,detal_T_LHS,detal_A_LHS,...
    p_LHS,r_LHS,beta_LHS,c_k_LHS,c_T_LHS,c_A_LHS];
B = zeros(var,runs);
path = strcat('data_prcc/');
 x0 = initialzation();
for i=1:runs
   disp(i)
    par.alpha             = LHSmatrix(i,1);
    par.detal_I           = LHSmatrix(i,2);
    par.detal_V          = LHSmatrix(i,3);
    par.detal_T          = LHSmatrix(i,4);
    par.detal_A          = LHSmatrix(i,5);
    par.p                    = LHSmatrix(i,6);
    par.r                     = LHSmatrix(i,7);
    par.beta                = LHSmatrix(i,8);
    par.c_k                 = LHSmatrix(i,9);
    par.c_T                = LHSmatrix(i,10);
    par.c_A                = LHSmatrix(i,11);

    y = RK4(t_start, h, t_end, x0,i,path);

    % Save the outputs at ALL time points

    B(1,i) = y(1)+y(2);
    B(2,i) = y(3);
    B(3,i) = y(4);
    B(4,i) = y(5);
end

% Save the workspace
save ./data_prcc/Model_LHS.mat;

end
