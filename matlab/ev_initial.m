function initial_charge = ev_initial(aantal_autos,chargers,energy_day,battery_actual)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
dagelijks_laden = energy_day/aantal_autos;
gisteren = (battery_actual-dagelijks_laden); %aantal autos*81%*capacity
eergisteren =(battery_actual-2*dagelijks_laden);%
initial_charge = (aantal_autos-chargers)*eergisteren + (chargers-(aantal_autos-chargers))*gisteren;
end

