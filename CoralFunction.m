%% Coral Growth
function dcoral = CoralFunction(Gm,I,Ik,k,absdepth,dt)
dcoral = (Gm*tanh((I/Ik)*exp(-k*absdepth)))*dt;