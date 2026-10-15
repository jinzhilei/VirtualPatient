function sampleValues = model_parameter_select(sample,pare)

%% 1. 定义参数矩阵

file_index='./data/parameter.mat';
Par= cell2mat(struct2cell(load(file_index)));

% 状态数
numStates = size(Par, 2);

% 初始化采样位置（随机起点）
currentState = randi(numStates);
sampleValues = zeros(sample, pare);
samples = zeros(sample, 1);
for i =1:pare
% 存储样本状态索引

samples(1) = currentState;

%% 2. Metropolis-Hastings 采样（离散状态空间）
for t = 2:sample
    % 建议分布：随机跳到任意一个状态
    proposedState = randi(numStates);

    proposedValue = Par(2*i-1,proposedState);
    if proposedValue < 0
        samples(t) = currentState;
        continue
    end
    
    % 计算接受概率
    currentProb = Par(2*i, currentState);
    proposedProb = Par(2*i, proposedState);

    
    alpha = min(1, proposedProb / currentProb);
    
    % 接受或拒绝
    u = rand();
    if u <= alpha
        currentState = proposedState;
    end
    samples(t) = currentState;
end

%% 3. 将状态索引映射回参数值
sampleValues(:,i) = Par(2*i-1, samples);
end

end
