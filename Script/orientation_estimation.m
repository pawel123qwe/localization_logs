%%
close all
clear all
<<<<<<< Updated upstream
load log1.mat
=======
load log2.mat
>>>>>>> Stashed changes

% liczba probek uzywanych do regresji liniowej
n=4;

% wektor wyliczonych katow
yaw=[];

% parametry filtru Kalmana - wariancja W b�dzie zalezna od aktualnej
% dokladnosci
W = 3; % wariancja Yaw
V = 0.05; % wariancja procesowa

% Model stanowy
A = 1;
C = 1;

% Poczatkowe wartosci filtru
P0 = 360;
x_0 = 0;
x_pri_model_1 = x_0;
Ppri = P0;
x_post = x_0;
Ppost = P0;
filtered_yaw = x_0;

%km/h
velocity=10; % aktualna pr�dkosc - jest liczona z enkoderow
vel_deviation=10; % dokladnosc wyznaczenia predkosci
front_wheel=0; % kat skrecenia kol
yaw_max_vel = 4; % maksymalna predkosc katowa
dist_threshold = 0.03; % minimalny dystans przejechany przez EVE aby estymacja kata miala sens

min_delta=((velocity-vel_deviation)*1000/(3600*20))*n;
if min_delta < dist_threshold
    min_delta = dist_threshold;
end
max_delta=((velocity+vel_deviation)*1000/(3600*20))*n;

full_rotations=0;

num=1;
for i=1:length(easting)-n
    
    % Wybor n probek z loga - w czasie rzeczywistym wymagany b�dzie rejestr
    % przesuwny.
    north=northing(i:i+n-1);
    east=easting(i:i+n-1);
    
    % Sprowadzenie do poczatku uk�adu celem unikniecia bledow numerycznych
    north=north-min(north);
    east=east-min(east);
    
    % Dystans przejechany przez EVE liczony z ostatnich n probek
    vect_lenght(i)=sqrt((max(north)-min(north))^2 + (max(east)-min(east))^2);
    
    % Sprawdzamy czy EVE przejechala minimalny dystans i czy nie wystapil
    % blad gruby - jesli tak - nie wyliczamy kata.
    if vect_lenght(i) > min_delta &&  vect_lenght(i) < max_delta && status(i)~=-1
        
        % Funkcja zwracajaca wspolczynniki prostej regresji
        p=polyfit(north,east,1);
        
        % Nachylenie prostej jest liczone od wschodu ( X - easting )
        % Podajemy wartosc kata od 0 do 2pi - a wiec musimy rozpoznawac
        % cwiartke zeby okreslic zarowno zwrot jak i kierunek EVE
        yaw_temp(num) = rad2deg(atan(p(1)));
        if north(1) < north(n) && east(1) < east(n) && (0 < rad2deg(atan(p(1)))) && ( rad2deg(atan(p(1))) < 90)
            % I cwiartka
            yaw(num) = rad2deg(atan(p(1)));
        elseif north(1) < north(n) && east(1) > east(n) && (-90 < rad2deg(atan(p(1)))) && (rad2deg(atan(p(1))) < 0)
            % IV cwiartka
            yaw(num) = rad2deg(atan(p(1)))+360;
        elseif north(1) > north(n) && east(1) > east(n) && (0 < rad2deg(atan(p(1)))) && (rad2deg(atan(p(1))) < 90)
            % III cwiartka
            yaw(num) = rad2deg(atan(p(1)))+180;
        elseif north(1) > north(n) && east(1) < east(n) && (-90 < rad2deg(atan(p(1)))) && ( rad2deg(atan(p(1))) < 0)
            % II cwiartka
            yaw(num) = rad2deg(atan(p(1)))+180;
        elseif p(1) == Inf
            yaw(num) = 90;
        elseif p(1) == -Inf
            yaw(num) = 270;
        elseif num>1
            yaw(num) = yaw(num-1);
        end
        
        
        if num > 1
            
            if (abs(yaw(num)-yaw(num-1)) > yaw_max_vel) && abs(yaw(num)-yaw(num-1))<310 
                if yaw(num) >= yaw(num-1)
                    yaw(num) = yaw(num-1)+yaw_max_vel;
                else
                    yaw(num) = yaw(num-1)-yaw_max_vel;
                end
            end
            
            
            
            % Filtr Kalmana
            % predykcja
            x_pri_model_1(num) = A*x_post;
            Ppri = A*Ppost*A' + V;
            
            %korekcja
            eps_model = yaw(num) - C*x_pri_model_1(num);
            Hist_eps_model(num) = eps_model;
            S = C*Ppri*C' + W;
            K = Ppri*C'*S^(-1);
            Hist_S(num) = S;
            Hist_K(num) = K;
            x_post = x_pri_model_1(num) + K*eps_model;
            Ppost = Ppri - K*S*K';
            filtered_yaw(num) = x_post;
            if abs(eps_model) > 300
                Ppri = 360;
                Ppost = 360;
            end
        end
        num=num+1;
        
    end
    
end

figure(1)
plot(yaw);
hold on
plot(filtered_yaw,'LineWidth',2)
legend('Real','Filtered');

figure(2)
plot(easting-min(easting),northing-min(northing));
title('Trasa');
xlabel('Easting');
ylabel('Northing');
axis equal

figure(3)
plot(easting-min(easting));
hold on
plot(northing-min(northing));
hold off
legend('Easting','Northing');

%%

