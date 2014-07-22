%This function calculate the wind velocity deficit percentage resulted from
%the wake loss model def, u=u0*def=u0*[1-2a(1+alpha*x/rd)]. The combination 
%from different turbine is given by:
%def_total=((1-def1)^2)+((1-def2)^2)+...+((1-defn)^2).
%This code is found in the paper:
%https://etd.ohiolink.edu/rws_etd/document/get/case1270056861/inline

function vel = calculate_velocity(j,location,counter) 
 
global wind_farm; 
 
count = counter; 
alpha = 0.09437; 
a = 0.326795; 
rotor_radius = 27.881; 
velr1 = 0; 
 
for lo = 1:1:count-1 
    for ii=1:1:counter-1 % Loop for checking turbine 1 by 1 
         for jj = ii+1 : 1 : counter 

             y1 = location(ii); 
             y2 = location(jj); 
             ydistance = abs(wind_farm(y1,2) - wind_farm(y2,2)); 
             radius = rotor_radius + (alpha * ydistance); 

             xmin = wind_farm(y2,1) - radius; 
             xmax = wind_farm(y2,1) + radius; 

             if (xmin < wind_farm(y2,1)) && (xmax > wind_farm(y2,1)) 
             % Eliminate turbine at ii 

             location(ii) = []; 

             counter = counter - 1; 

             break; 
             end
         end 
    end 
end 
 
for ii=1:1:counter 
 y1 = location(ii); 
 ydistance = wind_farm(j,2) - wind_farm(y1,2); 
 denominator = ((alpha * ydistance / rotor_radius) + 1) ^ 2; 
 velr = (1 - (2 * a / denominator)); 
 velr1 = velr1 + ((1 - velr)^2); 
 
end 
vel = 1 - (velr1 ^ 0.5); 
