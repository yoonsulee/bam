function [ bldgSys_new ] = beliefUpdateSys(bldgSys,comfortTemp,zoneTemp)
%AGENTBELIEFUPDATE Summary of this function goes here
%   Function updates beliefs for both agent and building system based on
%   the satisfaction level of diff(comfort temperature, zone temperature)
%   from a comparison between time t_n and t_n-1.
%System types:
%  windows(1), entrance door(2), light switch(3), thermostat(4),
%  blinds(5),heater/fan(6)

bldgSys_new=bldgSys;
abs_diff=abs(comfortTemp-zoneTemp); % Would potentially be used to apply weights to the in/decrease of agent & system properties.

if comfortTemp > zoneTemp, % Too cold
    
    switch bldgSys.type
        case 1 % Window open
            bldgSys_new.priority=bldgSys.priority - 0.5;
        case 2 % Entrance door
            bldgSys_new.priority=bldgSys.priority + 0;
        case 3 % Lights on
            bldgSys_new.priority=bldgSys.priority + 0.5;
        case 4 % Thermostat change
            bldgSys_new.priority=bldgSys.priority + 1;
        case 5 % Blinds open
            bldgSys_new.priority=bldgSys.priority + 0.5;
        otherwise % Heater/Fan
            bldgSys_new.priority=bldgSys.priority + 1;
    end
end
        
if comfortTemp < zoneTemp, % Too warm
    
    switch bldgSys.type
        case 1 % Window open
            bldgSys_new.priority=bldgSys.priority + 0.5;
        case 2 % Entrance door
            bldgSys_new.priority=bldgSys.priority + 0.2;
        case 3 % Lights on
            bldgSys_new.priority=bldgSys.priority - 0.1;
        case 4 % Thermostat change
            bldgSys_new.priority=bldgSys.priority + 1;
        case 5 % Blinds open
            bldgSys_new.priority=bldgSys.priority - 0.5;
        otherwise % Heater/Fan
            bldgSys_new.priority=bldgSys.priority + 1;
    end
    
if comfortTemp == zoneTemp, % Same
    
    switch bldgSys.type
        case 1 % Window open
            bldgSys_new.priority=bldgSys.priority + 0.1;
        case 2 % Entrance door
            bldgSys_new.priority=bldgSys.priority + 0.1;
        case 3 % Lights on
            bldgSys_new.priority=bldgSys.priority - 0.1;
        case 4 % Thermostat change
            bldgSys_new.priority=bldgSys.priority + 0.1;
        case 5 % Blinds open
            bldgSys_new.priority=bldgSys.priority - 0.1;
        otherwise % Heater/Fan
            bldgSys_new.priority=bldgSys.priority + 0.1;
    end
end

%'satisfaction_all' specified in the main function: [satisfaction, time, agent]
% Determine the level of satisfaction of all agents to update individual
% agent belief.

%all_time=length(satisfaction_all); % Assume that total time will match the length of the the satisfaction
% for time=1:1:all_time,
%     if (satisfaction_all(:,:,:,time))/(satisfaction_all(:,:,:,time-1)) > 1.2, % Comfort level increased for all agents
%         agent_new.norm = agent.norm + 1.5;
%         agent_new.control = agent.control + 1;
%         agent_new.cost_weights = agent.cost_weights + 1.5;
%     elseif (satisfaction_all(:,:,:,time))/(satisfaction_all(:,:,:,time-1)) < 0.8, % Comfort level decreased for all agents
%         agent_new.norm = agent.norm - 1.5;
%         agent_new.control = agent.control - 1;
%         agent_new.cost_weights = agent.cost_weights - 1.5;
%     else
%         agent_new.norm = agent.norm + 0.5;
%         agent_new.control = agent.control + 0.5;
%         agent_new.cost_weights = agent.cost_weights + 0.5;
%         
%     end
% end
% 
% if (satisfaction_all(:,time,agent))/(satisfaction_all(:,time-1,agent)) > 1.2, % Comfort level increased for all agents
%     agent_new.norm = agent.norm + 1.5;
%     agent_new.control = agent.control + 1;
%     agent_new.cost_weights = agent.cost_weights + 1.5;
% elseif (satisfaction_all(time))/(satisfaction_all(time-1)) < 0.8, % Comfort level decreased for all agents
%     agent_new.norm = agent.norm - 1.5;
%     agent_new.control = agent.control - 1;
%     agent_new.cost_weights = agent.cost_weights - 1.5;
% else
%     agent_new.norm = agent.norm + 0.5;
%     agent_new.control = agent.control + 0.5;
%     agent_new.cost_weights = agent.cost_weights + 0.5;
%     
% end
    

end

