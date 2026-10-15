
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to perform parameter calibration for virtual patients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Variable Name Set

sample  =  30000;                   % sample: Virtual patients number
pare    =  6;                      % pare: Model heterogeneity parameters number
t_start =  1;                       % t_start: Start time
t_end   =  300;                     % t_end: End time
var     =  4;                      % var: Variable number
cell    =  zeros(sample,var);       % cell: Virtual patient prestorage matrix

%% Parameter Sample

M = model_parameter(sample,pare);  
file_M='./VP_immune/VP_model_parameter.mat';
save(file_M,'M');

%% Parallel Computing and Simulation Calculation

delete (gcp('nocreate'))            % Close the current parallel computing pool
parpool(17);                         % Create a parallel pool

parfor i = 1:sample
    disp(i)

    beta_Th   = M(i,1); beta_Tr   = M(i,2); beta_Tc   = M(i,3);
    d_Th   = M(i,4); d_Tr   = M(i,5); d_Tc   = M(i,6);

    main_parallel(i,t_start,t_end,beta_Th,beta_Tr,beta_Tc,d_Th,d_Tr,d_Tc)

end

for i = 1:sample
    file = strcat('./VP_parallel/VP',num2str(i),'.mat');
    x=cell2mat(struct2cell(load(file)));
    cell(i,:) = x(t_end,:);
end

file=['./VP_immune/','VP_sample_immune.mat'];
save(file,'cell');


%% Plausible patients
picture_VP_NoDrug()
%% VP Sample

select(sample);

%% Calculate Divergence

KL_JS_div();

%% Plot

picture_select();
picture_line();


