%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script is used to read parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file ='../R2/data/Par.mat';
Par= cell2mat(struct2cell(load(file)));

alphal  = 3500;
detal_I  = 1;
detal_V  =  2.3;
detal_T  = 0.35;
detal_A  =  0.35;
p  = 1;
r  = Par(5,1);
betal  = Par(5,2);
c_k  = Par(5,3);
c_T  =Par(5,4);
c_A  = Par(5,5);



% Parameter Labels

PRCC_var={'$$\alpha$$' '$$\delta_{I}$$' '$$\delta_V$$' '$$\delta_T $$'...
     '$$\delta_A$$' '$$p$$' '$$r$$' '$$\beta$$'...
     '$$c_k$$' '$$c_T$$' '$$c_A$$'};% 
