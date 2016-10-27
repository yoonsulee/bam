function environment=coupling01(schedules,maxdays,IDF,weatherFile)

% The coupling is solely for the purpose of getting the general outdoor air
% temperature and the illuminance of reference points.

%% Create an mlepProcess instance and configure it

idfName=[char(39) IDF char(39)];
tmyName=[char(39) weatherFile char(39)];
ep = mlepProcess;
%ep.arguments = {'SmOffPSZ', 'USA_IL_Chicago-OHare.Intl.AP.725300_TMY3'};
ep.arguments = {idfName, tmyName}; %---->Adjust to user input regards to bldg typology
ep.acceptTimeout = 60000;

VERNUMBER = 2;  % Existing version upgraded to be compatible with E+ v7.1


%% Start EnergyPlus cosimulation
[status, msg] = ep.start;

if status ~= 0
    error('Could not start EnergyPlus: %s.', msg);
end

%% The main simulation loop

deltaT = 15*60;  % time step = 15 minutes
kStep = 1;  % current simulation step
%MAXSTEPS = 4*24*4;  % max simulation time = 4 days
MAXSTEPS = 4*24*maxdays;  % This needs to be reflected in the IDF also.

TCRooLow = 22;  % Zone temperature is kept between TCRooLow & TCRooHi
TCRooHi = 26;
TOutLow = 22;  % Low level of outdoor temperature
TOutHi = 24;  % High level of outdoor temperature
ratio = (TCRooHi - TCRooLow)/(TOutHi - TOutLow);

% logdata stores set-points, outdoor temperature, and zone temperature at
% each time step. IT NEEDS TO TAKE IN THE NEW OCCUPANCY DATA.
logdata = zeros(MAXSTEPS, 6);

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
                    min(TCRooHi, TCRooLow + (outputs(1) - TOutLow)*ratio)), schedules(kStep)];
    else
        % The Heating set-point: day -> 20, night -> 16
        % The Cooling set-point: night -> 30
        SP = [16 30 schedules(kStep)];
    end
    % END Compute next set-points
    
    
    % Write to inputs of E+ (configured in variables.cfg)
    ep.write(mlepEncodeRealData(VERNUMBER, 0, (kStep-1)*deltaT, SP));   

    % Save to logdata
    % logdata=[Heat SP, Cool SP, Occupancy, OAT, Zone temp, DE Illum]
    % outputs=[OAT, Zone temp, DE Illum]
    logdata(kStep, :) = [SP outputs];
    plotdata(kStep,:) = [SP(1:2) outputs];
    
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

environment=struct('oat',logdata(:,4),'zone',logdata(:,5),'schd',logdata(:,3), ...
    'illum',logdata(:,6));


% Plot results
% plot([0:(kStep-1)]'*deltaT/3600, plotdata);
% legend('Heat SP', 'Cool SP', 'Outdoor', 'Zone');
% title('Temperatures');
% xlabel('Time (hour)');
% ylabel('Temperature (C)');

end
