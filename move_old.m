function [agent_new,exitdoor_new]=move(agent,exitdoor,agent_all,closed_exit_number)
%Arguments to pass: an agent, all exitdoors, all agents

agent_new=agent;
exitdoor_new=exitdoor;

%cost function
all_familiarity=zeros(1,length(exitdoor));
all_exitlengths=zeros(1,length(exitdoor));
leader_pref=zeros(1,length(exitdoor));

for i=1:1:length(exitdoor),
    all_familiarity(i)=exitdoor(i).familiarity;
    all_exitlengths(i)=exitdoor(i).line(1);
    leader_counter=1;
    for j=1:1:length(agent_all),
        if agent_all(j).number(2)==1,
            leader_pref(i)=leader_pref(i)+(exitdoor(i).line(1)+agent_all(j).dist_to_exits(i))*agent_new.leader_perceptions(leader_counter);
            leader_counter=leader_counter+1;
        end
        
    end
            
end
%leader_pref is matrix of the different costs of exit i to that leader

costs=agent_new.cost_weights(1)*agent_new.dist_to_exits...
      -agent_new.cost_weights(2)*all_familiarity...
      +agent_new.cost_weights(3)*all_exitlengths...
      +agent_new.cost_weights(4)*leader_pref;
  %higher familiarity means lower cost
if closed_exit_number>0, %if an exit is closed, then put it out of agent's preferred choice
    costs(closed_exit_number)=max(costs)+1;
end

if ~isempty(find(agent_new.dist_to_exits==0, 1)), %if you are at an exit, cost function is pointless
    costs(find(agent_new.dist_to_exits~=0))=1;
    costs(find(agent_new.dist_to_exits==0, 1))=-1; %define the min cost to be at that exit
end

closest_exit=find(costs==min(costs));

if length(closest_exit)>1,
    closest_exit=closest_exit(unidrnd(length(closest_exit)));
    %randomly choose one exit if costs are the same
end
%returns exit # of exit with lowest cost

%which spot to shift to
shift=(exitdoor(closest_exit).location-agent_new.location);
location=agent_new.location;

shift_prob=density(agent_new,agent_all); %find the probability of moving


if norm(shift)~=0 && binornd(1,shift_prob,1), %if you must shift
        %lower prob. of shifting if its too crowded
    shift=shift/norm(shift); %normalize shifting vector

    shift_angle=atan(shift(2)/shift(1))/pi*180; %convert to degrees
    if shift(1)<0,
        shift_angle=shift_angle+180;
    elseif shift(2)<0,
        shift_angle=shift_angle+360;
    end
    if shift_angle<22.5 || shift_angle>=337.5, %shift to new location
        location=location+[1,0];
    elseif shift_angle<67.5,
        location=location+[1,1];
    elseif shift_angle<112.5,
        location=location+[0,1];
    elseif shift_angle<157.5,
        location=location+[-1,1];
    elseif shift_angle<202.5,
        location=location+[-1,0];
    elseif shift_angle<247.5,
        location=location+[-1,-1];
    elseif shift_angle<292.5,
        location=location+[0,-1];
    else %elseif shift_angle<337.5,
        location=location+[1,-1];
    end
    agent_new.location=location;
    agent_new.exit_time=agent_new.exit_time+1; %one more timestep to exit


else %inside exit!
    if agent_new.line_pos(1)==-1, %just got to exit
       agent_new.exit_time=agent_new.exit_time+1; %one more timestep to exit
       exitdoor_new(closest_exit).line(1)=exitdoor_new(closest_exit).line(1)+1;
       exitdoor_new(closest_exit).line( exitdoor_new(closest_exit).line(1)+1 )=...
           agent_new.number(1);
       agent_new.line_pos=[closest_exit,exitdoor_new(closest_exit).line(1)]; 
       %set exit number, ranking in line
    end
    %the code for removing agent from exit queue is not here
end

agent_new.dist_to_exits=calc_dist(agent_new,exitdoor);



end