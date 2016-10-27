function [ agent_new ] = beliefUpdateAgent(agent,satisfaction_change)
%AGENTBELIEFUPDATE Summary of this function goes here
%   Function updates beliefs for both agent and building system based on
%   the satisfaction level of diff(comfort temperature, zone temperature)
%   from a comparison between time t_n and t_n-1.
%System types:
%  windows(1), entrance door(2), light switch(3), thermostat(4),
%  blinds(5),heater/fan(6)

agent_new=agent;

switch satisfaction_change
    case 1 % Comfort level increased for all agents by 20 percent.
        agent_new.norm = agent.norm + 1.5;
        agent_new.control = agent.control + 1;
        agent_new.cost_weights = agent.cost_weights + 1.5;
    case 2 % Comfort level decreased for all agents by 20 percent.
        agent_new.norm = agent.norm - 1.5;
        agent_new.control = agent.control - 1;
        agent_new.cost_weights = agent.cost_weights - 1.5;
    case 3 % Comfort level similar to last time interval
        agent_new.norm = agent.norm + 0.5;
        agent_new.control = agent.control + 0.5;
        agent_new.cost_weights = agent.cost_weights + 0.5;

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

    
end

