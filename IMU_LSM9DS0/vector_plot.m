close all;
x = 0;
y = 0;

for i = 1:50:length(a_x)
    
    u = m_x(i);
    v = m_y(i);
    compass(u,v);
    drawnow
   
end