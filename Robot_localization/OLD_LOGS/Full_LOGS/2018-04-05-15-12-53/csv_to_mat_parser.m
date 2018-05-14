clear all

% parse topic /odom_wheel 
odom_wheel = readtable('_slash_odom_wheel.csv','Delimiter',',');
odom_wheel_x = table2array(odom_wheel(:,12));
odom_wheel_y = table2array(odom_wheel(:,13));
odom_wheel_orie_z = table2array(odom_wheel(:,18));
odom_wheel_orie_w = table2array(odom_wheel(:,19));
clear odom_wheel

% parse topic /fix
fix = readtable('_slash_fix.csv','Delimiter',',');
latitude = table2array(fix(:,11));
longitude = table2array(fix(:,12));
clear fix

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

% parse topic /odometry/gps
odometry_gps = readtable('_slash_odometry_slash_gps.csv','Delimiter',',');
odometry_gps_x = table2array(odometry_gps(:,12));
odometry_gps_y = table2array(odometry_gps(:,13));
odometry_gps_orie_z = table2array(odometry_gps(:,18));
odometry_gps_orie_w = table2array(odometry_gps(:,19));
clear odometry_gps


% save workspace variables to data.mat file
save data.mat