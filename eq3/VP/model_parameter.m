function A = model_parameter(sample,pare)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file utilizes Latin hypercube sampling to extract ambiguity parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P = [0.001,1;
    0.1,0.7;
    0.1,0.6;
    0.01,0.6;
    0.01,1;
    0.0001,0.5];
A = latin_hypercube(sample, pare,P(:,1),P(:,2));
end


function [X, centers] = latin_hypercube(n, d, lb, ub)
    
 
    X = zeros(n, d);
    centers = zeros(n, d);
    for i = 1:d
        interval_width = (ub(i) - lb(i)) / n;
        centers(:, i) = lb(i) + interval_width*(0.5 : n);
        perm = randperm(n);
        for j = 1:n
            X(j, i) = lb(i) + interval_width*(perm(j) - 1 + rand);
        end
    end
end


