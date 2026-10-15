function Data_processing()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to process the results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


file='./data//Number_VP_patients.mat';
A = cell2mat(struct2cell(load(file)));
n = length(A);
for i =1:n
data = load(strcat('Result/data_i=',num2str(A(i)),'.dat'));
D(:,i)= data(:,2)+data(:,3);
end
save('./data/tumor',"D");

end