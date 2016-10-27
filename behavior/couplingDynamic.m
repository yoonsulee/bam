function behavior=couplingDynamic(maxdays,behaviors,numBehav,numOut) %occup,light,equip

%% Create an mlepProcess instance and configure it

ep = mlepProcess;
ep.arguments = {'SmOffPSZ_dynamic', 'USA_IL_Chicago-OHare.Intl.AP.725300_TMY3'};
ep.acceptTimeout = 60000;

VERNUMBER = 2;  % version number of communication protocol (2 for E+ 7.1)


%% Start EnergyPlus cosimulation
[status, msg] = ep.start;

if status ~= 0
    error('Could not start EnergyPlus: %s.', msg);
end

%% The main simulation loop

deltaT = 15*60;  % time step = 15 minutes
kStep = 1;  % current simulation step
MAXSTEPS = 4*24*maxdays;  % max simulation time = 4 days

TCRooLow = 22;  % Zone temperature is kept between TCRooLow & TCRooHi
TCRooHi = 26;
TOutLow = 22;  % Low level of outdoor temperature
TOutHi = 24;  % High level of outdoor temperature
ratio = (TCRooHi - TCRooLow)/(TOutHi - TOutLow);

% Output Information
% <EnergyPlus name="ENVIRONMENT" type="OUTDOOR DRY BULB">
% <EnergyPlus name="ZSF1" type="ZONE/SYS AIR TEMPERATURE">


% logdata stores set-points, outdoor temperature, and zone temperature at
% each time step. IT NEEDS TO TAKE IN THE NEW OCCUPANCY DATA.

%%%%% Original from last version
% logdata = zeros(MAXSTEPS, 7); % Change for different simulation environment
% behavSchd_new = zeros(MAXSTEPS,numBehav); % [Occupancy,Lighting,Equipment] Schedule
% behavSchd_new(:,1)=occup;
% behavSchd_new(:,2)=light;
% behavSchd_new(:,3)=equip;

logdata = zeros(MAXSTEPS, 2+numBehav+numOut); % Change for different simulation environment
behavSchd_new = zeros(MAXSTEPS,numBehav); % [Occupancy,Lighting,Equipment] Schedule

for i=1:1:numBehav,
    behavSchd_new(:,i)=behaviors(i);     % 1=occup,2=light,3=equip,etc
end


while kStep <= MAXSTEPS    
    % Read a data packet from E+
    packet = ep.read;
    if isempty(packet)
        error('Could not read outputs from E+.');
    end
    
    % Parse it to obtain building outputs
    [flag, eptime, outputs] = mlepDecodePacket(packet);     %% MLE output controller %%
    if flag ~= 0, break; end
        
    % BEGIN Compute next set-points
    dayTime = mod(eptime, 86400);  % time in current day
    if (dayTime >= 6*3600) && (dayTime <= 18*3600)
        % It is day time (6AM-6PM)
        
        % The Heating set-point: day -> 20, night -> 16
        % The cooling set-point is bounded by TCRooLow and TCRooHi
        
%         SP = [20, max(TCRooLow, ...
%                     min(TCRooHi, TCRooLow + (outputs(1) - TOutLow)*ratio)), ...
%                     behavSchd_new(kStep,1),behavSchd_new(kStep,2),behavSchd_new(kStep,3)];
                
        if outputs(2)>25
            behavSchd_new(kStep,3)=1;
        else
            behavSchd_new(kStep,3)=0;
        
        end
        
        SP = [20, max(TCRooLow, ...
                     min(TCRooHi, TCRooLow + (outputs(1) - TOutLow)*ratio)), ...
                     behavSchd_new(kStep,1),behavSchd_new(kStep,2),behavSchd_new(kStep,3)];
                
    else        
        % The Heating set-point: day -> 20, night -> 16
        % The Cooling set-point: night -> 30
        SP = [16 30 behavSchd_new(kStep,1),behavSchd_new(kStep,2),behavSchd_new(kStep,3)];
    end
    % END Compute next set-points
    
    
    % Write to inputs of E+
    ep.write(mlepEncodeRealData(VERNUMBER, 0, (kStep-1)*deltaT, SP));   

    % Save to logdata
    % logdata=[Heat SP, Cool SP, Occupancy, OAT, Zone temp]
    logdata(kStep, :) = [SP outputs];
    
    kStep = kStep + 1;
end

% Stop EnergyPlus
ep.stop;

disp(['Stopped with flag ' num2str(flag)]);

% Remove unused entries in logdata
kStep = kStep - 1;
if kStep < MAXSTEPS
    logdata((kStep+1):end,:) = [];
end

behavior=struct('occup',logdata(:,3),'light',logdata(:,4),'equip',logdata(:,5),'oat',logdata(:,6),'zone',logdata(:,7));

% Plot results
% plot([0:(kStep-1)]'*deltaT/3600, logdata(:,3:6,:));
% legend('Occup','Light','Win','Equip');
% title('Schedules');
% xlabel('Time (hour)');
% ylabel('Probability');


end

