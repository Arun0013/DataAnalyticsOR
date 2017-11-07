function ClusterSymmetryNew = averageLinkage(ClusterMatrix, ClusterSize, rowNumber, columnNumber, ClusterSymmetry, increaseSize)

ClusterSymmetryNew = ClusterSymmetry;
ClusterSymmetryNew(:, columnNumber) = [];
ClusterSymmetryNew(columnNumber, :) = [];
nCluster = length(ClusterSymmetry)-1;

%{
i = rowNumber;
for j = 1:nCluster
	if(i ~= j)
		average = 0;
		for ii = 1:ClusterSize(i)
			newPoint = ii;
			for k = 1:ClusterSize(j)
				average = average +  sqrt((ClusterMatrix(i,newPoint,1) - ClusterMatrix(j,k,1))^2 + (ClusterMatrix(i,newPoint,2) - ClusterMatrix(j,k,2))^2);
			end
		end
		average = average / (ClusterSize(i)*ClusterSize(j));
		ClusterSymmetryNew(i,j) = average;
		ClusterSymmetryNew(j,i) = average;
	end
end
%}

ClusterSizecolumnNumber = increaseSize;
ClusterSizerowNumber = ClusterSize(rowNumber) - increaseSize;
for k =1:nCluster
	if(k < columnNumber)
		ClusterSymmetryNew(rowNumber, k) = (ClusterSizerowNumber*ClusterSymmetry(rowNumber, k) + ClusterSizecolumnNumber*ClusterSymmetry(columnNumber, k))/(ClusterSizerowNumber+ClusterSizecolumnNumber);
		ClusterSymmetryNew(k, rowNumber) = ClusterSymmetryNew(rowNumber, k);

	else
                ClusterSymmetryNew(rowNumber, k) = (ClusterSizerowNumber*ClusterSymmetry(rowNumber, k+1) + ClusterSizecolumnNumber*ClusterSymmetry(columnNumber, k+1))/(ClusterSizerowNumber+ClusterSizecolumnNumber);
                ClusterSymmetryNew(k, rowNumber) = ClusterSymmetryNew(rowNumber, k);
	end
end


%{
nCluster = length(ClusterSymmetry)-1;
for i = 1:nCluster-1
	for j = i+1:nCluster
		average = 0;
		for ii = 1:ClusterSize(i)
			for jj = 1:ClusterSize(j)
				average = average +  sqrt((ClusterMatrix(i,ii,1) - ClusterMatrix(j,jj,1))^2 + (ClusterMatrix(i,ii,2) - ClusterMatrix(j,jj,2))^2);
			end
		end
		average = average / (ClusterSize(i)*ClusterSize(j));
                ClusterSymmetryNew(i,j) = average;
                ClusterSymmetryNew(j,i) = average;
	end
end
%}
