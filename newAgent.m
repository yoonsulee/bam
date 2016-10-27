function agent = newAgent(num_agent,initlocation,agenttype)

agent=struct('num',num_agent,'location', initlocation,...
    'characteristic',agenttype,'cost_weights',[],...
    'norm',0,'control',[],'satisfaction',0); 


%-location: perimeter(near/far window), core, or private office.
%-characteristic: 4 levels of agent activeness in behavior intentions.
%-initcostweights: defined in main function, which allocates weights for
%   importance among normative, behav belief, and control belief. E.g., each
%   belief can have a range of [-3,3].
%-satisfaction: denpending on the results of the comfort calculator, it
%   allocations either 0 or 1 for each agent.
%-control: control belief should be distinguished among different building systems as they have different level
%   of difficulty in their manipulation (total of 6). 
%             


end