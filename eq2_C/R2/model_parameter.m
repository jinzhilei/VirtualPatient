function A = model_parameter(sample,pare)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file utilizes Latin hypercube sampling to extract ambiguity parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P = [1e-4,1e-3;
    1e-4,1e-3;
    1e-4,1e-3;
    1e-3,1e-2];
A = latin_hypercube(sample, pare,P(:,1),P(:,2));
end


function [X, centers] = latin_hypercube(n, d, lb, ub)
    
     if nargin < 4
        error('Please provide lower bound lb and upper bound ub');
    end
    if length(lb) ~= d || length(ub) ~= d
        error('The length of lb and ub must be equal to dimension d');
    end
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


