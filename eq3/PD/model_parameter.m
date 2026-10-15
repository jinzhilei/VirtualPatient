function S = model_parameter(z, ab)
% z  : number of samples
% ab : 4x2 matrix, ab(i,:) = [alpha, beta] for the i-th tumor parameter

S = zeros(z, 4);

% Parameter ranges (unchanged)
ranges = [0.1,   0.5;        % beta_X
          1e13,  1e14;       % G
          1e-3,  1e-1;       % eta_D
          0.01, 0.3];       % d_X

for i = 1:4
    a = ranges(i, 1);
    b = ranges(i, 2);
    alpha = ab(i, 1);
    beta_ = ab(i, 2);
    S(:, i) = a + (b - a) * betarnd(alpha, beta_, [1, z]);
end
end