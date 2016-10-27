function dist_to_bldgSys = calc_dist(agent,bldgSys)
%Arguments to pass: this specific agent, all bldg systems that the agent
%interacts to perform behaviors

%bldgSys=struct('type',sysType,'location',initlocation,'priority',...
%    initpriority,'number',sysNumber)

dist_to_bldgSys=zeros(1,length(bldgSys));
for i=1:1:length(bldgSys),
    dist_to_bldgSys(i)=sqrt(sum((agent.location-bldgSys(i).location).^2));
end

end