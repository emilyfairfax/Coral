% Coral Reef Modeling: Growth and Abandonment as a Function of Sea Level
% Oscillations and Uplift/Subsidence
% written by Emily Fairfax for Modeling Class
% January 27th, 2016

clear all

%% Initialize
%Time and Space
 % Horizontal Space
    dx = 10; % horizontal step size
    xmax = 12000; % maximum horizontal position 
    x = 0:dx:xmax; % set up the x array describing horizontal space

    % Temporal Space
    Yrcon = 3.14*10^7; % number of seconds in a year, common coversion
    dt = 800; % time step in years
    tmax = 120000;% maximum time to run the code in years
    t = 0:dt:tmax;% set up the time array
    imax = length(t);% define imax for time loops

%Constants

    %Coral Growth Equation Constants
    Gm = 0.012; % maximum coral growth of 15 mm/yr
    k = 0.08; % extinction coefficient for light /m
    I = 2000*Yrcon; % surface light intensity in microE/m^2/yr
    Ik = 200*Yrcon; % saturating light intensity in microE/m^2/yr

    %Topographic Constants
    %note: use suboruprate for either uplift or subsidence: negative sign ->uplift,
    %positive sign -> subsidence
    slope = 0.05; %slope of the linear baseline topography in m/m
    topomax = 100; %maximum elevation of the inital baseline topography
    suboruprate = -0.003; %subsidence in m/yr
    baselinemax = -slope.*xmax+topomax-(suboruprate*tmax);

    %Sea Level Constants
    meansealevel = 0;% average sea level set to zero
    ampsealevel = 60; % amplitude of sea level oscillations is about 60m
    period = 40000; % period of sea level oscillations in years

%Set Up Arrays: note all arrays are made in horizontal space, and need to
%be the same length as the time array in order for the code to run properly
    %Set Number of Nodes for Variable Arrays
    N = (xmax/dx)+1; % number of nodes, plus one to make correct length

    %Sea Level Array
    sealevel = zeros(N:1); % sea level array starts full of zeros
    sealevel(1:N) = 0;
    %Topographic Array: note this can be changed to other shapes for
    %different initial topographic conditions
    baseline = -slope.*x + topomax; % Initial baseline of topography

    % Height of Coral Arrays
    coralsl = zeros(N:1); % height of coral relative to sea level, starts as all zeros
    coralsl(1:N)=baseline; % fill zeros with initial condition: all coral are at the height of the baseline

    coralsubup = zeros(N:1); % height of coral with subsidence or uplift relative to sea level, starts all zeros
    coralsubup(1:N)=coralsl-(suboruprate*dt); % fill zeros with inital condition:

    absdepth = zeros(N:1); % absolute depth of coral below sea level, start all zeros
    absdepth(1:N) = sealevel-coralsubup; % fill zeros with initial condition: depth is sealevel minus coral depth with sub or up rate included, ie distance between top of coral and water surface




%% Run


for i=1:imax
    %Sea Level oscillates sinusoidally with time
    sealevel(1:N) = ampsealevel*sin((2*pi*t(i))/period); % sea level oscillation in meters relative to mean sea level
    
    %Calculate Coral Height with subsidence or uplift change relative to sea level
    coralsubup = coralsl-(suboruprate*dt); % in meters
    
    % Calculate the absolute depth below current sea level including coral
    % protrusions
    absdepth = sealevel-coralsubup; % in meters
    
    % Calculate the discreet growth of the coral for this time step
    dcoral = (Gm*tanh((I/Ik)*exp(-k*absdepth)))*dt; % change in coral growth in meters
    
    % If coral growth is negative, replace with zero. Coral does not grow
    % out of the water
    neg = find(absdepth<0); % find where coral is above sea level and thus not growing
    dcoral(neg)=0; % corrects dcoral array so that coral out of water has zero growth
         
    % Calculate the new height of the coral relative to the sea level
    coralsl(1:N) = coralsubup + dcoral;
    
    % Lift up or sink the baseline topography (depends on if using uplift
    % or subsidence
    
    baseline = -slope.*x+topomax-suboruprate*t(i); % equation for baseline topography, with elevation in meters
    
  
% Plot results
    waterlevel = sealevel(i)*ones(size(x));
    sea = find(sealevel(i)>coralsl);
   
    
    figure(1)
    clf
    
    plot(x,coralsl,'m','linewidth',3)
    hold all
    plot(x,baseline,'k','linewidth',3)  
    plot(x(sea),waterlevel(sea),'b','linewidth',3)
    
    %color the coral pink!
    xx = [x,x];        % repeat x values
    yy = [coralsl,baseline];   % vector of upper & lower boundaries
    fill(xx,yy,[.97, .475, .561])    % fill area defined by x & yy curves in coral
    
    %color the bedrock beige!
    xx = [x,x]; %repeat x values
    bottomline=zeros(N:1); %create a bottom line to be the lower curve
    bottomline(1:N)=-200000; %make the bottom line out of the frame
    cc = [baseline, bottomline]; %vector of upper and lower boundaries
    fill(xx,cc,[.91,.92,.87]) % fill area defined by xx and cc curves in beige
    
    
    xlabel('Distance (m)', 'fontname', 'arial', 'fontsize',21)
    ylabel('Depth (m)', 'fontname', 'arial', 'fontsize',21)
    set(gca,'fontsize',18,'fontname','arial')
    legend('Coral','Bedrock','Sea Level')
    ht=text(1450,500,['  ',num2str(round(t(i)/1000)), ' kyrs  '],'fontsize',18); %print time in animation
    axis([0 xmax baselinemax topomax+500])
    hold all % hold all makes different colors while hold on keeps the lines the same color
    pause(0.1)
    
    
    
end
