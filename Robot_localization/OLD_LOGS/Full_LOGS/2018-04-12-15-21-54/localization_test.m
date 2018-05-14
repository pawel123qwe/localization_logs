clear all
csv_to_mat_parser
load data.mat

figure(1)
plot(longitude_right,latitude_right)
hold on
plot(longitude_left,latitude_left)
title('Raw Holux GPS')
legend('Right','Left')

figure(2)
plot(odom_wheel_x, odom_wheel_y)
hold on
plot(odometry_gps_x_right, odometry_gps_y_right)
plot(odometry_gps_x_left, odometry_gps_y_left)
plot(filtered_map_x, filtered_map_y)
plot(filtered_odom_x, filtered_odom_y)
title('Localization')
legend('Hall','GPS Right+IMU','GPS Left+IMU','Hall+IMU+GPS','Hall+IMU')
legend('Location','northwest')

figure(3)
plot(odom_wheel_x, odom_wheel_y)





