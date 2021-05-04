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
discount_rate = 0.02; %nog opzoeken wat de discount rate hiervoor is
%Nissan leaf data
battery_capacity = 36; %kWh
battery_range = 220; %km
battery_efficiency = 0.164; %kWh/km
battery_useful = 0.7;
battery_actual = battery_useful*battery_capacity;
laadbeurten = jaarlijkse_afstand*battery_efficiency/battery_actual; %aantal laadbeurten per jaar
energy_year = laadbeurten*battery_actual*aantal_autos; %kWh per jaar per auto
energy_day = energy_year/365;
Nissan_cost = 30000; %aankoop kost nissan leaf
Nissan_resale = 4322.25; %resalevalue na 4 jaar

%data charging stations
fixed_installation_cost = 47000;
marginal_installation_cost = 4000;
fast_charger_cost = 10000;
slow_charger_cost = 644; 
fast_charging_aandeel = 1;
slow_charging_aandeel = (1-fast_charging_aandeel);
fast_chargers = fast_charging_aandeel*aantal_autos;
slow_chargers = slow_charging_aandeel*aantal_autos;
charger_cost = fixed_installation_cost + marginal_installation_cost*aantal_autos + fast_charger_cost*fast_chargers + slow_charger_cost*slow_chargers;
fast_charger_capacity = 50; %kW/paal
slow_charger_capacity = 7.4; %kW/paal
max_charging_cap = fast_chargers*fast_charger_capacity + slow_chargers*slow_charger_capacity;
% Diesel auto costen
Citroen_kost = 25903; %aankoopprijs citroen c4
Citroen_resale = 11785; % resale value na 4 jaar
Citroen_verbruik = 5.52/100; %l/km
Diesel_prijs = 1.491; %euro per liter 
Diesel_per_jaar = jaarlijkse_afstand *Citroen_verbruik; %l per jaar
Citroen_fuel_cost = Diesel_per_jaar * Diesel_prijs; %fuel cost per jaar
Citroen_maintanance = 500; %euro per jaar BRON ZOEKEN 

%% Waarden voor chargen
%ev_charge = laadbeurten*battery_actual*aantal_autos/365; %total charge needed per day for total ev fleet in kwh
ev_charge = energy_day;
%max_charging_cap = 5*1000; %max charging capacity in kw
ev_charge_initial = aantal_autos*battery_actual - ev_charge; %DIT MOET NOG AANGEPAST WORDEN MAAR IK WEET NIET MEER HOE WE DAT BEREKEND HEBBEN
                          %initial charge of total ev fleet at the start of the day in kwh

%%
%% belpex waarden formatteren
Belpex = reshape(xlsread('BelpexFilter.xlsx'),24,[]);
Belpex = Belpex(9:17,:);
%%

for i = 1:size(Belpex,2)
%dam_prices(:,i) = load(fullfile(pwd, "day ahead market prices", date(i))).dam ; %day ahead market prices
%dam_9_5(:,i) = dam_prices(10:18,i); %day ahead market prices from 9am till 5pm.

[x(i,:), fval(i,1)] = loadProfile(Belpex(:,i), ev_charge, max_charging_cap,ev_charge_initial);

end

%% battery state of charge
%for i = 1: size(
   
%% plotjes
x_axis = [9 10 11 12 13 14 15 16 17];
monthdays = [31 28 31 30 31 30 31 31 30 31 30 31];
figure
for i = 1:12
   subplot(2,6,i)
   plot(x_axis, x(i,:),x_axis,100*Belpex(:,sum(monthdays(1:i))));
   title(i)
end
%% NPV berekening
electricity_cost = sum(fval); %kost voor elektriciteit per jaar
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

      
   
