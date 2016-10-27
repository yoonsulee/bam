function [behavSchd]=think(timestep,occupancy,IAT,OAT,agent_character)

%The agent - with the basic understanding of the perceived environment,
%e.g., temperature, illuminance, etc. - will make decisions on the
%adaptive behaviors in the space.

%'occupancy','IAT','OAT','agent_character' need to be defined/formatted in the model.m

%% Variables Used by ABM
%Probability of behaviors
prob_light=zeros(1,timestep);
prob_window=zeros(1,timestep);
prob_heater=zeros(1,timestep);
prob_fan=zeros(1,timestep);

switch agent_character
    case 1
        agent_weight=0.25*rand();  %[0,0.25]
    case 2
        agent_weight=0.25+0.25*rand();   %[0.25,0.5]
    case 3
        agent_weight=0.5+0.25*rand();  %[0.5,0.75]
    otherwise
        agent_weight=0.75+0.25*rand();   %[0.75,1.0]
end

%% Behavior Algorithm Definition
%%%Probit analysis constants for various behaviors
          
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %prob = exp(a+bx)/[1+exp(a+bx)]%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
%%%% Window Use %%%%
a_win=-3.0;
b_win=0.16;

%%%% Light Use %%%%
a_lgt=2.08;
b_lgt=-0.5;

%%%% Blind Use %%%%
a_blnd=-0.3;
b_blnd=0.005;

%%%% Heater Use %%%%
a_heat=2.72;
b_heat=-0.322;

%%%% Fan Use %%%%
a_fan=-3.8;
b_fan=0.11;


%% Behavior Decisions Based On Perceived Environment
    
for i=1:1:timestep,

    temp1=0;
    temp2=0;

    %Algorithm for light use behavior
    %Most likely will use the DAYSIM/RADIANCE results

    if ~isempty(occupancy(i)),        
        %Algorithm for window use behavior
        temp1=exp(a_win+b_win*OAT(i))/(1+(exp(a_win+b_win*OAT(i))));
        temp2=exp(a_win+b_win*IAT(i))/(1+(exp(a_win+b_win*IAT(i))));
        prob_window(i)=max(temp1,temp2)*agent_weight;

        %Algorithm for heater use behavior
        temp1=exp(a_heat+b_heat*OAT(i))/(1+(exp(a_heat+b_heat*OAT(i))));
        temp2=exp(a_heat+b_heat*IAT(i))/(1+(exp(a_heat+b_heat*IAT(i))));
        prob_heater(i)=max(temp1,temp2)*agent_weight;

        %Algorithm for fan use behavior
        temp1=exp(a_fan+b_fan*OAT(i))/(1+(exp(a_fan+b_fan*OAT(i))));
        temp2=exp(a_fan+b_fan*IAT(i))/(1+(exp(a_fan+b_fan*IAT(i))));
        prob_fan(i)=max(temp1,temp2)*agent_weight;
        
        %Algorithm for light use behavior
        temp1=exp(a_lgt+b_lgt*OAT(i))/(1+(exp(a_lgt+b_lgt*OAT(i))));
        temp2=exp(a_lgt+b_lgt*IAT(i))/(1+(exp(a_lgt+b_lgt*IAT(i))));
        prob_light(i)=max(temp1,temp2)*agent_weight;

    else
        prob_light(i)=0;
        prob_window(i)=0;
        prob_heater(i)=0;
        prob_fan(i)=0;   

    end   
    
end
 
behavSchd=[prob_light;prob_window;prob_heater;prob_fan];

end
    
