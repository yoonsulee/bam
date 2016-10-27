function [ bldgSys_all ] = setBldgSystem(win,light,blind,heater,fan,thermostat)
%SETBLDGSYSTEM creates a list of all building systems used in the ABM
%   Input: 
%           - count: Total number of building systems used --> Not needed.
%           - win~thermostat: If 0, not used; else location, taken as a list in [].
%           - 

if ~isempty(win),
    system(1)=newBldgSystem(1,win,1,1);  % Priority assumed 1 and number of systems as 1.    
end
    
if ~isempty(light),
    system(2)=newBldgSystem(2,light,1,1);      
end

if ~isempty(blind),
    system(3)=newBldgSystem(3,blind,1,1);      
end

if ~isempty(heater),
    for i=1:1:length(heater)/2,
        system(3+i)=newBldgSystem(4,heater(2*i-1:2*i),1,i);
    end
    count_heat=i;
end

if ~isempty(fan),
    for j=1:1:length(fan)/2,
        system(count_heat+3+j)=newBldgSystem(5,fan(2*j-1:2*j),1,i);
    end      
    count_fan=count_heat+j;
end

if ~isempty(thermostat),
    system(4+count_fan)=newBldgSystem(6,thermostat,1,1);
end

bldgSys_all=system;
        
% Use 'append' for lists, 'cat' for arrays.        
    

end

