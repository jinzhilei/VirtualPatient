function y = model(t,x,h)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% model (basic)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set: parameter
global par 


%% Prestore: variable
m=length(x);
y=zeros(m,1);

%% Variable substitution

[u_b,v_t]=Drug(t,h);

D_b = x(1);    D_t = x(2);   E = x(3); T = x(4); 
y(1) = u_b - par.mu_BT * D_b + par.mu_TB*D_t - par.detla_D *D_b;
y(2) = v_t + par.D_i * T + par.mu_BT * D_b -par.mu_TB*D_t - par.detla_D *D_t;
y(3) = par.s_E + par.c*D_b - par.c_e*E*T-(par.r_am+par.detla_E)*E;
y(4) = par.r*T * (1-(T+E+D_t)/par.k)  - par.c_t*E*T;
end

function [u_b,v_t] = Drug(t,h)
global par 

d = 0;
c = 0;
if any(abs(t - [6 8 10]) < 1e-9)
    d = par.drug(1)/h;
    c = par.drug(2)/h;
end
u_b = d;
v_t = c;

end