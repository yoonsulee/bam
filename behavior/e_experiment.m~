%% Details
% Version update: 2012.10.11
% Objective: Change the output values and reflect the change in the E+
%            simuation at each timestep.
% Function: couplingDynamic.m
% Results: If the zone air temperature is more than 25C, the euipment is
%   automatically 100% in operation. The resulting zone temperature is
%   compared to the 'c_experiment' where the equipment schedule was
%   predetermined. As a result, the MLE was able to dynamically change the
%   output value and reflect the changes in the simulation realtime.


%% Experiment Codes
light_schd_ashrae=[.05,.05,.05,.05,.05,.1,.1,.3,.9,.9,.9,.9,.8,.9,.9,.9,.9,.5,.3,.3,.2,.2,.1,.5];
equip_schd_ashrae=[0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0]; 
occp_ashrae=[0,0,0,0,0,0,.1,.2,.95,.95,.95,.95,.5,.95,.95,.95,.95,.3,.1,.1,.1,.1,.05,.05];

light_ashrae=reshape(repmat(light_schd_ashrae,1,16),384,1);
equip_ashrae=reshape(repmat(equip_schd_ashrae,1,16),384,1);
occ_ashrae=reshape(repmat(occp_ashrae,1,16),384,1);

numBehav=3;
numOut=2;
behav_temp01=zeros(numBehav,384);
behav_temp02=zeros(numBehav,384);

for i=1:1:384,
    behav_temp01(:,i)=[occ_ashrae(i),light_ashrae(i),equip_ashrae(i)];
end

behav_all=couplingDynamic(4,behav_temp01,numBehav,numOut);

x_axis=1:all_time;

% plot(x_axis,temperature.zone, x_axis,behav_all.zone)
% title('Updated Zone Temperature')
% legend('Orig','New')

plot(x_axis,equip_ashrae, x_axis,behav_all.equip)
title('Dynamic Coupling Test')
legend('Orig','New')
