function   C = counts(z)
global ini
X0 = ini.X;
%% Load data

for i = 1:z
    file=['./VP_parallel/','VP',num2str(i),'.mat'];
    x = cell2mat(struct2cell(load(file)));
    you(i) = x(end,1);
end


%% Simulation calculation

    C = zeros(1,4);
    tumor = zeros(z,1);
    ratio = zeros(z,1);
    Pi=3.14;
    VD=0.8;
    VE=0.37;
    vcell = 2.572e-9;

    tumor_0 = ((6* X0 .* vcell .* VD)./(VE * Pi)).^(1/3);
    for i = 1:z
        tumor(i) = you(i);
        tumor(i) = ((6 * tumor(i) .* vcell .* VD)./(VE * Pi)).^(1/3);
        ratio(i) = (tumor(i)- tumor_0)./tumor_0;

        if ratio(i) >= 0.2
            C(1,1) = C(1,1)+1;
        elseif -0.3 <= ratio(i) && ratio(i) < 0.2
            C(1,2) = C(1,2)+1;
        elseif -0.8 <= ratio(i) && ratio(i) <-0.3
            C(1,3) = C(1,3)+1;
        elseif -0.8 > ratio(i)
            C(1,4) = C(1,4)+1;
        end
    end
C = C./z.*100;

end








