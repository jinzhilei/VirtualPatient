
file ='../R2/data/Par.mat';
Par= cell2mat(struct2cell(load(file)));

 mu_TB             = 0.0011;
 detla_D           = 0.34;
 c_e          = 5.539e-14;
 r_am          = 0.002;
 detla_E      = 0.1155;
 r               = 0.39155;
 k               = 1e9;
 c_t             = 0.001;
 mu_BT     = Par(1);
 D_i          = Par(2);
 s_E          = Par(3);
 c          = Par(4);


% Parameter Labels

PRCC_var={'$$\mu_{TB}$$' '$$\delta_D$$' '$$c_e$$' '$$r_am $$'...
     '$$\delta_E$$' '$$r$$' '$$k$$' '$$c_t$$'...
     '$$ \mu_BT$$' '$$D_i$$' '$$s_E$$' '$$c$$'};% 
