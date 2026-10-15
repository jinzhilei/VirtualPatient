function A = model_parameter(sample,pare)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file utilizes Latin hypercube sampling to extract ambiguity parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

P = [0.1,1;
    1e-4,1.5e-3;
    1e-8,5e-7;
    1,5;
    0.1,4];
A = latin_hypercube(sample, pare,P(:,1),P(:,2));
end


function [X, centers] = latin_hypercube(n, d, lb, ub)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file utilizes Latin hypercube sampling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


