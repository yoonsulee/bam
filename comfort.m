function [ uncomf_time, Tc ] = comfort(oat,zone)

%According to the thermal comfort theory, the agent refereces the outside
%aire temperature and compares w/ the interior zone temperature to
%determing whether it is comfortable or not. 
%
%Output: -1 for uncomfortable, 0 for comfortable
%
%Thermal Comfort (ASHRAE Fundamentals)
% 1. Directly measured enviromental paramters:
%   - air temperature
%   - wet-bulb temperature
%   - dew-point temperature
%   - water vapor pressure
%   - total atmospheric pressure
%   - relative humidity and humidity ratio
% 2. Calculated environmental paramters:
%   - mean radiant temperature
%   - plane radiant temperature
%   - radinat temp asymmetry
% 3. Secondary factors: nun-uniformity of the environment, visual stimuli,
%    age, and outdoor climate.
%
% Comfort Temperature (Humphreys and Nicols)
% T_comfortable = 24.2+0.43(Tout-22)exp-(Tout-22/24?2)^2
% The range of comfort temperature -2C < T_comfortable < +2C
% With greater control, a greater forgiveness and adaptiveness.

comf_temp=zeros(1,2); % [oat_comf,oat_op]
uncomf_time=zeros(1); % [satisfaction]

%Tc=24.2 + 0.43*(oat-22)*exp(-((oat-22)/(24*sqrt(2))).^2);
%Top=18.9+0.255*oat;

% oat & zone temperature inherited from 'couping' function

comf_temp(:,1)=24.2 + 0.43*(oat-22)*exp(-((oat-22)/(24*sqrt(2))).^2);
comf_temp(:,2)=18.9+0.255*oat;

if (zone > comf_temp(:,1)+2) || (zone < comf_temp(:,1)-2),
    uncomf_time(:)=-1;
    %Thermal discomfort needs to change some weight in the system
else
    uncomf_time(:)=0;
end

%Tc = struct('tc', comf_temp(:,1),'op',comf_temp(:,2));
Tc=comf_temp(:,1);

end

% for current_time=1:1:all_time,
%     comf_temp(:,1,current_time)=24.2 + 0.43*(oat(current_time)-22)*exp(-((oat(current_time)-22)/(24*sqrt(2))).^2);
%     comf_temp(:,2,current_time)=18.9+0.255*oat(current_time);
% end
