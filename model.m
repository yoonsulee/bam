clear all

grid_sim=[15,15];
window_loc=[7.5,0];
entrance_loc=[15,13];
light_loc=[13,15];
thermostat_loc=[0,12];
timestep=4*24*4;        %Equivalent to 'occupancy.m' MAXSTEP
%How each day is divided
tot_agents=input('How many agents: ');

% Reading individual agents
%  agent_all(i,1)=agent(i).num;
%  agent_all(i,2)=agent(i).location(1);   %x-coordinate of agent location
%  agent_all(i,3)=agent(i).location(2);   %y-coordinate of agent loaction
%  agent_all(i,4)=agent(i).characteristic;

%Referenced occupancy schedule used in the simulation (ASHRAE or existing)
occ_std_wk_office=[0,0,0,0,0,0,.1,.2,.95,.95,.95,.95,.5,.95,.95,.95,.95,.3,.1,.1,.1,.1,.05,.05];
occ_std_sat_office=[0,0,0,0,0,0,.1,.1,.3,.3,.3,.3,.1,.1,.1,.1,.1,.05,.05,0,0,0,0,0];
occ_std_sun_office=[0,0,0,0,0,0,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,.05,0,0,0,0,0,0];

occ1_existing=[0,0,0,0,0,0,0,0,.33,.667,1,1,1,1,1,1,1,.5,0,0,0,0,0,0];
occ2_existing=[0,0,0,0,0,0,0,0,.67,.133,.2,.2,.1,0,0,0,0,0,0,0,0,0,0,0];
light1_existing=[.2,.2,.2,.2,.2,.2,.2,.2,.9,.9,.9,.9,.9,.9,.9,.9,.9,.2,.2,.2,.2,.2,.2,.2];
light2_existing=[.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2,.2]; 
eqp1_existing=[.17,.17,.17,.17,.17,.17,.17,.17,1,1,1,1,1,1,1,1,1,.17,.17,.17,.17,.17,.17,.17];
eqp2_existing=[.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17,.17, ...
    .17,.17,.17,.17,];
infil1_existing=[1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1];
infil2_existing=[1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1];

%This defines what the ABM is referencing in terms of occupancy.
%It can contain at least one of the above refereced occupancies.
stoch_occ=[0,0,0,0,0,0,0,0,0.7,0.9,1,0.7,0.8,1,1,0.8,1,0.8,0.6,0,0,0,0,0];
daysim_occ=[0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0];
ref_occ=repmat(stoch_occ,1,16);
light_occ=repmat(daysim_occ,1,16);
%To combine two or more arrays, [A;B;C;...]
%To multiply/expand an array, 'repmat()'

[agent_all,dynamSchd]=perceive(tot_agents,grid_sim,ref_occ,timestep);

%Variables to pass for think.m
%behavSchd=[prob_light;prob_window;prob_heater;prob_fan]
IAT=[];
OAT=csvread('/Users/eyoonsu/Desktop/X0_ABM/Matlab/ABM02 Model Based/Output/output.csv');   
%%This needs to be read in via co-simulation
illuminance=[];
behavSchd_new=zeros(4,timestep,tot_agents);

for i=1:1:tot_agents,
    behavSchd_new(:,:,i)=think(timestep,ref_occ,OAT,OAT,agent_all(i,4));
end


%Plots to compare end results

h1=figure(1);

x_axis=1:24;        %it should be '1:timestep'
a=subplot(2,2,1);
plot(x_axis,occ_std_wk_office, x_axis,occ1_existing, x_axis,ref_occ(x_axis))
%plot(leader1_movt(:,1),leader1_movt(:,2),'-x','LineWidth',2)
%hold on
title(a,'Occ Comparison')
legend('ASHRAE','Existing', 'Dynamic')

%axis([1 grid_sim(1) 1 grid_sim(2)])
grid on

b=subplot(2,2,2);       
plot(x_axis,infil1_existing,'r')
hold on
for i=1:1:tot_agents,
    plot(x_axis,behavSchd_new(2,1:24,i))
%     str=sprintf('Agent %d',i);
%     legend(str)
    hold on
end
title(b,'Win Behav Comparison')
legend('Existing','Agent')
grid on

c=subplot(2,2,3);       
% plot(x_axis,light1_existing)
% hold on
% for i=1:1:tot_agents,
%     plot(x_axis,behavSchd_new(1,1:24,i))
% %     str=sprintf('Agent %d',i);
% %     legend(str)
%     hold on
% end
plot(x_axis,light1_existing,  x_axis,daysim_occ)
title(c,'Elec Light Use Comparison')
legend('Existing','Daysim')
grid on

d=subplot(2,2,4);
plot(x_axis,eqp1_existing, 'r')
hold on
for i=1:1:tot_agents,
    plot(x_axis,behavSchd_new(4,1:24,i))
%     str=sprintf('Agent %d',i);
%     legend(str)
    hold on
end
title(d,'Equip Behav Comparison')
legend('Existing','Agent')
grid on

set(h1, 'color', 'white')

h2=figure(2);
scatter(agent_all(:,1),agent_all(:,4),'LineWidth',3)
title('Agent Characteristics')
xlabel('Agent ID')
set(gca,'XTick',1:tot_agents)
%legend('Leader 1','Leader 2', 'Leader 3')

set(h2, 'color', 'white');

h3=figure(3);
plot(agent_all(:,2),agent_all(:,3),'o','LineWidth',2)  %Specify 'no line' option
hold on
plot(window_loc(1),window_loc(2),'ro','LineWidth',2)
hold on
plot(entrance_loc(1),entrance_loc(2),'go','LineWidth',2)
hold on
plot(light_loc(1),light_loc(2),'yo','LineWidth',2)
hold on
title('Space Plan')
axis([0,grid_sim(1),0,grid_sim(2)])
grid on
%legend('a','b','c')
set(h3, 'color', 'blue')
