clear all
format long

bag = rosbag('2018-05-28-08-47-01.bag');
bag_log_vect = bag.readMessages;


acc_x = 0;
acc_y = 0;
acc_z = 0;

for i = 1:length(bag_log_vect)
    msg = bag_log_vect{i,1};
    acc_x(i) = msg.LinearAcceleration.X;
    acc_y(i) = msg.LinearAcceleration.Y;
    acc_z(i) = msg.LinearAcceleration.Z;
end

m_z = mean(acc_z);
m_y = mean(acc_y);
m_x = mean(acc_x);

vect_len = sqrt(m_x^2 + m_y^2 + m_z^2);
grav = 9.8105;
scale = grav/vect_len;
m_x = m_x*scale;
m_y = m_y*scale;
m_z = m_z*scale;

% rad2deg(atan2(m_x,m_y)) = 13.11
% rad2deg(atan2(m_x,m_z)) = 178.19
% rad2deg(atan2(m_y,m_x)) = 76.86
% rad2deg(atan2(m_y,m_z)) = 172.30
% rad2deg(atan2(m_z,m_x)) = -88.19
% rad2deg(atan2(m_z,m_y)) = -82.30

vect_imu = [m_z; m_y; m_x];
eul_x = [0,0,atan2(m_y,m_x)];
eul_y = [0,-pi/2-atan2(m_z,m_y),0];
% eul_x = [0,0,deg2rad(76.8857)];
% eul_y = [0,deg2rad(-7.906),0];
rotX = eul2rotm(eul_x);
rotY = eul2rotm(eul_y);

result_x = rotX*vect_imu;
result_xy = rotY*result_x

rotM = rotX*rotY;