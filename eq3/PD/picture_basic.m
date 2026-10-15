function picture_basic()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Plot: cells and cytokines curve
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set: parameter

%% cell
figure(1)
for j = 1:10000

    file=['./VP_parallel/','VP',num2str(j),'.mat'];

    % plot cell curve
    A=cell2mat(struct2cell(load(file)));
    t = 1:1:84;

    Y = {'X','Th','Tr','Tc'};

    for i = 1:1:4
        subplot(2,2,i);
        y = A(:,i);
        plot(t,y);
        ylabel(Y(i));
        hold on
    end











end