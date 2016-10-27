function [agent_new,bldgSys_new]=move(agent,bldgSys)
%Arguments to pass: an agent, building system


agent_new=agent;
bldgSys_new=bldgSys;

  
%% Calculations

%Logic:
% 1. Find the bldgSys w/ the largest cost for ON/OFF.
% 2. Move to the bldgSys to execute ON/OFF behavior.
% 3. Move to the next bldgSys w/ the second largest cost.

% However, the 'move' function only moves the current agent location to the
% described building system 


location=agent_new.location;
move_goal=bldgSys_new.location-agent_new.location;


move_angle=atan(move_goal(2)/move_goal(1))/pi*180;

if move_goal(1)<0,
    move_angle=move_angle+180;
elseif move_goal(2)<0,
    move_angle=move_angle+360;
end

if move_angle<22.5 || move_angle>=337.5, %shift to new location (360/16)
    location=location+[1,0];
elseif move_angle<67.5,
    location=location+[1,1];
elseif move_angle<112.5,
    location=location+[0,1];
elseif move_angle<157.5,
    location=location+[-1,1];
elseif move_angle<202.5,
    location=location+[-1,0];
elseif move_angle<247.5,
    location=location+[-1,-1];
elseif move_angle<292.5,
    location=location+[0,-1];
else %elseif move_angle<337.5,
    location=location+[1,-1];
end
agent_new.location=location;
    

% %which spot to shift to
% shift=(exitdoor(closest_exit).location-agent_new.location);
% %%%location=agent_new.location;
% 
% shift_prob=density(agent_new,agent_all); %find the probability of moving
% 
% 
% if norm(shift)~=0 && binornd(1,shift_prob,1), %if you must shift
%         %lower prob. of shifting if its too crowded
%     shift=shift/norm(shift); %normalize shifting vector
% 
%     shift_angle=atan(shift(2)/shift(1))/pi*180; %convert to degrees
%     if shift(1)<0,
%         shift_angle=shift_angle+180;
%     elseif shift(2)<0,
%         shift_angle=shift_angle+360;
%     end
%     if shift_angle<22.5 || shift_angle>=337.5, %shift to new location
%         location=location+[1,0];
%     elseif shift_angle<67.5,
%         location=location+[1,1];
%     elseif shift_angle<112.5,
%         location=location+[0,1];
%     elseif shift_angle<157.5,
%         location=location+[-1,1];
%     elseif shift_angle<202.5,
%         location=location+[-1,0];
%     elseif shift_angle<247.5,
%         location=location+[-1,-1];
%     elseif shift_angle<292.5,
%         location=location+[0,-1];
%     else %elseif shift_angle<337.5,
%         location=location+[1,-1];
%     end
%     agent_new.location=location;
%     agent_new.exit_time=agent_new.exit_time+1; %one more timestep to exit
% 
% 
% else %inside exit
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