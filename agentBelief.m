function [ agent_new ] = agentBelief(agent,cost_weights,norm,control,satisfaction)
%AGENTBELIEF automates agent definition by defining differen belief
%intentions.
%   Need to pass an array for the following,
%   - cost_weight
%   - control: if control belief is different for individual bldg system. 

agent_new=agent;
agent_new.norm=norm;
agent_new.satisfaction=satisfaction;

for i=1:1:length(cost_weights),
    agent_new.cost_weights(i)=cost_weights(i);
end

for j=1:1:length(control),
    agent_new.control(j)=control(j);
end



end

