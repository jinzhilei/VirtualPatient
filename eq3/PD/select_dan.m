function p = select_dan()
file_CPSP='./data/CPSP.mat';
CPSP = cell2mat(struct2cell(load(file_CPSP)));
[n,~] = size(CPSP);
up= [20.81,45.58,34.21,2.39];
down = [26.04,39.58,33.33,1.04];
ave = (up+down)/2;
for i = 1:n
    d(i) = sum((ave-CPSP(i,:)).^2)^(1/2);
end
[j,p] = min(d);
end