function [max_value,p,max_index] = R2()

A = load(strcat('./data/1.dat'));
PBS = A(:,2);
for i = 1:3000
filename = strcat('./Result/data_i=',num2str(i),'.dat');
B = load(filename);
data = (B([6,13,15,17,20]*20,3)+B([6,13,15,17,20]*20,4)+B([6,13,15,17,20]*20,5))*4/3*pi*1e-2^3;
dev(i) = calculate_R2(data,PBS);
end
[max_value, max_index] = max(dev);
disp(['max value is: ', num2str(max_value)]);
disp(['max index is: ', num2str(max_index)]);
file_P='./data/model_parameter.mat';
P = cell2mat(struct2cell(load(file_P)));
p = P(max_index,:);
disp(['The most suitable value: ', num2str(p)]);

end


function result = calculate_R2(simulation, real)
RSS = sum((real - simulation).^2); 
TSS = sum((real - mean(real)).^2); 
result = 1 - (RSS / TSS);
end