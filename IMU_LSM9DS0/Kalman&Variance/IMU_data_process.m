clear all
load ws.mat

% a_x = VarName3;
% a_y = VarName4;
% a_z = VarName5;
% m_x = VarName9*(4)/2^16;
% m_y = VarName10*(4)/2^16;
% m_z = VarName11*(4)/2^16;
% w_x = VarName6*491/2^16;
% w_y = VarName7*491/2^16;
% w_z = VarName8*491/2^16;

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

% figure(1);
% subplot(3,1,1);
% plot(time,a_x);
% title('a_x');
% 
% subplot(3,1,2);
% plot(time,a_y);
% title('a_y');
% 
% subplot(3,1,3);
% plot(time,a_x);
% title('a_z');

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

end

% predkosci katowe (-245 to 245 dps)
w_x = VarName6*491/2^16;
w_y = VarName7*491/2^16;
w_z = VarName8*491/2^16;

% figure(1);
% subplot(3,1,1);
% plot(time,w_x);
% title('w_x');
% 
% subplot(3,1,2);
% plot(time,w_y);
% title('w_y');
% 
% subplot(3,1,3);
% plot(time,w_x);
% title('w_z');

for i = 1:length(a_x)
    
    phi(i) = atan2(a_y(i), a_z(i));
    temp(i) = ( -a_x(i)*sin(phi(i)) )/ ( a_y(i) );
    theta(i) = atan2(( -a_x(i)*sin(phi(i)) ), ( a_y(i) ));
    theta_2(i) = atan2(( -a_x(i)*sin(phi(i)) ), ( a_y(i) ));
    psi(i) = atan2( ( m_z(i)*sin(phi(i))-m_y(i)*cos(phi(i)) ), ( m_x(i)*cos(theta(i))+m_y(i)*sin(phi(i))*sin(theta(i))+m_z(i)*cos(phi(i))*sin(theta(i)) ) );

    phi(i) = rad2deg(phi(i));
    theta(i) = rad2deg(theta(i));
    psi(i) = rad2deg(psi(i));

end

figure(2);
subplot(3,1,1);
plot(time,phi);
title('Obrót wokó³ X');

subplot(3,1,2);
plot(time,theta_2);
title('Obrót wokó³ Y - atan2');

subplot(3,1,3);
plot(time,psi);
title('Obrót wokó³ Z');

% F = [1 0 0 dt 0 0 -dt 0 0;
%      0 1 0 0 dt 0 0 -dt 0;
%      0 0 1 0 0 dt 0 0 -dt;
%      0 0 0 1 0 0 0 0 0;
%      0 0 0 0 1 0 0 0 0;
%      0 0 0 0 0 1 0 0 0;
%      0 0 0 0 0 0 1 0 0;
%      0 0 0 0 0 0 0 1 0;
%      0 0 0 0 0 0 0 0 1;];
%  
%  Q = [dt 0 0 0 0 0;
%       0 dt 0 0 0 0;
%       0 0 dt 0 0 0;
%       1 0 0 0 0 0;
%       0 1 0 0 0 0;
%       0 0 1 0 0 0;
%       0 0 0 1 0 0;
%       0 0 0 0 1 0;
%       0 0 0 0 0 1;];
%   
%   H = [1 0 0 0 0 0 0 0 0;
%        0 1 0 0 0 0 0 0 0;
%        0 0 1 0 0 0 0 0 0;
%        0 0 0 1 0 0 0 0 0;
%        0 0 0 0 1 0 0 0 0;
%        0 0 0 0 0 1 0 0 0;];
%    
% % wariancje
% var_w_x = 0.1514;
% var_w_y = 0.2027;
% var_w_z = 0.1789;
% var_a_x = 0.0042;
% var_a_y = 0.0016;
% var_a_z = 0.0118;
% var_m_x = 0.0002;
% var_m_y = 0.0002;
% var_m_z = 0.0002;
% 
% var_phi = 0.3969;
% var_theta_2 = 1;
% var_psi = 11.12;
% var_eps = 1;
%    
% % pocz¹tkowa wartoœæ wektora stanu
% x_0 = [phi(1); theta_2(1); psi(1); w_x(1); w_y(1); w_z(1); 0; 0; 0];
% P0 = eye(9);
% x_pri = x_0;
% Ppri = P0;
% x_post = x_0;
% Ppost = P0;
% filtered_y(:,1)=x_0;
% 
% % modelowany szum
% r_k = [var_phi; var_theta_2; var_psi; var_w_x; var_w_y; var_w_z];
% w_k = [var_w_x; var_w_y; var_w_z; var_eps; var_eps; var_eps];
% W = 0.0001*eye(6);
% R = r_k.*eye(6);
% 
% for i= 2:length(time)
%     % okreœlenie y_k
%     y_k = [phi(i); theta_2(i); psi(i); w_x(i); w_y(i); w_z(i)];
%     
%     % predykcja
%     x_pri(:,i)=F*x_post;
%     Ppri = F*Ppost*transpose(F)+Q*W*transpose(Q);
%     
%     % korekcja
%     eps_model = y_k - H*x_pri(:,i);
%     S = H*Ppri*transpose(H)+R;
%     K = Ppri*H'*S^(-1);
%     x_post = x_pri(:,i) + K*eps_model;
%     Ppost = Ppri - K*S*K';
%     filtered_y(:,i) = x_post;
%  
% end
% 
% figure(1);
% plot(time,psi);
% hold on
% plot(time,filtered_y(3,:));
% legend('real','filtered');
