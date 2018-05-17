%%
close all
clear all
load log4.mat


n=7;
yaw=[]
num=1;


W = 3; % wariancja Yaw
V = 0.00001; % wariancja procesowa

% Model stanowy
A = 1;
C = 1;

P0 = 10;
x_0 = 0;
x_pri_model_1 = x_0;
Ppri = P0;
x_post = x_0;
Ppost = P0;
filtered_yaw = x_0;

%km/h
velocity=10;
vel_deviation=10;
front_wheel=0;
yaw_max_vel = 0.05;
dist_threshold = 0.1;

min_delta=((velocity-vel_deviation)*1000/(3600*20))*n
if min_delta < dist_threshold
    min_delta = dist_threshold;
end
max_delta=((velocity+vel_deviation)*1000/(3600*20))*n


for i=1:length(easting)-n
       
        north=northing(i:i+n-1);
        east=easting(i:i+n-1);

        north=north-min(north);
        east=east-min(east);
        vect_lenght(i)=sqrt((max(north)-min(north))^2 + (max(east)-min(east))^2);
       
        if vect_lenght(i) > min_delta &&  vect_lenght(i) < max_delta
            
           p=polyfit(north,east,1)
            % Nachylenie prostej jest liczone od wschodu
            if north(1) < north(n) && east(1) < east(n) && (0 < rad2deg(atan(p(1))) < 90)
                % I �wiartka
                yaw(num) = rad2deg(atan(p(1)));
            elseif north(1) < north(n) && east(1) > east(n) && (-90 < rad2deg(atan(p(1))) < 0)
                % IV �wiartka
                yaw(num) = rad2deg(atan(p(1)))+360;
            elseif north(1) > north(n) && east(1) > east(n) && (0 < rad2deg(atan(p(1))) < 90)
                % III �wiartka
                yaw(num) = rad2deg(atan(p(1)))+180;
            elseif north(1) > north(n) && east(1) < east(n) && (-90 < rad2deg(atan(p(1))) < 0)
                % II �wiartka
                yaw(num) = rad2deg(atan(p(1)))+180;
            elseif p(1) == Inf
                yaw(num) = 90;
            elseif p(1) == -Inf
                yaw(num) = 270;
            elseif num>1
                yaw(num) = yaw(num-1);
            end

            if num > 1
                
                if (abs(yaw(num)-yaw(num-1)) > yaw_max_vel)
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
                S = C*Ppri*C' + W;
                K = Ppri*C'*S^(-1);
                x_post = x_pri_model_1(num) + K*eps_model;
                Ppost = Ppri - K*S*K';
                filtered_yaw(num) = x_post;
            end
            num=num+1;

        end
       
end

figure(1)
plot(yaw);
hold on
plot(filtered_yaw,'LineWidth',2)
legend('Real','Filtered');

%%

