function [agent_all,dynamSchd]=perceive(tot_agents,grid_sim,ref_occ,timestep)

%Perceive process:
% 1-Determine satisfaction level of an agent (Adaptive Comfort)
% 2-Receive all current environmental factor
% 3-Define agent options and priorities?

%dynamSchd will only pertain to the occupancy schedule at this time.
%All other schedules will be decided in the 'think.m' function.

agent_all=zeros(tot_agents,4);
dynamSchd=zeros(length(ref_occ(:,1)),timestep,tot_agents);

for i=1:1:tot_agents,
%Initialize the agents:
%Decide on the location and agent type

    agenttype=randi(4,1);
    %Randomnly assign agent type.
    %Agent type is defined as the activeness of agent control:
    %  4-Most active
    %  1-Least active
    
    init_zone=randi(4,1);
    %Randomnly assign agent location:
    %  4-Core zone
    %  3-Perimeter
    %  2-Perimeter+window
    %  1-Private office
    switch init_zone
        case 1
            initlocation=[randi(grid_sim(1),1),randi([5,grid_sim(2)])];
        case 2
            initlocation=[randi(grid_sim(1),1),randi([0,5])];
        case 3
            initlocation=[randi(grid_sim(1),1),randi([0,5])];
        otherwise
            initlocation=[randi(grid_sim(1),1),randi([5,grid_sim(2)])];
    end
    
    agent(i)=newAgent(i,initlocation,agenttype);
    agent_all(i,1)=agent(i).num;
    agent_all(i,2)=agent(i).location(1);   %x-coordinate of agent location
    agent_all(i,3)=agent(i).location(2);   %y-coordinate of agent loaction
    agent_all(i,4)=agent(i).characteristic;
    
    %Initially, just assume 'ref_occ' is the new occupancy as a result of
    %the stochastic process. In reality, it should be the PDF that the
    %stochastic process is based on.
    
    for j=1:1:timestep,
        for k=1:1:length(ref_occ(:,1)),
            dynamSchd(k,j,i)=ref_occ(k,j);
        end
    end
    
    
end


end
    
