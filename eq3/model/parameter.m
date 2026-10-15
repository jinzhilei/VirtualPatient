function parameter()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is a deterministic parameter set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global par 

%
par.beta_X = 0.3;
par.G = 1e13;
par.eta_Th = 1e-11;
par.eta_Tc = 1e-10;
par.eta_D = 0;
par.K_Tr = 2e8;
par.d_x = 0.04;
%

par.beta_T_h = 0.4;
par.K_X = 1e10;
par.d_T_h = 0.005;
par.K_ThTr = 1e8;
%

par.beta_T_r = 0.5;
par.d_T_r = 0.03;

par.beta_T_c = 0.3;
par.d_T_c = 0.001;
par.lamda_T_r = 0.8;
par.K_TcTr = 1e8;

end