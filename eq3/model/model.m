function y = model(t,x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% model (basic)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set: parameter
global par 

%% Prestore: variable
m=length(x);
y=zeros(m,1);

%% Variable substitution


X = x(1);    T_h = x(2);    T_r= x(3); T_c = x(4);  T_1 = 2e7; T_8 = 1e7;

y(1) = par.beta_X * (1-X/par.G)*X - (par.eta_Th *T_h+par.eta_Tc *T_c+par.eta_D)*(1/(1+T_r/par.K_Tr))*X - par.d_x*X;
y(2) = par.beta_T_h * (1+X/(X+par.K_X))*T_1 - par.d_T_h*(1+par.lamda_T_r*(T_r/(par.K_ThTr+T_r)))*T_h;
y(3) = par.beta_T_r * (1+X/(X+par.K_X))*T_1 - par.d_T_r*T_r;
y(4) = par.beta_T_c * (1+X/(X+par.K_X))*T_8 - par.d_T_c*(1+par.lamda_T_r*(T_r/(par.K_TcTr+T_r)))*T_c ;


end
