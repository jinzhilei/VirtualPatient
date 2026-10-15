function parameter_VP()

file ='../R2/data/Par.mat';
Par= cell2mat(struct2cell(load(file)));

global par 

par.alpha             = 3500;
par.detal_T          = 0.35;
par.detal_A          = 0.35;
par.p                    = 1;
par.detal_I  = 1;
par.c_A  = Par(5,5);


end













