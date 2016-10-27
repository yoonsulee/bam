function [agent_new,system_new,cost_new]=calc_cost(agent,bldgSys)
%Arguments to pass: an agent, all agents

agent_new=agent;
system_new=bldgSys;
% 'bldgSys' is assumed to be a single system component. However, if the
% function needs to calculate cost for multiple systems, a 'bldgSys_all'
% should be used. Same applies to 'agent' vs 'agent_all'.

%% COST FUNCTION
%Cost weights:
% 1. Priority - related to agent behavior belief or bldg-specific priority
%    (can be defined from the main model)
% 2. Agent Type - agent activeness towards changing behavior
% 3. Normative - agent sensitivity towards other agents' perception
% 4. Familiarity - ease of control and accessibility
% --> The weights among different beliefs are in agent.cost_weight() per newAgent function

all_priority=zeros(1,length(bldgSys));
all_types=zeros(1,length(bldgSys));
all_norms=zeros(1,length(bldgSys));
all_control=zeros(1,length(bldgSys));


% for i=1:1:length(bldgSys),
%     all_priority(i)=bldgSys(i).priority;   %priority values from bldg system component
% %    all_distance(i)=dist_to_bldgSys(i);
%     for j=1:1:length(agent_all);           %all other weights inherited from individual agents
%         all_types(i)=agent_new(j).characteristic(i);
%         all_norms(i)=agent_new(j).initnorm(i);
%         all_control(i)=agent_new(j).initcontrol(i);
%         
%     end
% end
%Weights inherited from individual agents are distinguished for different
%bldg systems.

all_types=agent_new.characteristic;
all_priority=bldgSys.priority;
all_norms=agent_new.norm;
all_control=agent_new.control(bldgSys.type);
dist_to_bldgSys=calc_dist(agent_new,system_new);

%Agent objective is to make decisions so that it maintains the highest cost
costs=agent_new.cost_weights(1)*all_priority...
    +agent_new.cost_weights(2)*all_types...
    +agent_new.cost_weights(3)*all_norms...
    -agent_new.cost_weights(4)*dist_to_bldgSys...
    +agent_new.cost_weights(4)*all_control;
%All agent weights range from [-3,3], hence, all calc for weights are '+' only.
  

%% Calculations

%If building system is in use
% Calculate cost for continued building system use

% Calculate cost for stopping building system use
    


%If building system is not in use
% Calculate cost for building systems in consideration

% Calculate cost for continued building system non-use

cost_new=costs;

% if closed_exit_number>0, %if an exit is closed, then put it out of agent's preferred choice
%     costs(closed_exit_number)=max(costs)+1;
% end
% 
% if ~isempty(find(agent_new.dist_to_exits==0, 1)), %if you are at an exit, cost function is pointless
%     costs(find(agent_new.dist_to_exits~=0))=1;
%     costs(find(agent_new.dist_to_exits==0, 1))=-1; %define the min cost to be at that exit
% end
% 
% closest_exit=find(costs==min(costs));
% 
% if length(closest_exit)>1,
%     closest_exit=closest_exit(unidrnd(length(closest_exit)));
%     %randomly choose one exit if costs are the same
% end
% %returns exit # of exit with lowest cost
% 
% 
% else %inside exit!
%     if agent_new.line_pos(1)==-1, %just got to exit
%        agent_new.exit_time=agent_new.exit_time+1; %one more timestep to exit
%        exitdoor_new(closest_exit).line(1)=exitdoor_new(closest_exit).line(1)+1;
%        exitdoor_new(closest_exit).line( exitdoor_new(closest_exit).line(1)+1 )=...
%            agent_new.number(1);
%        agent_new.line_pos=[closest_exit,exitdoor_new(closest_exit).line(1)]; 
%        %set exit number, ranking in line
%     end
%     %the code for removing agent from exit queue is not here
% end
% 
% agent_new.dist_to_exits=calc_dist(agent_new,exitdoor);



end