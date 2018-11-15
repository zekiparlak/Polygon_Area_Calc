clear all
close all
clc

t = load('coords.txt');

for i=1:size(t,1)
    x(i) = t(i,1);
    y(i) = t(i,2);
end

cx = mean(x);
cy = mean(y);
a = atan2(y-cy,x-cx);
[~,order] = sort(a,"descend");
x = x(order);
y = y(order);

x(size(t,1) + 1) = x(1);
y(size(t,1) + 1) = y(1);

counter_monte = 0;
N = 10**4;

rand_x(1) = min(x) + (max(x) - min(x))*rand();
rand_y(1) = min(y) + (max(y) - min(y))*rand();
rand_x(2) = rand_x(1) + (max(x) - min(x));
rand_y(2) = rand_y(1);
count = 0;

for m=1:N
    rand_x(1) = min(x) + (max(x) - min(x))*rand();
    rand_y(1) = min(y) + (max(y) - min(y))*rand();
    rand_x(2) = rand_x(1) + (max(x) - min(x));
    rand_y(2) = rand_y(1);
    r_x(m) = rand_x(1);
    r_y(m) = rand_y(1);
    count = 0;
    for i=1:size(t,1)
        if(((rand_y(1) < y(i)) && (rand_y(1) > y(i+1))) || ((rand_y(1) > y(i)) && (rand_y(1) < y(i+1))))
            if((x(i) >= rand_x(1)) && (x(i) <= rand_x(2)))
                if((x(i+1) >= rand_x(1)) && (x(i+1) <= rand_x(2)))
                    count = count + 1;
                end
            end
        end
    end
    if(mod(count,2) == 1)
      counter_monte = counter_monte + 1;
    end
end

ratio = counter_monte/N;
h_size = max(y) - min(y);
v_size = max(x) - min(x);
rec_area = h_size * v_size;
area = ratio * rec_area;
plot(y,x,"*-r",r_y,r_x,".b");

A = 0;
B = 0;
for i=1:size(t,1)
    A = A + x(i) * y(i+1);
    B = B + y(i) * x(i+1) ;
end
S = 1/2*(abs(A-B));
err = ((S-area)/S)*100;
clc
fprintf("Area Monte Carlo: %.3f m^2\n",area);
fprintf("Area Formula: %.3f m^2\n",S);
fprintf("Error: %%%f\n",err);