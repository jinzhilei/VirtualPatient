function parameter()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is a deterministic parameter set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global par 

P = [0 0 0 0 0 0;
    3500 1 2.3 0 0 0;
    3500 1 2.3 0.35 0 0;
    3500 1 2.3 0.35 0.35 1;
    3500 1 2.3 0.35 0.35 1];

par.alpha             = P(par.j,1);
par.detal_I           = P(par.j,2);
par.detal_V          = P(par.j,3);
par.detal_T          = P(par.j,4);
par.detal_A          = P(par.j,5);
par.p                    = P(par.j,6);

end