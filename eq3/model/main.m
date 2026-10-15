function main()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% model main program (basic)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set: time step
t_start = 0;
t_end = 365;
h = 1;

%% Set: system initialization values
parameter();
x0=initialzation();   
path = strcat('./data/');
i = 1;
%% Calculation:  model by funct ion ode45
 x = RK4(t_start, h, t_end, x0,i,path);

%% Storage: numerical results
file = './data/cell.mat';
save(file,'x');

%% Plot: cells and cytokines curve
picture()

end