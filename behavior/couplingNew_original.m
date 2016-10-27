%% Create an mlepProcess instance and configure it

ep = mlepProcess;
ep.arguments = {'SmOffPSZ_new', 'USA_IL_Chicago-OHare.Intl.AP.725300_TMY3'};
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
MAXSTEPS = 4*24*4;  % max simulation time = 4 days

TCRooLow = 22;  % Zone temperature is kept between TCRooLow & TCRooHi
TCRooHi = 26;
TOutLow = 22;  % Low level of outdoor temperature
TOutHi = 24;  % High level of outdoor temperature
ratio = (TCRooHi - TCRooLow)/(TOutHi - TOutLow);

% logdata stores set-points, outdoor temperature, and zone temperature at
% each time step. IT NEEDS TO TAKE IN THE NEW OCCUPANCY DATA.
logdata = zeros(MAXSTEPS, 8);

while kStep <= MAXSTEPS    
    % Read a data packet from E+
    packet = ep.read;
    if isempty(packet)
        error('Could not read outputs from E+.');
    end
    
    % Parse it to obtain building outputs
    [flag, eptime, outputs] = mlepDecodePacket(packet);
    if flag ~= 0, break; end
        
    % BEGIN Compute next set-points
    dayTime = mod(eptime, 86400);  % time in current day
    if (dayTime >= 6*3600) && (dayTime <= 18*3600)
        % It is day time (6AM-6PM)
        
        % The Heating set-point: day -> 20, night -> 16
        % The cooling set-point is bounded by TCRooLow and TCRooHi
        
        SP = [20, max(TCRooLow, ...
                    min(TCRooHi, TCRooLow + (outputs(1) - TOutLow)*ratio)), ...
                    ref_occ(kStep),light_occ(kStep),behavSchd_new(2,kStep,1), behavSchd_new(4,kStep,1)];
    else
        % The Heating set-point: day -> 20, night -> 16
        % The Cooling set-point: night -> 30
        SP = [16 30 ref_occ(kStep) light_occ(kStep) behavSchd_new(2,kStep,1) behavSchd_new(4,kStep,1)];
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

% Plot results
plot([0:(kStep-1)]'*deltaT/3600, logdata(:,3:6,:));
legend('Occup','Light','Win','Equip');
title('Schedules');
xlabel('Time (hour)');
ylabel('Probability');

