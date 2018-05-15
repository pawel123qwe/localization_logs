clear all
close all
csv_to_mat_parser
load data.mat

figure(1)
plot(longitude_right,latitude_right,'-o')
hold on
plot(longitude_left,latitude_left,'-o')
title('Raw Holux GPS')
legend('Right','Left')

figure(2)
direction = [0 0 1];
plot(odom_wheel_x, odom_wheel_y)
hold on
% plot(odometry_gps_x_left, odometry_gps_y_left)
% plot(odometry_gps_x_right, odometry_gps_y_right)
rotate(plot(odometry_gps_x_right, odometry_gps_y_right),direction,-135,[0 0 0])
rotate(plot(odometry_gps_x_left, odometry_gps_y_left),direction,-135,[0 0 0])
plot(filtered_map_x, filtered_map_y)
title('Localization')
legend('Hall+IMU','GPS Right+IMU','GPS Left+IMU','Hall+IMU+GPS')
% legend('Hall','Hall+IMU+GPS','Hall+IMU')
legend('Location','northwest')
xlim([-50 50]);
ylim([-50 50]);
% figure(3)
% plot(odom_wheel_x, odom_wheel_y)
% legend('Hall')




