function [ bldgSys_new ] = beliefUpdateLight(bldgSys,lightStat)
%AGENTBELIEFUPDATE Summary of this function goes here
%   Function updates beliefs for both agent and building system based on
%   the satisfaction level of diff(comfort temperature, zone temperature)
%   from a comparison between time t_n and t_n-1.
%System types:
%  Light switch and shades only

bldgSys_new=bldgSys;

if lightStat==1, % No need for electric light      
  % Lights on
    bldgSys_new.priority=bldgSys.priority - 0.5;
  % Blinds open
    bldgSys_new.priority=bldgSys.priority + 0.1;       
end
        
if lightStat==0, % Need electric light
  % Lights on
    bldgSys_new.priority=bldgSys.priority + 0.1;
  % Blinds open
    bldgSys_new.priority=bldgSys.priority + 0.1;
end
    
if lightStat==2, % No light and need shading
  % Lights on
    bldgSys_new.priority=bldgSys.priority - 1.0;
  % Blinds open
    bldgSys_new.priority=bldgSys.priority - 0.5;
end


end

