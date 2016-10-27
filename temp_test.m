clear all

grid_sim=[15,15];
agent1=newAgent(1,[0,0],4);
agent2=newAgent(1,[2,4],4);
sys1=bldgSystem(1,[3,9],0,1);
sys2=bldgSystem(1,[.1,.5],0,1);
sys_all=1;
agent_all=2;

% for i=0:1:10,
%     move(agent1,sys1);
%     loc(i)=agent1.location;
% end

% for i=1:1:sys_all,
%     for j=1:1:agent_all,
%         [agent(j),bldgSys(i)]=move(agentj,sys1);
%         agent1=newAgent(1,[agent(j).location(1),agent(j).location(2)],4);
%         
%         if calc_dist(agent1,sys1)>0,
%             [agent(j),bldgSys(i)]=move(agentj,sys1);
%             %agent1=newAgent(1,[agent1.location(1),agent1.location(2)],4);
%             
%         else
%             agent(j).location=bldgSys(i).location;
%         end
%     end
% end


% while calc_dist(agent1,sys1)>0,
%     [agent,sys]=move(agent1,sys1);
%     agent1=agent;
%     sys1=sys;
% 
% end
% %agent.location=sys1.location;

for i=0:1:20,
    if calc_dist(agent1,sys1)>0,
        [agent,sys]=move(agent1,sys1);
        agent1=agent;
        sys1=sys;
    else
        agent1.location=sys1.location;
    end
    
end




