%% Inputs

ev_number = 500;
max_charging_cap = 10; % kW

P_ev = max_charging_cap*ev_number; % discharging power in kW
P_l = 0; % charging power in kW
V_s = 230; % nominal grid voltage

V_tol = 0; % tolerated voltage at consumer end 

%% Calculations

if P_ev > 0
    V_tol = 1.1*V_s;
    R = (V_tol*(V_tol-V_s))/(1000*(P_ev-P_l));
else
    V_tol = 0.9*V_s;
    R = (V_s*(V_s-V_tol))/(1000*(P_ev-P_l));
end

'V_tol'
disp(V_tol)
'R'
disp(R)