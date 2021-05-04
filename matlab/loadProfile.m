function [x,fval] = loadProfile(dam_9_5,ev_charge_max, max_charging_cap,ev_charge_initial)
%this function minimizes the costs of charging over a 9am to 5pm period.
%dam_9_5 = prices for electricity
%ev_charge = total energy required to charge all ev's over period
%max_charging_cap = max capacity to charge per hour

len = size(dam_9_5,1);

f= dam_9_5;


A = vertcat(-toeplitz(ones(1,len),zeros(1,len)),toeplitz(ones(1,len),zeros(1,len)));

b_initial(1:len,1) = ev_charge_initial; %to allow for discharging of the initial battery energy
b_charge_max(1:len,1) = ev_charge_max - ev_charge_initial; % to make sure the battery doesnt get charged above max capacity
b = vertcat(b_initial,b_charge_max);

Aeq= ones(1,len);
beq= ev_charge_max- ev_charge_initial;

lb(1,1:len) = -max_charging_cap;
ub(1,1:len) = max_charging_cap;

[x fval]= linprog(f,A,b,Aeq,beq,lb,ub);

end