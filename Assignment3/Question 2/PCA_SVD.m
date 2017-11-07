clear;
clc;
close all;

XFileName = 'X.csv';
yFileName = 'y.csv';

X = dlmread(XFileName,',',1,0);
y = dlmread(yFileName,',',1,0);

Xorig = X;

[m p] = size(X);
mean1 = mean(X,1);
X = X - repmat(mean1, m, 1);
Covariance = (1/(m-1))*X'*X;

%Vlim = V(:,1:10);

[U, S, V] = svd(X, 'econ');
D = S.^2/(m-1);

Vlim = V(:,1:10);


figure
plot(1:p, diag(D), '-*');
diagD = diag(D);
totalVar = sum(diagD);
for i = 1:p
        %varianceProp(i) = sum(diagD(1:i))/totalVar;
    varianceProp(i) = diagD(i)/totalVar;
end
xlabel('Index of Eigen Value');
ylabel('Eigen Value');
title('SVD: Scree');
figure
plot(1:p, varianceProp, 'r-*')
xlabel('Index of Eigen Value');
ylabel('Proportion of Variance');
title('SVD: Proportion of Variance');

sample = input('\nEnter serial number of the data (Enter 0 to escape) to view the constructed image: ');
while(sample ~= 0)
        Xnew = 255 - Xorig;
        pixel = 8;
        figure;
        subplot(1,2,1);
        z = reshape(Xnew(sample, :), pixel, pixel);
        imagesc(z');
        colormap(gray);
        title('Original Image');

        Xnew = X*Vlim*Vlim';
        Xnew = Xnew + repmat(mean1, m, 1);
        Xnew = 255 - Xnew;
        %figure;
        subplot(1,2,2)
        z = reshape(Xnew(sample, :), pixel, pixel);
        imagesc(z');
        colormap(gray);
        title('SVD: Reconstruted Image');
        sample = input('\nEnter serial number of the data (Enter 0 to escape) to view the constructed image: ');
end

fprintf('\n\nFirst 10 components (each column represents a component):\n');
display(Vlim);

