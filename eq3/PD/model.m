function y = model(t,x,beta_Th,beta_Tr,beta_Tc,d_Th,d_Tr,d_Tc,beta_X,G,eta_D,d_x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% QCIC model (basic)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set: parameter
global par 

parameter();
%% Prestore: variable
m=length(x);
y=zeros(m,1);

%% Variable substitution


X = x(1);    T_h = x(2);    T_r= x(3); T_c = x(4);  T_1 = 2e7; T_8 = 1e7;

y(1) = beta_X * (1-X/G)*X - (par.eta_Th *T_h+par.eta_Tc *T_c+eta_D)*(1/(1+T_r/par.K_Tr))*X - d_x*X;
y(2) = beta_Th * (1+X/(X+par.K_X))*T_1 - d_Th*(1+par.lamda_T_r*(T_r/(par.K_ThTr+T_r)))*T_h;
y(3) = beta_Tr * (1+X/(X+par.K_X))*T_1 - d_Tr*T_r;
y(4) = beta_Tc * (1+X/(X+par.K_X))*T_8 - d_Tc*(1+par.lamda_T_r*(T_r/(par.K_TcTr+T_r)))*T_c ;


end
