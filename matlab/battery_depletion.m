function yearly_depletion = battery_depletion(battery_charge,aantal_autos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
yearly_depletion = 0;
for day = 1:365
    previous_charge = battery_charge(day,10);
    for hour = 1:10
        if battery_charge(day,hour) < previous_charge
            yearly_depletion = yearly_depletion +(previous_charge-battery_charge(day,hour));
            previous_charge = battery_charge(day,hour);
        end
    end
end
yearly_depletion = yearly_depletion/aantal_autos;
end

