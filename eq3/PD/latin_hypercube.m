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