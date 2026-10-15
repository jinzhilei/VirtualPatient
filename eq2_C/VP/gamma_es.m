function [a,b,median_value] = gamma_es(up,down)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to calculate the shape parameters of gamma distribution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initial_guess = [1, 100];  
obj_fun = @(x) objective(x,up,down);
optimal_params = fminsearch(obj_fun, initial_guess);

a = optimal_params(1);
b = optimal_params(2);
median_value = gaminv(0.5, a, b);
end

function err = objective(params,up,down)
    a = params(1); 
    b = params(2);  
    
    p1 = gamcdf(down, a, b) - 0.025;  
    p2 = (1 - gamcdf(up, a, b)) - 0.025;  
    
    err = p1^2 + p2^2;
end
