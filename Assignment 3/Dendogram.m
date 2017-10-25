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

[V, D] = eig(Covariance);
if ~issorted(diag(D))
	[Dsort, Isort] = sort(diag(D), 'descend');
	Vsort = V(:,Isort);
end
V = Vsort;
D = D(:,Isort);

redDim = 2;
Vlim = V(:,1:redDim);
Dlim = D(:,1:redDim);

X = X*Vlim;

m = size(X,1);

for i = 1:m
	for j = 1:redDim
		ClusterMatrix(i,1,j) = X(i,j);
		ClusterSize(i) = 1;
	end
end
nCluster = length(ClusterSize);

ClusterSymmetry  = zeros(nCluster, nCluster);
for i = 1:nCluster-1
	for j = i+1:nCluster
		symmetry = (ClusterMatrix(i,1,1) - ClusterMatrix(j,1,1))^2 + (ClusterMatrix(i,1,2) - ClusterMatrix(j,1,2))^2;
		ClusterSymmetry(i,j) = symmetry;
		ClusterSymmetry(j,i) = symmetry;
	end
end
ClusterSymmetry = (max(max(ClusterSymmetry))+1)*eye(nCluster, nCluster) + ClusterSymmetry;

[M1, I1] = min(ClusterSymmetry);
[M2, I2] = min(M1);
columnNumber = I2(1);
rowNumber = I1(columnNumber);

newCluster = min([rowNumber, columnNumber]);
remCluster = max([rowNumber, columnNumber]);
currentClusterSize = size(ClusterMatrix(newCluster, :, :), 1);
for j = currentClusterSize+1 : currentClusterSize+ClusterSize(remCluster)
	for k = 1:redDim
		ClusterMatrix(newCluster, j, k) = ClusterMatrix(remCluster, j - currentClusterSize, k);
	end
end
ClusterSize(newCluster) = currentClusterSize+ClusterSize(remCluster);
ClusterMatrix(remCluster, :, :) = [];
ClusterSize(remCluster) = [];
nCluster = length(ClusterSize);

%{
for i = 1:size(X,1)
	if(y(i) == 0)
		hold on;
		plot(X(i,1),X(i,2),'b*');
	elseif(y(i) == 1)
		hold on;
		plot(X(i,1),X(i,2),'b+');
	elseif(y(i) == 2)
		hold on;
	        plot(X(i,1),X(i,2),'bo');
	elseif(y(i) == 3)
		hold on;
		plot(X(i,1),X(i,2),'bs');	
	elseif(y(i) == 4)
	        hold on;
		plot(X(i,1),X(i,2),'bd');
	 elseif(y(i) == 5)
	        hold on;
		plot(X(i,1),X(i,2),'r+');
	elseif(y(i) == 6)
		hold on;
		plot(X(i,1),X(i,2),'ro');
	elseif(y(i) == 7)
		hold on;
		plot(X(i,1),X(i,2),'rs');
	elseif(y(i) == 8)
		hold on;
		plot(X(i,1),X(i,2),'rd');
	else
		hold on;
		plot(X(i,1),X(i,2),'r*');
	end
end
%}
