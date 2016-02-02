%% Sea Level Function
function sl= SeaLevelFunction(t,ampsealevel,period) %name the function, define inputs
sl=ampsealevel*sin(2*pi.*(t/period)); %define mathematics
end