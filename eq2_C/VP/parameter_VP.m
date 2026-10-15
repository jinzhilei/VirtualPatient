function parameter_VP()

file ='../R2/data//Par.mat';
Par= cell2mat(struct2cell(load(file)));

global par 

par.mu_BT     = Par(1);
par.c          = Par(4);
par.detla_D           = 0.34;
par.c_e          = 5.539e-14;
par.r_am          = 0.002;
par.detla_E      = 0.1155;
par.k               = 1e9;

end