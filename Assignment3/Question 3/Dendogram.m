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

choice = input('\nEnter 1 for simple linkage, 2 for complete linekage, 3 for average linakge and 0 to exit: ');

while(choice ~= 0)
m = size(X,1);
for i = 1:m
	for j = 1:redDim
		ClusterMatrix(i,1,j) = X(i,j);
	end
	ClusterSize(i) = 1;
end
nCluster = length(ClusterSize);

ClusterSymmetry  = zeros(nCluster, nCluster);
for i = 1:nCluster-1
	for j = i+1:nCluster
		symmetry = sqrt((ClusterMatrix(i,1,1) - ClusterMatrix(j,1,1))^2 + (ClusterMatrix(i,1,2) - ClusterMatrix(j,1,2))^2);
		ClusterSymmetry(i,j) = symmetry;
		ClusterSymmetry(j,i) = symmetry;
	end
end
ClusterSymmetry = (max(max(ClusterSymmetry))+1)*eye(nCluster, nCluster) + ClusterSymmetry;

while (nCluster > 10)
	%if(mod(nCluster,100) == 0)
	%	fprintf('Number of Clusters: %d\n', nCluster);
	%end
        if(sum(sum(isnan(ClusterSymmetry)==1))>0)
                fprintf('NAN in Main 2\n');
        end

	[M1, I1] = min(ClusterSymmetry);
	[M2, I2] = min(M1);
	columnNumber = I2(1);
	rowNumber = I1(columnNumber);
	if(columnNumber == rowNumber)
		fprintf('Same number: %d\n', rowNumber);
		break;
	end
	newCluster = min([rowNumber, columnNumber]);
	remCluster = max([rowNumber, columnNumber]);
	%fprintf('NewCluster: %d RemCluster: %d\n', newCluster, remCluster);
	currentClusterSize = ClusterSize(newCluster);
	increaseSize = ClusterSize(remCluster);
	for j = currentClusterSize+1 : currentClusterSize+ClusterSize(remCluster)
		for k = 1:redDim
			ClusterMatrix(newCluster, j, k) = ClusterMatrix(remCluster, j - currentClusterSize, k);
		end
	end
	ClusterSize(newCluster) = currentClusterSize+ClusterSize(remCluster);
	ClusterMatrix(remCluster, :, :) = [];
	ClusterSize(remCluster) = [];
	%sum(ClusterSize)
	nCluster = length(ClusterSize);
	if(nCluster > 10)
		if(choice == 1) 
			ClusterSymmetry = simpleLinkage(ClusterMatrix, ClusterSize, newCluster, remCluster, ClusterSymmetry, increaseSize);
		elseif(choice == 2)	
			ClusterSymmetry = completeLinkage(ClusterMatrix, ClusterSize, newCluster, remCluster, ClusterSymmetry, increaseSize);
		else
			ClusterSymmetry = averageLinkage(ClusterMatrix, ClusterSize, newCluster, remCluster, ClusterSymmetry, increaseSize);
		end
		if(sum(sum(isnan(ClusterSymmetry)==1))>0)
			fprintf('NAN in Main\n');
		end
		%max(max(ClusterSymmetry))+1
		%ClusterSymmetry = (max(max(ClusterSymmetry))+1)*eye(nCluster, nCluster) + ClusterSymmetry;
		for i = 1:nCluster
			ClusterSymmetry(i,i) = 10000;
		end
		if(sum(sum(isnan(ClusterSymmetry)==1))>0)
                        fprintf('NAN in Main 1\n');
                end

	end
	%ClusterSymmetry = (max(max(ClusterSymmetry))+1)*eye(nCluster, nCluster) + ClusterSymmetry;
end
fprintf('\nNumber of points in each cluster:');
display(ClusterSize);

figure;
for i = 1:nCluster
    for j = 1:ClusterSize(i)
	if(i == 9)
		hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'y*');
	elseif(i == 1)
		hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'m+');
	elseif(i == 2)
		hold on;
	        plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'co');
	elseif(i == 3)
		hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'rs');	
	elseif(i == 4)
	        hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'gd');
	 elseif(i == 5)
	        hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'b*');
	elseif(i == 6)
		hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'k+');
	elseif(i == 7)
		hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'ro');
	elseif(i == 8)
		hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'kd');
	else
		hold on;
		plot(ClusterMatrix(i,j,1), ClusterMatrix(i,j,2),'bs');
	end
   end
end
if(choice == 1)
                title('Clusters for Simple Linkage HAC');
elseif(choice == 2)
                title('Clusters for Complete Linkage HAC');
else
                title('Clusters for Average Linkage HAC');
end
choice = input('\nEnter 1 for simple linkage, 2 for complete linekage, 3 for average linakge and 0 to exit: ');
end

