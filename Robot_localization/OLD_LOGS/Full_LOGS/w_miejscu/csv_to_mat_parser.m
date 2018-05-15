clear all

% parse topic /odom_wheel 
odom_wheel = readtable('_slash_odom_wheel.csv','Delimiter',',');
odom_wheel_x = table2array(odom_wheel(:,12));
odom_wheel_y = table2array(odom_wheel(:,13));
odom_wheel_orie_z = table2array(odom_wheel(:,18));
odom_wheel_orie_w = table2array(odom_wheel(:,19));
clear odom_wheel

% % parse topic /fix_right
% fix_right = readtable('_slash_fix_right.csv','Delimiter',',');
% latitude_right = table2array(fix_right(:,11));
% longitude_right = table2array(fix_right(:,12));
% clear fix_right
% 
% % parse topic /fix_left
% fix_left = readtable('_slash_fix_left.csv','Delimiter',',');
% latitude_left = table2array(fix_left(:,11));
% longitude_left = table2array(fix_left(:,12));
% clear fix_left

% parse topic /odometry/filtered_map
filtered_map = readtable('_slash_odometry_slash_filtered_map.csv','Delimiter',',');
filtered_map_x = table2array(filtered_map(:,12));
filtered_map_y = table2array(filtered_map(:,13));
filtered_map_orie_z = table2array(filtered_map(:,18));
filtered_map_orie_w = table2array(filtered_map(:,19));
clear filtered_map

% parse topic /odometry/filtered_odom
filtered_odom = readtable('_slash_odometry_slash_filtered_odom.csv','Delimiter',',');
filtered_odom_x = table2array(filtered_odom(:,12));
filtered_odom_y = table2array(filtered_odom(:,13));
filtered_odom_orie_z = table2array(filtered_odom(:,18));
filtered_odom_orie_w = table2array(filtered_odom(:,19));
clear filtered_odom

% % parse topic /odometry/gps_left
% odometry_gps_left = readtable('_slash_odometry_slash_gps_left.csv','Delimiter',',');
% odometry_gps_x_left = table2array(odometry_gps_left(:,12));
% odometry_gps_y_left = table2array(odometry_gps_left(:,13));
% odometry_gps_orie_left = table2array(odometry_gps_left(:,18));
% odometry_gps_orie_w_left = table2array(odometry_gps_left(:,19));
% clear odometry_gps_left
% 
% % parse topic /odometry/gps_right
% odometry_gps_right = readtable('_slash_odometry_slash_gps_right.csv','Delimiter',',');
% odometry_gps_x_right = table2array(odometry_gps_right(:,12));
% odometry_gps_y_right = table2array(odometry_gps_right(:,13));
% odometry_gps_orie_right = table2array(odometry_gps_right(:,18));
% odometry_gps_orie_w_right = table2array(odometry_gps_right(:,19));
% clear odometry_gps_right

% save workspace variables to data.mat file
save data.mat