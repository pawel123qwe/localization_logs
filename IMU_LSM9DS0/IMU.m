clear all
close all
load outdoor4.mat

% Wartoœæ przyspieszenia ziemskiego dla Krakowa
g = 9.8105;
% wartoœæ inklinacji magnetycznej dla Krakowa
gamma = deg2rad(66+22/60);
% wartoœæ deklinacji magnetycznej dla Krakowa POSITIVE (EAST)
alfa = deg2rad(5+11/60);

time = VarName2;

for i = 1:length(time)-1
    diff_time = time(i+1)-time(i);
end
dt = mean(diff_time);


% Oznaczenia na wartoœci przyspieszeñ w uk³adzie RPY uk³adu
% S¹ to wartoœci które zwraca IMU (+- 2g)
a_x = VarName3;
a_y = VarName4;
a_z = VarName5;

a_x = a_x*(4*g)/2^16;
a_y = a_y*(4*g)/2^16;
a_z = a_z*(4*g)/2^16;

% Oznaczenia na wartoœci znormalizowane wektorów pola magnetycznego 
% w uk³adzie RPY mierzone przez IMU (+- 2g)

m_x = VarName9*(4)/2^16;
m_y = VarName10*(4)/2^16;
m_z = VarName11*(4)/2^16;

% Normalizacja danych z magnetometru

for i = 1:length(m_x)
    
    norma = sqrt( (m_x(i))^2 + (m_y(i))^2 + (m_z(i))^2 );
    m_x(i) = m_x(i)/norma;
    m_y(i) = m_y(i)/norma;
    m_z(i) = m_z(i)/norma;
    m_xy_norm(i) = sqrt( (m_x(i))^2 + (m_y(i))^2)/norma;
    m_xyz_norm(i) = sqrt( (m_x(i))^2 + (m_y(i))^2 + (m_z(i))^2 );

end

% predkosci katowe (-245 to 245 dps)
w_x = VarName6*491/2^16;
w_y = VarName7*491/2^16;
w_z = VarName8*491/2^16;


% Filtracja Kalman

% dane mierzone przez IMU
y(9,length(time)) = 0;
y(1,:) = a_x; % predkoœci k¹towe (¿yroskop)
y(2,:) = a_y;
y(3,:) = a_z;
y(4,:) = w_x; % przyspieszenia (akcelerometr)
y(5,:) = w_y;
y(6,:) = w_z;
y(7,:) = m_x; % natê¿enia pola magnetycznego (magnetometr)
y(8,:) = m_y;
y(9,:) = m_z;

% wariancje
var_a_x = 0.0042;
var_a_y = 0.0016;
var_a_z = 0.0118;
var_w_x = 0.1514;
var_w_y = 0.2027;
var_w_z = 0.1789;
var_m_x = 0.0002;
var_m_y = 0.0002;
var_m_z = 0.0002;
variance = [ var_a_x; var_a_y; var_a_z; var_w_x; var_w_y; var_w_z; var_m_x; var_m_y; var_m_z ];
var_procesowa = 0.000001;

% model stanowy
A = eye(9);
C = eye(9);

% macierze kowiariancji szumów
V = var_procesowa * eye(9,9);
W = variance.*eye(9,9);

% wartoœci pocz¹tkowe
x_0 = y(:,1);

P0 = eye(9);
for i=1:9
    P0(i,i)=3*variance(i);
end
x_pri_model_1 = x_0;
Ppri = P0;
x_post = x_0;
Ppost = P0;
filtered_y(:,1)=x_0;

for i=2:length(time)
    
    % predykcja
    x_pri_model_1(:,i) = A*x_post;
    Ppri = A*Ppost*A' + V;
    
    %korekcja
    eps_model = y(:,i) - C*x_pri_model_1(:,i);
    S = C*Ppri*C' + W;
    K = Ppri*C'*S^(-1);
    x_post = x_pri_model_1(:,i) + K*eps_model;
    Ppost = Ppri - K*S*K';
    filtered_y(:,i) = x_post;
    
end

% for i=1:9
%     figure(i);
%     plot(time,y(i,:));
%     hold on
%     plot(time,filtered_y(i,:));
%     legend('Real','Filtered');
% end

a_x = filtered_y(1,:);
a_y = filtered_y(2,:);
a_z = filtered_y(3,:);
w_x = filtered_y(4,:);
w_y = filtered_y(5,:);
w_z = filtered_y(6,:);
m_x = filtered_y(7,:);
m_y = filtered_y(8,:);
m_z = filtered_y(9,:);

% Obliczenie k¹tów RPY

for i = 1:length(a_x)
    
    % Accelerometer and Magnetometer

    Roll(i) = atan2(a_y(i),a_z(i));
    Gz2 = a_y(i)*sin(Roll(i))+a_z(i)*cos(Roll(i));
    Pitch(i) = atan(-a_x(i)/Gz2);
    
    By2 = m_z(i)*sin(Roll(i)) - m_y(i)*cos(Roll(i));
    Bz2 = m_y(i)*sin(Roll(i)) + m_z(i)*cos(Roll(i));
    Bx3 = m_x(i)*cos(Pitch(i)) + Bz2*sin(Pitch(i));
    
    Yaw(i) = atan2(By2,Bx3);
    
    Roll(i) = rad2deg(Roll(i));
    Pitch(i) = rad2deg(Pitch(i));
    Yaw(i) = rad2deg(Yaw(i));

end

figure(10);
subplot(3,1,1);
plot(time,Roll);
title('Obrót wokó³ X');

subplot(3,1,2);
plot(time,Pitch);
title('Obrót wokó³ Y');

subplot(3,1,3);
plot(time,Yaw);
hold on
% plot(time,VarName14);
title('Obrót wokó³ Z');