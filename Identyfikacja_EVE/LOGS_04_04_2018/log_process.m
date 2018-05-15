min = 1255;
max = 14130;

log100_2_time = time(min:max);
log100_2_u = u(min:max);
log100_2_y = y(min:max);

figure(1);
plot(log100_2_u);

figure(2);
plot(log100_2_y);

clear max
clear min
clear u
clear y
clear time

save log100_2.mat

clear all