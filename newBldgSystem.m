function [ bldgSys ] = newBldgSystem(sysType,initlocation,initpriority,sysNumber)
%System types include windows(1), light switch(2), blinds(3), heater(4),
%   fan(5), thermostat(6).
%initlocation will determine its distance from each agent
%initpriority is agent's priority in interacting with the particular
%   building system --> This is mostly predefined, but could be updated via
%   system upadates. E.g., personal heater/fan can have the highest
%   priority or whenever there's an extreme climate, temperate weather conditions 
%   could have higher window operations, etc. 
%   
%sysNumber distinguishes bldg systems that are more than one

bldgSys=struct('type',sysType,'location',initlocation,'priority',...
    initpriority,'number',sysNumber,'state',0);

%'state': [0,1] depending on whether it is being used or not.
%'priority': agent has predefined priority towards all the bldg systems.

end
