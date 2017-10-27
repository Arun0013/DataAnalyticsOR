function ClusterSymmetryNew = completeLinkage(ClusterMatrix, ClusterSize, rowNumber, columnNumber, ClusterSymmetry, increaseSize)


ClusterSymmetryNew = ClusterSymmetry;
ClusterSymmetryNew(:, columnNumber) = [];
ClusterSymmetryNew(columnNumber, :) = [];
nCluster = length(ClusterSymmetry)-1;

%{
i = rowNumber;
for j = 1:nCluster
	maxSymmetry = ClusterSymmetryNew(i, j);
	if(i ~= j)
		%for ii = 1:ClusterSize(i)
		for ii = ClusterSize(i)-increaseSize+1:ClusterSize(i)
		newPoint = ii;
		for k = 1:ClusterSize(j)
			symmetry = sqrt((ClusterMatrix(i,newPoint,1) - ClusterMatrix(j,k,1))^2 + (ClusterMatrix(i,newPoint,2) - ClusterMatrix(j,k,2))^2);
			if(maxSymmetry < symmetry)
				maxSymmetry = symmetry;
				ClusterSymmetryNew(i,j) = symmetry;
				ClusterSymmetryNew(j,i) = symmetry;
			end
		end
	end
end
end
%}


for k =1:nCluster
	if(k < columnNumber)
		if(ClusterSymmetry(columnNumber,k) > ClusterSymmetry(rowNumber, k))
			ClusterSymmetryNew(rowNumber, k) = ClusterSymmetry(columnNumber,k);
			ClusterSymmetryNew(k, rowNumber) = ClusterSymmetry(columnNumber,k);
		end

	else
		if(ClusterSymmetry(columnNumber,k+1) > ClusterSymmetry(rowNumber, k+1))
                        ClusterSymmetryNew(rowNumber, k) = ClusterSymmetry(columnNumber,k+1);
                        ClusterSymmetryNew(k, rowNumber) = ClusterSymmetry(columnNumber,k+1);
		end
	end
end


%{
nCluster = length(ClusterSymmetry)-1;
for i = 1:nCluster-1
	%for ii = 1:ClusterSize(i)
		for j = i+1:nCluster
			maxDistance = -500000;
			for ii = 1:ClusterSize(i)
			for jj = 1:ClusterSize(j)
				symmetry = sqrt((ClusterMatrix(i,ii,1) - ClusterMatrix(j,jj,1))^2 + (ClusterMatrix(i,ii,2) - ClusterMatrix(j,jj,2))^2);
				if(symmetry>maxDistance)
					maxDistance = symmetry;
					ClusterSymmetryNew(i,j) = symmetry;
					ClusterSymmetryNew(j,i) = symmetry;
				end
			end
		end
	end
end
%}
