function main_parallel(i,t_start,t_end,beta_Th,beta_Tr,beta_Tc,d_Th,d_Tr,d_Tc)

x0 = initialzation();

[~, x] = ode45(@(t,x) model(t,x,beta_Th,beta_Tr,beta_Tc,d_Th,d_Tr,d_Tc),t_start:1:t_end,x0);

file=['./VP_parallel/','VP',num2str(i),'.mat'];

save(file,'x');

end