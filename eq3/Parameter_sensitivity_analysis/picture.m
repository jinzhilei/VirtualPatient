function picture()

load ./data_prcc/Model_LHS.mat;
D = {'$$Tumor$$' '$$T_h$$' '$$T_r$$' '$$T_c$$'};

figure(1)
for i =1:4
    subplot(2,2,i)
    sv=D(i);
    SV=B(i,:);
    [prcc, ~, ~]=PRCC(LHSmatrix,SV,t_v,PRCC_var,g,sv);
    Q(i,:) = prcc;
end
nan_indices = isnan(Q);
Q(nan_indices) = 0;
set(gcf,'unit','centimeters','position',[0.5 0.5 picture_width picture_hight]);
print('-dpng','-r600','picture_prcc\picture.png');

end