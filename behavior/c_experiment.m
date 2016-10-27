light_schd_ashrae=[.05,.05,.05,.05,.05,.1,.1,.3,.9,.9,.9,.9,.8,.9,.9,.9,.9,.5,.3,.3,.2,.2,.1,.5];
equip_schd_ashrae=[0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0]; 
occp_ashrae=[0,0,0,0,0,0,.1,.2,.95,.95,.95,.95,.5,.95,.95,.95,.95,.3,.1,.1,.1,.1,.05,.05];

light_ashrae=reshape(repmat(light_schd_ashrae,1,16),384,1);
equip_ashrae=reshape(repmat(equip_schd_ashrae,1,16),384,1);
occ_ashrae=reshape(repmat(occp_ashrae,1,16),384,1);

behav_all=couplingNew(4,occ_ashrae,light_ashrae,equip_ashrae);

x_axis=1:all_time;

plot(x_axis,temperature.zone, x_axis,behav_all.zone)
title('Updated Zone Temperature')
legend('Orig','New')


% plot(x_axis,temperature.oat, x_axis,temperature.zone, x_axis,reshape(comfort_temp,1,all_time))
% title('Temp Comparison')
% legend('OAT','Zone','Tc')

%compare w/ the existing models
%conduct energy comparison


% Use repmat() and reshape()