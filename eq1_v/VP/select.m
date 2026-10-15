function select()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used to filter virtual mice
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sample = 30000;
threshold = 0.1;
up= load(strcat('./data/1.dat'));
down = load(strcat('./data/2.dat'));
Ave = (up(:,2)+down(:,2))./2;
num = length(Ave);
result = zeros(num,1);
P = zeros(sample,1);
mu = zeros(num,1);
sigma = zeros(num,1);

for j = 1:num
     [mu(j),sigma(j)] = gamma_es(up(j,2),down(j,2));
end

for i =1:sample
    disp(i)
    data = load(strcat('Result/data_i=',num2str(i),'.dat'));
    for j = num-4:num
        mu_1 = mu(j);
        sigma_1 = sigma(j);
          a = (data(j*20,2)+data(j*20,3))./1e6;
        if down(j,2)<=a && a<=up(j,2)
            result(j) = 1-2*abs(gamcdf(a, mu_1, sigma_1)-0.5);
        else
            result(j) = 0;
        end
    end
    if nnz(result)<2
        P(i) = 0;
    else
    P(i) = 1/5 *(sum(result));
    end
end
p=rand(sample,1);
selectedtemp = p<P;
selected=selectedtemp>threshold;
idx = 1:sample;
SampleLabel = idx(selected==1);
file='./data/Number_VP_patients.mat';
save(file,'SampleLabel');
end