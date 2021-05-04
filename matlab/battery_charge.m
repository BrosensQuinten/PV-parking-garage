function [battery_charge] = battery_charge(x,ev_charge_initial)
%this function gives back battery charge over the entire day based on the
%capacity profile and initial charge
for i = 1:size(x,1)
    for j =  1:size(x,2)
        battery_charge(i,1) = ev_charge_initial;
        battery_charge(i,j+1)= battery_charge(i,j) + x(i,j);
    end
end

end

