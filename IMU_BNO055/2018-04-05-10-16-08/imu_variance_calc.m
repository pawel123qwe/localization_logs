clear all
load imu.mat

time = (secs + nsecs/10^9) - (secs(1)+nsecs(1)/10^9);

figure(1)
subplot(2,3,1)
plot(acc_x)
var_acc_x = var(acc_x);
title(['acc_x   |   var = ', num2str(var_acc_x)])
hold on
plot(ones(1,length(acc_x)) * mean(acc_x))
hold off

subplot(2,3,2)
plot(acc_y)
var_acc_y = var(acc_y);
title(['acc_y   |   var = ', num2str(var_acc_y)])
hold on
plot(ones(1,length(acc_y)) * mean(acc_y))
hold off

subplot(2,3,3)
plot(acc_z)
var_acc_z = var(acc_z);
title(['acc_z   |   var = ', num2str(var_acc_z)])
hold on
plot(ones(1,length(acc_z)) * mean(acc_z))
hold off
figure(1)
subplot(2,3,4)
plot(vel_x)
var_vel_x = var(vel_x);
title(['vel_x   |   var = ', num2str(var_vel_x)])
hold on
plot(ones(1,length(vel_x)) * mean(vel_x))
hold off

subplot(2,3,5)
plot(vel_y)
var_vel_y = var(vel_y);
title(['vel_y   |   var = ', num2str(var_vel_y)])
hold on
plot(ones(1,length(vel_y)) * mean(vel_y))
hold off

subplot(2,3,6)
plot(vel_z)
var_vel_z = var(vel_z);
title(['vel_z   |   var = ', num2str(var_vel_z)])
hold on
plot(ones(1,length(vel_z)) * mean(vel_z))
hold off
