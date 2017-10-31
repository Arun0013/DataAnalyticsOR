clear;
clc;
close all;

%rng(0);
redDim = input('Do you want to consider all 64 original features or just the 2 principal components from PCA? (Enter 2 or 64) ');
%K = 10;

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
Vlim = V(:,1:redDim);
Dlim = D(:,1:redDim);
X = X*Vlim;

averageSilhouette = zeros(11,1);
for K = 5:15
rng(0);
%fprintf('K: %d\n', K);
center = zeros(K, redDim);
%for i = 1:redDim
%	center(:, i) = min(X(:,i)) + rand(K, 1) * (max(X(:, i)) - min(X(:, i)));
%end
for i = 1:K
	index = randi([1 size(X,1)]);
	center(i,:) = X(index, :) + rand(1, redDim)*0.1;
end			

while(1)
	clusterSize = zeros(K, 1);
	clusterElement = zeros(K, size(X, 1));
	for j = 1:size(X,1)
		minDistance = 500000;
		for i = 1:K
			distance = sqrt((X(j, :) - center(i, :))*(X(j, :) - center(i, :))');
			if(distance < minDistance)
				minDistance = distance;
				clusterNumber = i;
			end
		end
		clusterSize(clusterNumber) = clusterSize(clusterNumber) + 1;
		clusterElement(clusterNumber, clusterSize(clusterNumber)) = j;
	end					
	if(nnz(clusterSize) == K)
		%fprintf('Center Initialized\n');
		break;
	end
end

loopNumber = 1;
clusterNumberG = zeros(size(X,1),1);
while(1)
	newcenter = zeros(K, redDim);
	for i = 1:K
		newcenter(i, :) = sum(X(nonzeros(clusterElement(i, :)), :))/clusterSize(i);
	end
	change = 0;
	for i = 1:K
		change = change + (center(i,:) - newcenter(i,:))*(center(i,:) - newcenter(i,:))';
	end
	change = sqrt(change/K);
	if(change < 10^-5)
		%fprintf('Cluster formed successfully \n');
		break;
	else
		center = newcenter;
		loopNumber = loopNumber + 1;
		%fprintf('Loop Number: %d\n', loopNumber);
		
		clusterSize = zeros(K, 1);
        	clusterElement = zeros(K, size(X, 1));
        	for j = 1:size(X,1)
			clusterNumber = 0;
                	minDistance = 500000;
                	for i = 1:K
                        	distance = sqrt((X(j, :) - center(i, :))*(X(j, :) - center(i, :))');
                        	if(distance < minDistance)
 	                              	minDistance = distance;
                                	clusterNumber = i;
                        	end
                	end
			if(clusterNumber == 0)
				fprintf('Not Good\n');
			end
			clusterNumberG(j) = clusterNumber;
                	clusterSize(clusterNumber) = clusterSize(clusterNumber) + 1;
                	clusterElement(clusterNumber, clusterSize(clusterNumber)) = j;
        	end
        	if(nnz(clusterSize) < K)
                	fprintf('A cluster with zero points \n');
                	break;
        	end
	end
end

m = size(X,1);
silhouette = zeros(m, 1);
a = zeros(m, 1);
b = zeros(m, 1) + 50000;
distanceMat = zeros(m, m);
for i = 1:m-1
        for j = i+1:m
                distance = sqrt((X(j, :) - X(i, :))*(X(j, :) - X(i, :))');
                distanceMat(i,j) = distance;
                distanceMat(j,i) = distance;
        end
end


for i = 1:m
	for currentCluster = 1:K
		if(currentCluster == clusterNumberG(i));
			iterator = 1;
			while(iterator <= clusterSize(currentCluster))
				a(i) = a(i) + distanceMat(clusterElement(currentCluster, iterator), i);
				iterator = iterator + 1;
			end
			a(i) = a(i) / clusterSize(currentCluster);
		else
			iterator = 1;
			btemp = 0;
			while(iterator <= clusterSize(currentCluster))
                                btemp = btemp + distanceMat(clusterElement(currentCluster, iterator), i);
                                iterator = iterator + 1;
                        end
                        btemp = btemp / clusterSize(currentCluster);
			if(btemp < b(i))
				b(i) = btemp;
			end
		end
	end
	silhouette(i) = (b(i) - a(i)) / max(b(i), a(i));
end
fprintf('Average Silhouette Value for %d clusters: %f\n', K, sum(silhouette)/m);
averageSilhouette(K-4) = sum(silhouette)/m;
end
plot([5:15], averageSilhouette, '-*');
xlabel('Number of Cluster');
ylabel('Average Silhouette Value');
ylim([0 0.45]);
title('Variation of Silhouette Value with K');

