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

u=Drug(t);

U = x(1);    I = x(2);   V = x(3); T = x(4); A = x(5);   
N = U + I + T+A; 
y(1) = par.r * U - par.beta * U* V / N -  par.c_k * I * U* T / N;
y(2) = par.beta * U* V /N - par.detal_I * I - par.c_k * I * I * T / N;
y(3) = u + par.alpha * par.detal_I * I -par.detal_V * V ;
y(4) = par.c_T * I + par.p * A  - par.detal_T * T;
y(5) = par.c_A * I - par.detal_A * A;
end

function u = Drug(t)
global par 
d = 0;
if any(abs(t - [0 2 4]) < 1e-9)
    d = par.drug;
end
u = d;
end