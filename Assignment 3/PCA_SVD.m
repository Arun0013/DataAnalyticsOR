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

%[V, D] = eig(Covariance);
%if ~issorted(diag(D))
%	[Dsort, Isort] = sort(diag(D), 'descend');
%	Vsort = V(:,Isort);
%end
%V = Vsort;
%D = D(:,Isort);
%Vlim = V(:,1:10);
%Dlim = D(:,1:10);

[U, S, V] = svd(X, 'econ');
D = S.^2/(m-1);

figure	
plot(1:p, diag(D), '-*');
diagD = diag(D);
totalVar = sum(diagD);
for i = 1:p
	%varianceProp(i) = sum(diagD(1:i))/totalVar;
    varianceProp(i) = diagD(i)/totalVar;
end
figure
plot(1:p, varianceProp, 'r-*')
