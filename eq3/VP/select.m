function select(sample)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Select VP data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set parameters

immune_number  = 3;
Data_range_min = zeros(1,immune_number);
Data_range_max = zeros(1,immune_number);
CellRatioSim   = zeros(sample,immune_number);
success        = ones(sample,1);
rng(42)
%% Step1: data calculation (log-transformation)

% load data

file='./VP_immune/VP_sample_immune.mat';
cell=cell2mat(struct2cell(load(file)));

% data extraction

CD4 = cell(1:sample,2);   CD8 = cell(1:sample,4);
Treg = cell(1:sample,3);  

% logarithmic transformation

CellRatioSim(:,1) = log(CD8./CD4);   CellRatioSim(:,2) = log(CD4./Treg);   CellRatioSim(:,3) = log(CD8./Treg);

%% Step 2. Select virtual patients

% Range limitation

file='./data/True_data_log.mat';
observed_variables=cell2mat(struct2cell(load(file)));

for i = 1:immune_number
    Data_range_min(i) = min(observed_variables(:,i));
    Data_range_max(i) = max(observed_variables(:,i));
end

% Extract range data

for i = 1:sample
    for j = 1:immune_number
        if CellRatioSim(i,j)<Data_range_min(j)
            success(i,1) =0;
        elseif CellRatioSim(i,j)>Data_range_max(j)
            success(i,1) =0;
        end
    end
end

% Patients with limited range

pred_PP = CellRatioSim(success==1,:);

% Select

Mdl = KDTreeSearcher(observed_variables,'BucketSize',1);
NumPoints=10;
[~,D] = knnsearch(Mdl,pred_PP,'K',NumPoints);
BallVolume = nsphereVolume(size(pred_PP,2),max(D,[],2));
Density = NumPoints./BallVolume;
Density = Density/numel(observed_variables); 

VPtree = KDTreeSearcher(pred_PP,'BucketSize',10);

Npts=6;
[~,DVPs] = knnsearch(VPtree,pred_PP,'K',Npts);
BallVolume2 = nsphereVolume(size(pred_PP,2),max(DVPs,[],2));
Density2 = Npts./BallVolume2;


ProbabilityofInclusion = Density./Density2;
runs=100;
fopt = @(p) OptimizeVPgeneration(p,ProbabilityofInclusion,pred_PP,runs,observed_variables);
%NumOfVPs
maxsf=1/max(ProbabilityofInclusion);

lower2 = 0;
upper2 = log10(maxsf);
options = optimoptions(@simulannealbnd,'TolFun',1e-15,'ReannealInterval',30000,'InitialTemperature',0.5,'MaxIter',1000,'Display','Iter','TemperatureFcn',@temperatureboltz,'AnnealingFcn', @annealingboltz,'AcceptanceFcn',@acceptancesa);
[k,~] = simulannealbnd(fopt,log10(maxsf),lower2,upper2,options);
disp(['optimal beta: ' num2str(10^k) ' (max: ' num2str(maxsf) ')'])

%% generate virtual population with optimal beta

logbeta = k;
[gof,newselection,pvalue]= OptimizeVPgeneration(logbeta,ProbabilityofInclusion,pred_PP,1,observed_variables);
disp(['goodness of fit: ' num2str(gof)])
disp(['p value: ' num2str(pvalue')])

%% prepare final virtual patient cohort

idx = find(success==1);
SampleLabel = idx(newselection==1);
% SampleLabel = SampleLabel(randperm(numel(SampleLabel),Num));
disp(length(SampleLabel))

file=['./VP_immune/','Number_VP_patients.mat'];
save(file,'SampleLabel');