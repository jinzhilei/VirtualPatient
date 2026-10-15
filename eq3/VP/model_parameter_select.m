function sampleValues = model_parameter_select(sample,pare)

% parameter.mat 由 picture_par.m 生成并保存于 ./VP_immune/（与 PD 阶段口径一致）
file_index='./VP_immune/parameter.mat';
Par= cell2mat(struct2cell(load(file_index)));


numStates = size(Par, 2);

currentState = randi(numStates);
sampleValues = zeros(sample, pare);
samples = zeros(sample, 1);
for i =1:pare

samples(1) = currentState;

%% 2. Metropolis-Hastings 
for t = 2:sample
    proposedState = randi(numStates);
    
    currentProb = Par(2*i, currentState);
    proposedProb = Par(2*i, proposedState);
    
    alpha = min(1, proposedProb / currentProb);
    
    u = rand();
    if u <= alpha
        currentState = proposedState;
    end
    samples(t) = currentState;
end

sampleValues(:,i) = Par(2*i-1, samples);
end

end
