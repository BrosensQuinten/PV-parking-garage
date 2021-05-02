clear
date = ["07 01 2020.mat"; "07 04 2020.mat";"07 07 2020.mat"; "07 10 2020.mat"];

ev_charge = 673; %total charge needed per day for total ev fleet in kwh
max_charging_cap = 5*1000; %max charging capacity in kw
ev_charge_initial = 1846; %initial charge of total ev fleet at the start of the day in kwh

%%

for i = 1:size(date,1)
dam_prices(:,i) = load(fullfile(pwd, "day ahead market prices", date(i))).dam ; %day ahead market prices
dam_9_5(:,i) = dam_prices(10:18,i); %day ahead market prices from 9am till 5pm.

[x(i,:), fval(i,1)] = loadProfile(dam_9_5(:,i), ev_charge, max_charging_cap,ev_charge_initial);

end

%%
x_axis = [9 10 11 12 13 14 15 16 17];
figure
for i = 1:size(date,1)
    subplot(2,2,i)
    plot(x_axis, x(i,:),x_axis,10*dam_9_5(:,i));
    title(date(i))
end