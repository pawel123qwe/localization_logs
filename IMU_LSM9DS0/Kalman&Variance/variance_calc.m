clear all

load variance_logs.mat

for i = 1:length(m_x)
    
    norma = sqrt( (m_x(i))^2 + (m_y(i))^2 + (m_z(i))^2 );
    m_x(i) = m_x(i)/norma;
    m_y(i) = m_y(i)/norma;
    m_z(i) = m_z(i)/norma;

end

for i = 1:length(a_x)
    
    phi(i) = atan2(a_y(i), a_z(i));
    temp(i) = ( -a_x(i)*sin(phi(i)) )/ ( a_y(i) );
    theta(i) = atan(( -a_x(i)*sin(phi(i)) )/ ( a_y(i) ));
    theta_2(i) = atan2(( -a_x(i)*sin(phi(i)) ), ( a_y(i) ));
    psi(i) = atan2( ( m_z(i)*sin(phi(i))-m_y(i)*cos(phi(i)) ), ( m_x(i)*cos(theta(i))+m_y(i)*sin(phi(i))*sin(theta(i))+m_z(i)*cos(phi(i))*sin(theta(i)) ) );

    phi(i) = rad2deg(phi(i));
    theta(i) = rad2deg(theta(i));
    psi(i) = rad2deg(psi(i));

end

% obliczenie wymaganych do filtra wariancji

% obliczenie wariancji wyznaczenia przyspieszenia z magnetometrów
mean_m_x = mean(m_x);
mean_m_y = mean(m_y);
mean_m_z = mean(m_z);
var_m_x = var(m_x-mean_m_x);
var_m_y = var(m_y-mean_m_y);
var_m_z = var(m_z-mean_m_z);

% obliczenie wariancji wyznaczenia przyspieszenia z akcelerometrów
mean_a_x = mean(a_x);
mean_a_y = mean(a_y);
mean_a_z = mean(a_z);
var_a_x = var(a_x-mean_a_x);
var_a_y = var(a_y-mean_a_y);
var_a_z = var(a_z-mean_a_z);


% obliczenie wariancji wyznaczenia prêdkosci k¹towej z zyroskopów
mean_w_x = mean(w_x);
mean_w_y = mean(w_y);
mean_w_z = mean(w_z);
var_w_x = var(w_x-mean_w_x);
var_w_y = var(w_y-mean_w_y);
var_w_z = var(w_z-mean_w_z);

% obliczenie wariancji wyznaczenia katów RPY w uk³adzie NWU
mean_phi = mean(phi);
mean_theta_2 = mean(theta_2);
mean_psi = mean(psi);
var_phi = var(phi-mean_phi);
var_theta_2 = var(theta_2 - mean_theta_2);
var_psi = var(psi-mean_psi);



figure(1);
subplot(3,1,1);
plot(time,phi);
hold on
plot(time,mean_phi*ones(1,length(phi)));
hold off
title('Obrót wokó³ X - phi');

subplot(3,1,2);
plot(time,theta_2);
hold on
plot(time,mean_theta_2*ones(1,length(theta_2)));
hold off
title('Obrót wokó³ Y - theta_2');

subplot(3,1,3);
plot(time,psi);
hold on
plot(time,mean_psi*ones(1,length(psi)));
hold off
title('Obrót wokó³ Z - psi');

figure(2);
subplot(3,1,1);
plot(time,phi-mean_phi);
title('Szum phi');

subplot(3,1,2);
plot(time,theta_2-mean_theta_2);
title('Szum theta_2');

subplot(3,1,3);
plot(time,psi-mean_psi);
title('Szum psi');

figure(3);
subplot(3,1,1);
plot(time,w_x);
hold on
plot(time,mean_w_x*ones(1,length(w_x)));
hold off
title('w_x');

subplot(3,1,2);
plot(time,w_y);
hold on
plot(time,mean_w_y*ones(1,length(w_y)));
hold off
title('w_y');

subplot(3,1,3);
plot(time,w_x);
hold on
plot(time,mean_w_x*ones(1,length(w_x)));
hold off
title('w_z');

figure(4);
subplot(3,1,1);
plot(time,w_x-mean_w_x);
title('Szum w_x');

subplot(3,1,2);
plot(time,w_y-mean_w_y);
title('Szum w_y');

subplot(3,1,3);
plot(time,w_z-mean_w_z);
title('Szum w_z');

figure(5);
subplot(3,1,1);
plot(time,m_x);
hold on
plot(time,mean_m_x*ones(1,length(m_x)));
hold off
title('m_x');

subplot(3,1,2);
plot(time,m_y);
hold on
plot(time,mean_m_y*ones(1,length(m_y)));
hold off
title('m_y');

subplot(3,1,3);
plot(time,m_x);
hold on
plot(time,mean_m_x*ones(1,length(m_x)));
hold off
title('m_z');

figure(6);
subplot(3,1,1);
plot(time,m_x-mean_m_x);
title('Szum m_x');

subplot(3,1,2);
plot(time,m_y-mean_m_y);
title('Szum m_y');

subplot(3,1,3);
plot(time,m_z-mean_m_z);
title('Szum m_z');
