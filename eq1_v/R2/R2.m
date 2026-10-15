function [max_value,p,max_index] = R2(path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to calculate the R-squared value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 global par 
A = load(strcat('data/',num2str(par.j),'.dat'));
PBS = A(:,2);
n = length(PBS);
for i = 1:3000
filename = strcat(path,'data_i=',num2str(i),'.dat');
B = load(filename);
data = (B(1:20:n*20,2)+B(1:20:n*20,3))./1e6;
dev(i) = calculate_R2(data,PBS);
end
[max_value, max_index] = max(dev);
disp(['max value is: ', num2str(max_value)]);
disp(['max index is: ', num2str(max_index)]);
file_P='./data//model_parameter.mat';
P = cell2mat(struct2cell(load(file_P)));
p = P(max_index,:);
disp(['The most suitable value: ', num2str(p)]);

end


function result = calculate_R2(simulation, real)
RSS = sum((real - simulation).^2); 
TSS = sum((real - mean(real)).^2); 
result = 1 - (RSS / TSS);
end