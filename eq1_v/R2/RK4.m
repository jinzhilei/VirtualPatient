function y = RK4(x0, h, xend,y0,i,path)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% This script file is used for calculation using Runge Kutta method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Q = strcat(path,'data_','i=',num2str(i),'.dat');
fn = fopen(Q, 'w');

output(fn, x0, y0); 
addpath('../model');
x = x0;
y = y0; 

while x < xend
    k1 = model(x,y);
    k2 = model(x + h/2, y + (h/2)*k1);
    k3 = model(x + h/2, y + (h/2)*k2);
    k4 = model(x + h, y + h*k3);
    
    x = x + h;
    y = y + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
    
    output(fn, x, y);
end

fclose(fn);
end


function output(fn, x, y)
   fprintf(fn,'%f ',x);
   m=length(y);
for i=1:m
    fprintf(fn,'%f ',y(i));
end

 fprintf(fn,'\n');
end