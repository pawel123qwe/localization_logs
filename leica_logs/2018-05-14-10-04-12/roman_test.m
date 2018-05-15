%%
close all
clear all
% load long_lat.mat
load north_east.mat

longitude=north;
latitude=east;

% longitude=flip(north);
% latitude=flip(east);

% longitude=east;
% latitude=north;

% longitude=flip(east);
% latitude=flip(north);

n=4;
yaw=[]
num=1;

%km/h
velocity=5;
vel_deviation=2;
front_wheel=0;

min_delta=((velocity-vel_deviation)*1000/(3600*20))*n
max_delta=((velocity+vel_deviation)*1000/(3600*20))*n

for i=1:length(latitude)-n
       
       lon=longitude(i:i+n-1);
       lat=latitude(i:i+n-1);
       
       lon=lon-min(lon);
       lat=lat-min(lat);
       vect_lenght(i)=sqrt((max(lon)-min(lon))^2 + (max(lat)-min(lat))^2);
       
        if vect_lenght(i) > min_delta &&  vect_lenght(i) < max_delta && status(i) ==1
           p=polyfit(lon,lat,1);
           rad2deg(atan(p(1)))     
            % Nachylenie prostej jest liczone od wschodu
            if lon(1) < lon(n) && lon(1) < lon(n)
                % I �wiartka
                yaw(num) = rad2deg(atan(p(1)));
            end

            if lon(1) < lon(n) && lon(1) > lon(n)
                % IV �wiartka
                yaw(num) = rad2deg(atan(p(1)))+360;
            end

            if lon(1) > lon(n) && lon(1) > lon(n)
                % III �wiartka
                yaw(num) = rad2deg(atan(p(1)))+180;
            end

            if lon(1) > lon(n) && lon(1) < lon(n)
                % II �wiartka
                yaw(num) = rad2deg(atan(p(1)))+180;
            end
           num=num+1;
        end
       
end
figure(1)
plot(yaw);

%%

