clear
date = ["07 01 2020.mat"; "07 04 2020.mat";"07 07 2020.mat"; "07 10 2020.mat"];
%% Opbouw costenberekening
%algemeen
av_commute = 23; %km
jaarlijkse_afstand = 15000; %km/auto
aantal_autos = 500; %nog aan te passen 
lifetime = 4; %gebruikstijd van de bedrijfswagen
lifetime_chargers = 25;
time_horizon = lifetime_chargers;
discount_rate = 0.0477; %nog opzoeken wat de discount rate hiervoor is
%Nissan leaf data
battery_capacity = 36; %kWh
battery_range = 220; %km
battery_efficiency = 0.164; %kWh/km
battery_useful = 1;
battery_actual = battery_useful*battery_capacity;
laadbeurten = jaarlijkse_afstand*battery_efficiency/battery_actual; %aantal laadbeurten per jaar
energy_year = laadbeurten*battery_actual*aantal_autos; %kWh per jaar per auto
energy_day = energy_year/365;
Nissan_cost = 30000; %aankoop kost nissan leaf
Nissan_resale = 0.83*10876; %resalevalue na 4 jaar

%data charging stations
fixed_installation_cost = 12000;
marginal_installation_cost = 600;
slow_charger_cost = 3000; 
charger_cost = fixed_installation_cost + marginal_installation_cost*aantal_autos +slow_charger_cost*aantal_autos;
%fast_charger_capacity = 40; %kW/paal
slow_charger_capacity = 7.4; %kW/paal
max_charging_cap = aantal_autos*slow_charger_capacity;
charging_cap = aantal_autos*slow_charger_capacity;
% Diesel auto costen
Citroen_kost = 25903; %aankoopprijs citroen c4
Citroen_resale = 11785; % resale value na 4 jaar
Citroen_verbruik = 5.52/100; %l/km
Diesel_prijs = 1.3445; %euro per liter 
Diesel_per_jaar = jaarlijkse_afstand *Citroen_verbruik; %l per jaar
Citroen_fuel_cost = Diesel_per_jaar * Diesel_prijs; %fuel cost per jaar
Citroen_maintanance = 500; %euro per jaar BRON ZOEKEN 

%% Waarden voor chargen
%ev_charge = laadbeurten*battery_actual*aantal_autos/365; %total charge needed per day for total ev fleet in kwh
ev_charge = energy_day;
%max_charging_cap = 5*1000; %max charging capacity in kw
ev_charge_initial = aantal_autos*battery_actual - ev_charge; %DIT MOET NOG AANGEPAST WORDEN MAAR IK WEET NIET MEER HOE WE DAT BEREKEND HEBBEN
                          %initial charge of total ev fleet at the start of the day in kwh
ev_charge_max = battery_actual * aantal_autos; %

%% fast and slow charging differentiation
charge_initial = ev_charge_initial;
charge_max = ev_charge_max;

%% Battery degradation

%% belpex waarden formatteren
Belpex = reshape(xlsread('BelpexFilter.xlsx'),24,[]);
Belpex = flip(Belpex(9:17,:))/1000;

%% slow charging optimalization
for j = 1:
for i = 1:size(Belpex,2)
%dam_prices(:,i) = load(fullfile(pwd, "day ahead market prices", date(i))).dam ; %day ahead market prices
%dam_9_5(:,i) = dam_prices(10:18,i); %day ahead market prices from 9am till 5pm.

[x_slow(i,:), fval_slow(i,1)] = loadProfile(Belpex(:,i), charge_max, charging_cap ,charge_initial);

end


%% fast charging optimalization
%for i = 1:size(Belpex,2)
%dam_prices(:,i) = load(fullfile(pwd, "day ahead market prices", date(i))).dam ; %day ahead market prices
%dam_9_5(:,i) = dam_prices(10:18,i); %day ahead market prices from 9am till 5pm.

%[x_fast(i,:), fval_fast(i,1)] = loadProfile(Belpex(:,i), fast_charge_max, fast_charging_cap ,fast_charge_initial);

%end
%% battery state of charge
%for i = 1: size(
   
%% plotjes
x_axis = [9 10 11 12 13 14 15 16 17];
monthdays = [31 28 31 30 31 30 31 31 30 31 30 31];
figure
for i = 1:12
   subplot(2,6,i)
   plot(x_axis, x_slow(i,:),x_axis,1000*Belpex(:,sum(monthdays(1:i))));
   title(i)
end

%% plotjes battery charge
[battery_slow] = battery_charge(x_slow, charge_initial);
%[battery_fast] = battery_charge(x_fast, fast_charge_initial);

%% Battery degradation

yearly_depletion = battery_depletion(battery_slow,aantal_autos);


%% NPV berekening
electricity_cost = sum(fval_slow);% + sum(fval_fast); %kost voor elektriciteit per jaar
capex = aantal_autos*(Nissan_cost - Citroen_kost) + charger_cost; %additional investment cost
opex_ev = electricity_cost;
opex_diesel = aantal_autos*(Citroen_fuel_cost+Citroen_maintanance);
savings = opex_diesel-opex_ev;
NPV = - capex;
for i=1:time_horizon
    NPV = NPV + savings/(1+discount_rate)^i;
    if rem(i,4) == 0
        NPV = NPV - aantal_autos*(Nissan_cost-Citroen_kost - (Nissan_resale-Citroen_resale) )/(1+discount_rate)^i;
    end
end

      
   
