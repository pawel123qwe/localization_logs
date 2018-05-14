clear all
load data.mat

figure(1)
plot(longitude,latitude)
title('Raw Holux GPS')

figure(2)
plot(odom_wheel_x, odom_wheel_y)
hold on
plot(odometry_gps_x, odometry_gps_y)
plot(filtered_map_x, filtered_map_y)
plot(filtered_odom_x, filtered_odom_y)
title('Localization')
legend('Hall','GPS+IMU','Hall+IMU+GPS','Hall+IMU')
legend('Location','northwest')





