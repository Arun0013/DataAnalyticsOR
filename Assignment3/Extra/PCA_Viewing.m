clear;
clc;
close all;

XFileName = 'X.csv';
yFileName = 'y.csv';

X = 255-dlmread(XFileName,',',1,0);
y = dlmread(yFileName,',',1,0);

pixel = 8;
figure;
z = reshape(X(6, :), pixel, pixel);
imagesc(z'); 

colormap(gray);
