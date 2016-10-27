clear all

%% From GUI's Input Parameters from User

% totAgent: Total number of agents in the ABM
%   tot_agents: Used in current codes

% winValue: 1=window present, 0=window unused;
% lightValue: 1=light present, 0=light unused;
% blindsValue: 1=blinds present, 0=blinds unused;
% heaterValue: 1=heater present, 0=heater unused;
% fanValue: 1=fan present, 0=fan unused;
% count: Total number of bldg systems in use

% contents: Space typology (1=Open Office, 2=Private Office,
%           3=Parameter/Interior/Core, 4=Mixed Zone)

% Input needed: maxdays, bldg system location (user specified or random), agent location (user
% specified or random), output graph list, occupancy schedule (ASHRAE vs stochastic vs user defined)
% type of idf and weather file used.


%% Main ABM Simulation

%   Determine the geometry and IDF file to use for the simulation
    % Need to use the input from GUI: Open space, pvt office,
    % parameter/interior/core, and mixed zone. This will also determine the
    % geometry of the space. 
    % The user-identified bldg system will be embedded into the ABM,
    % defining location and number. 
    
    % Input: IDF and weather file in quotation marks.
    % Plots: Always ignore the first element in the list, e.g., env.oat(1)
 
maxdays=4; % Total of days for running simulation (1yr=365)
tempSchd=zeros(maxdays*4*24,1); % Initial schedule is assumed to be '0'

% Read from GUI the IDF file and weather file used

idfFile='SmOffPSZ';
tmyFile='USA_IL_Chicago-OHare.Intl.AP.725300_TMY3';
environment_init=coupling01(tempSchd,maxdays,idfFile,tmyFile);
    % environment_init=struct(.oat, .zone, .schd, .illum) --> GUI handles
    
% Determine a matrix of all the bldg systems used in the ABM
% windows(1), light switch(2), blinds(3), heater(4), fan(5), thermostat(6)
% For a simple test, assume all systems are only 1 in the ABM.
bldySys_all=setBldgSystem(sys1,sys2,sys3,sys4,sys5,sys6);   % sys refers to location of the system.
    %bldgSYs_all = 1xtotal_num struct array with fields:
    %   type, location, priority, number, state

% The locations of the bldg systems are to be adopted from the GUI
% interface. For lighting, fan, heater, the total number of each system is
% also important. 
% Use this for testing: setBldgSystem([1,2],[4,4],0,[[3,3],[4,4]],[9,8],0)

% Need to write the bldg system information to the working IDF file.

for agent=1:1:totAgent, %or tot_agents
    

%   Initial Location and Properties of Agent/System -- Phase01
    % newAgent.m
    
    
    % bldgSystem.m
    

%   Perceive Environment
    % Determine comfort


%   Calculate Cost Function
    % Behavior decisions

%   Move and Conduct Behavior
    % Update environmental parameters

%   Update Agent/System Properties
    % Agent interaction

%   Reorder Agents
    % Via level of discomfort? or level or interaction?

end

% OUTPUT



%% Old Codes
tot_agents=input('How many agents: ');

grid_sim=[15,15];
window_loc=[7.5,0];
entrance_loc=[15,13];
light_loc=[13,15];
thermostat_loc=[0,12];

agent1=newAgent(1,[2,4],4);
sys(1)=bldgSystem(6,[2,4],0,1);    % [Heater/fan,location,priority,num]
sys(2)=bldgSystem(2,[13,15],0,1);    % [Lights,location,priority,num1]
sys(3)=bldgSystem(2,[13,15],0,2);   % [Lights,location,priority,num2]

sys(1).state=0;
sys(2).state=0;
all_sys=2;
all_cost=zeros(1,1,1,all_sys,tot_agents);  % [cost,time,system,agent]

%Pass: agentBelief(agent,cost_weights,norm,control,satisfaction)
agent_new1=agentBelief(agent1,[1,1,1,1],1,[2,1.5,1,1,1,2],0);

maxdays=4*4*24;              % --> this should be total timestep
schedule=zeros(maxdays,1);
for t=1:1:4*4*24,
    schedule(t)=rand(1);
end

temperature=coupling(schedule,4);
%temperature.oat and temperature.zone

light_temp=[0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, ...
    1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0, ...
    0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1, ...
    1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0, ...
    0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0, ...
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, ...
    0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0, ...
    0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1, ...
    1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0, ...
    0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1, ...
    1,0,0,0,0,0,0,0,0,0];

light_occ=reshape(light_temp,384,1);

all_time=length(temperature.oat);
unhappy=zeros(1,1,1,tot_agents); % [satisfaction, time, agent]
comfort_temp=zeros(1,1,1,tot_agents); % Catalogues all the [time,agent] comfort temperatures
counter1=zeros(all_time,1,tot_agents);  % Input [1,2,3] for agent update function

