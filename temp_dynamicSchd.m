function [schd_all]=dynamicSchd(timestep) %should include "schd_avg"
% In order to implement the Dynamic Schedule, this function refereces the
% averaged office occupancy from ASHRAE standards to come up with
% individual agent's occupancy schedule

schd_average=zeros(timestep);
% In reality, 'schd_average' would be used in a stochastic process to
% generate 'schd_occupancy'. 


occup_csv = csvread('test.csv', 0,0,[0,0,8759,0]);
wind_csv=csvread('test.csv', 0,1,[0,1,8759,1]);
heater_csv=csvread('test.csv', 0,2,[0,2,8759,2]);
fan_csv=csvread('test.csv', 0,3,[0,3,8759,3]);
schd_all=struct('occup',occup_csv,'window',wind_csv,'heater',heater_csv,...
    'fan',fan_csv);
