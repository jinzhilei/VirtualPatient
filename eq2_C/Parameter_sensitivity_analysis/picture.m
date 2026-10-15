function picture()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('./data_prcc/Model_LHS.mat');
Parameter_settings_LHS();
D = {'$$D_b$$' '$$D_t$$' '$$E$$' 'T'};
picture_width = 30;
picture_hight = 20;
figure(1)
for i =1:4
    subplot(2,2,i)
    sv=D(i);
    SV=B(i,:);
    [prcc sign sign_label]=PRCC(LHSmatrix,SV,t_end,PRCC_var,g,sv);
    Q(i,:) = prcc;
end
nan_indices = isnan(Q);
Q(nan_indices) = 0;

set(gcf,'unit','centimeters','position',[0.5 0.5 picture_width picture_hight]);
print('-dpng','-r600','picture_prcc\picture.png');
end