for agent=1:1:tot_agents,
    for time=1:1:all_time,
        %[unhappy(:,:,time,agent),comfort_temp(:,:,time,agent)]=comfort(temperature.oat(time),temperature.zone(time));
        [unhappy(:,:,time,agent),Tc]=comfort(temperature.oat(time),temperature.zone(time));
        %comfort_temp(:,:,time,agent)=Tc.tc; %when using struct to define Tc
        comfort_temp(:,:,time,agent)=Tc;    %when excluding operative comfort temperature
        if unhappy(:,:,time,agent) == -1,
            for i=1:1:all_sys,
                [agent_new,system(i),cost(i)]=calc_cost(agent_new1,sys(i));
                all_cost(:,1,time,i,agent)=cost(i);
                [system_update] = beliefUpdateSys(sys(i),Tc,temperature.zone(time));
                sys(i).priority = system_update.priority;
%                 if (unhappy(:,:,time,agent))/(unhappy(:,:,time-1,agent)) > 1.2,
%                     [agent_update] = beliefUpdateAgent(agent,1);
%                     agent_new1.norm = agent_update.norm;
%                     agent_new1.control = agent_update.control;
%                     agent_new1.cost_weights = agent_update.cost_weights;
                   
%                 if (unhappy(:,:,time,agent)-unhappy(:,:,time-1,agent))>0,
%                     [agent_update] = beliefUpdateAgent(agent,1);
%                 %elseif (unhappy(:,:,time,agent))/(unhappy(:,:,time-1,agent)) < 0.8,
%                 elseif (unhappy(:,:,time,agent)-unhappy(:,:,time-1,agent))<0,
%                     [agent_update] = beliefUpdateAgent(agent,2);
%                 else
%                     [agent_update] = beliefUpdateAgent(agent,3);
%                  end
            end
            if unhappy(:,:,time,agent)-unhappy(:,:,time-1,agent) > 0,
                [agent_update] = beliefUpdateAgent(agent_new1,1);
                agent_new1.norm = agent_update.norm;
                agent_new1.control = agent_update.control;
                agent_new1.cost_weights = agent_update.cost_weights;
                counter1(time,:,agent)=1;
            elseif unhappy(:,:,time,agent)-unhappy(:,:,time-1,agent) < 0,
                [agent_update] = beliefUpdateAgent(agent_new1,2);
                agent_new1.norm = agent_update.norm;
                agent_new1.control = agent_update.control;
                agent_new1.cost_weights = agent_update.cost_weights;
                counter1(time,:,agent)=2;
            else
                [agent_update] = beliefUpdateAgent(agent_new1,3);
                agent_new1.norm = agent_update.norm;
                agent_new1.control = agent_update.control;
                agent_new1.cost_weights = agent_update.cost_weights;
                counter1(time,:,agent)=3;
            end
        else
            for i=1:1:all_sys,
                all_cost(:,1,time,i,agent)=0;
            end
        end
    end
end
%Every hour is marked either un/satisfied according to the thermal comfort
%theory. A status of '-1' will initiate the cost calculations. 

behav_equip=zeros(all_time,1,tot_agents); % [Equipment ON/OFF]

for agent=1:1:tot_agents,
    for time=1:1:all_time,
        if unhappy(:,:,time,agent) == -1,
            behav_equip(time,:,agent)=1;
        else
            behav_equip(time,:,agent)=0;
        end
    end
end


unhappy_light=zeros(all_time,1,tot_agents); %(0)need light (1)don't need (2)need shade
ref_illum=500;
light_cost=zeros(all_time,1,tot_agents);

for agent=1:1:tot_agents,
    for time=1:1:all_time,
        unhappy_light(time,:,agent)=comfort_light(temperature.illum(time),ref_illum);
        if unhappy_light(time,:,agent) == 0,
      
            [agent_new,system(3),cost(time)]=calc_cost(agent_new1,sys(3));
            light_cost(time,:,agent)=cost(time);
        end
        [ bldgSys_new ] = beliefUpdateLight(sys(3),unhappy_light(time,:,agent));
        sys(3).priority = bldgSys_new.priority;
       
    end
end


h1=figure(1);

x_axis=1:all_time;        
a=subplot(2,2,1);
plot(x_axis,temperature.oat, x_axis,temperature.zone, x_axis,reshape(comfort_temp,1,all_time))
title(a,'Temp Comparison')
legend('OAT','Zone','Tc')

b=subplot(2,2,2);
plot(x_axis,reshape(all_cost(:,:,:,1),1,all_time))
title(b,'Cost Comparison')
legend('System1')

c=subplot(2,2,3);
plot(x_axis,reshape(all_cost(:,:,:,2),1,all_time))
title(c,'Cost Comparison')
legend('System2')

d=subplot(2,2,4);
plot(x_axis,temperature.illum, x_axis,light_cost*10)
title(d,'Illumination and Cost')
legend('Current Lux','Light Cost')

