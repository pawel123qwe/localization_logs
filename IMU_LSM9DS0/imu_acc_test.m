clear all
close all

bag = rosbag('2018-05-28-19-37-26.bag');
bag_log_vect = bag.readMessages;

acc_x = 0;
acc_y = 0;
acc_z = 0;

rotM=    [0.990977750298954                   0  -0.134026483996349;
         -0.130530967661718   0.226895061152551  -0.965132269539194;
          0.030409947282413   0.973919211857216   0.224847957254899];

scale = 1.031194047731898;
% rot_grav = rotM*[-9.8105;0;0];
rot_grav=[ -9.717251422104319;1.314226320238042;0.306176793381113];
grav = [-9.8105;0;0];

result_vect=zeros(3,length(bag_log_vect));
for i = 1:length(bag_log_vect)
    msg = bag_log_vect{i,1};
    acc_x(i) = scale*msg.LinearAcceleration.X;
    acc_y(i) = scale*msg.LinearAcceleration.Y;
    acc_z(i) = scale*msg.LinearAcceleration.Z;
    
    % Rotacja wektora
%     result_vect(:,i) = rotM*[acc_z(i);acc_y(i);acc_x(i)]-grav;

    % Czysty wektor
%     result_vect(:,i) = [acc_z(i);acc_y(i);acc_x(i)];

    % Odj�ty zrotowany wektor grawitacji
    result_vect(:,i) = [acc_z(i);acc_y(i);acc_x(i)] - rot_grav;
    
        
end
%%
% close all
% q=[];
% %  for i=-0:0.01:180
% eul_x = [0,0,1.341907920829440];
% eul_y = [0,-0.134431017763848,0];
% eul_z = [deg2rad(    1.121500000000000e+02),0,0];
% rotX = eul2rotm(eul_x);
% rotY = eul2rotm(eul_y);
% rotZ = eul2rotm(eul_z);
% 
% 
% % rotM = rotX*rotY
% rotM = rotX*rotY*rotZ;
% 
% result_vect_rot=rotM*result_vect;
% 
% q=[ q mean(abs(result_vect_rot(2,:)))];
% 
% %  end
% % [val index]=min(q)

eul_x = [0,0,1.341907920829440];
eul_y = [0,-0.134431017763848,0];
eul_z = [deg2rad(    1.121500000000000e+02),0,0];

% close all
% figure(1)
% subplot(3,1,1)
% plot(result_vect(3,:))
% title('X');
% subplot(3,1,2)
% plot(result_vect(2,:))
% title('Y');
% subplot(3,1,3)
% plot(result_vect(1,:))
% title('Z');

figure(2)
subplot(3,1,1)
plot(result_vect_rot(3,:))
title('X_rot');
subplot(3,1,2)
plot(result_vect_rot(2,:))
title('Y_rot');
subplot(3,1,3)
plot(result_vect_rot(1,:))
title('Z_rot');
