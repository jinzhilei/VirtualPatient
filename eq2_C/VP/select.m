function select()
sample = 10000;
threshold = 0.1;
up= load(strcat('./data/1.dat'));
down = load(strcat('./data/2.dat'));
day = [13,15,17,20];
[num,~] = size(up);
result = zeros(num,1);
mu = zeros(num,1);
sigma = zeros(num,1);
ave = zeros(num,1);
P = zeros(sample,1);
for j = 1:num
    [mu(j),sigma(j),ave(j)] = gamma_es(up(j,2),down(j,2));
end

for i =1:sample
    disp(i)
    data = load(strcat('Result/data_i=',num2str(i),'.dat'));
    for j = 1:num
        mu_1 = mu(j);     
        sigma_1 = sigma(j);  
        a = (data(day(j)*20,3)+data(day(j)*20,4)+data(day(j)*20,5))*4/3*pi*1e-2^3;
        if down(j,2)<=a && a<=up(j,2)
            result(j) = 1-2*abs(gamcdf(a, mu_1, sigma_1)-0.5);
        else
            result(j) = 0;
        end
    end
    count = nnz(result);
    if count < 2
        P(i) = 0;
    else
        P(i) = 1/num *(sum(result));
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