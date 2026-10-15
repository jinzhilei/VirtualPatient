function y0 = initialzation()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file records the initial values of the model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global par ini

ini.X = 5e12;    
ini.T_h = 5e7;    
ini.T_r= 5e7; 
ini.T_c = 5e7;  

y0 = [ini.X; ini.T_h; ini.T_r; ini.T_c];

end