noiseIntensity = 1;
x = 0:.3:2*pi;

y = 2*x + 3;
fit = 1.90533 * x + 3.04937
linePoints = load('linePoints.txt');
g = linePoints(:,2);
figure;
plot(x,y,x,g,'.',x,fit);
legend('sample function', 'with gaussian', 'best fit');

s = 3 * sin(x);
sfit = -0.85834 * x + 2.57318
sinPoints = load('sinPoints.txt');
sg = sinPoints(:,2);
figure(2);
plot(x,s,x,sg,'.',x,sfit);
legend('sample function', 'with gaussian', 'best fit');
