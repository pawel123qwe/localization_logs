%clear all
close all
load ws.mat

% dane mierzone przez IMU
y(9,length(time)) = 0;
y(1,:) = w_x; % predkoœci k¹towe (¿yroskop)
y(2,:) = w_y;
y(3,:) = w_z;
y(4,:) = a_x; % przyspieszenia (akcelerometr)
y(5,:) = a_y;
y(6,:) = a_z;
y(7,:) = m_x; % natê¿enia pola magnetycznego (magnetometr)
y(8,:) = m_y;
y(9,:) = m_z;

% wariancje
var_w_x = 0.1514;
var_w_y = 0.2027;
var_w_z = 0.1789;
var_a_x = 0.0042;
var_a_y = 0.0016;
var_a_z = 0.0118;
var_m_x = 0.0002;
var_m_y = 0.0002;
var_m_z = 0.0002;
variance = [ var_w_x; var_w_y; var_w_z; var_a_x; var_a_y; var_a_z; var_m_x; var_m_y; var_m_z ];
var_procesowa = 0.000001;

% model stanowy
A = 1;
C = 1;

% macierze kowiariancji szumów
V = var_procesowa * ones(9,1);
W = variance;

% wartoœci pocz¹tkowe
for i=1:9
    x_0(i)=y(i,1);
    P0(i)=3*variance(i);
end
x_pri = x_0;
Ppri = P0;
x_post = x_0;
Ppost = P0;
filtered_y(:,1)=x_0;

for i=2:length(time)
    for j=1:9

        % predykcja
        x_pri(j) = A*x_post(j);
        Ppri(j) = A*Ppost(j)*A' + V(j);

        %korekcja
        eps(j) = y(j,i) - C*x_pri(j);
        S(j) = C*Ppri(j)*C' + W(j);
        K(j) = Ppri(j)*C'*(S(j))^(-1);
        x_post(j) = x_pri(j) + K(j)*eps(j);
        Ppost(j) = Ppri(j) - K(j)*S(j)*(K(j))';
        filtered_y(j,i) = x_post(j);
        
    end
end

for i=1:9
    figure(i);
    plot(time,y(i,:));
    hold on
    plot(time,filtered_y(i,:));
    legend('Real','Filtered');
end
