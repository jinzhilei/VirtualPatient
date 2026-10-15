%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to perform parameter calibration for virtual patients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Variable Name Set

sample  = 10000;                    % sample: Virtual patients number
r       = 100;                      % r: Beta distribution parameter groups
pare    = 6;                        % pare: Model heterogeneity parameters number
para    = 4;
t_start = 1;
t_end   = 84;

%% -------- Pre-generate r groups of Beta parameters via LHS --------
% For each of the r iterations, we need 4 (alpha,beta) pairs:
% one pair for each tumor parameter (beta_X, G, eta_D, d_X)
% alpha, beta both lie in [0.1, 10]

ab_lb = 0.1;
ab_ub = 10.0;

% Use Latin Hypercube Sampling to draw r*4 pairs of (alpha,beta)
ab_samples = latin_hypercube(r*4, 2, [ab_lb, ab_lb], [ab_ub, ab_ub]);

% Reshape into (r, 4, 2): AB(j,i,:) = [alpha, beta] of parameter i in group j
AB = reshape(ab_samples, [r, 4, 2]);

% Save the Beta-parameter table for later analysis
save('./data/beta_params.mat', 'AB');

%% Parameter Sample

M = model_parameter_select(sample, pare);
file_M = './data/VP_model_parameter_select.mat';
save(file_M, 'M');

CPSP = zeros(r, 4);
rng(42)
    %% -------- Parallel Computing and Simulation Calculation --------
    delete(gcp('nocreate'))         % Close the current parallel computing pool
    parpool(20);                    % Create a parallel pool
for j = 1:r
    disp(j)

    % -------- Generate S using j-th group of Beta parameters --------
    ab_j = squeeze(AB(j,:,:));      % 4x2 matrix, ab_j(i,:) = [alpha_i, beta_i]
    S = model_parameter(sample, ab_j);
    file_S = strcat('./data/VP_model_parameter', num2str(j), '.mat');
    save(file_S, 'S');


    parfor i = 1:sample
        beta_Th = M(i,1); beta_Tr = M(i,2); beta_Tc = M(i,3);
        d_Th    = M(i,4); d_Tr    = M(i,5); d_Tc    = M(i,6);
        beta_X  = S(i,1); G       = S(i,2); eta_D   = S(i,3); d_X = S(i,4);

        main_parallel(i, t_start, t_end, ...
                      beta_Th, beta_Tr, beta_Tc, d_Th, d_Tr, d_Tc, ...
                      beta_X, G, eta_D, d_X);
    end

    CPSP(j,:) = counts(sample);
end

file_CPSP = './data/CPSP.mat';
save(file_CPSP, 'CPSP');

%% -------- Find the best Beta parameter group --------
p = select_dan();
picture_bar_error(p);

% (The rest of your plotting / analysis code)
% p = select_dan();
% picture();
% picture_bar_error();