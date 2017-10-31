function [xNew theta origFeat ] = binarExpand(x)

nOrigFeatures = size(x, 2);
nData = size(x, 1);

xNew = [];
theta = [];
origFeat = [];

for i = 1:nOrigFeatures
	currentCol = x(:, i);
	if(sum(currentCol==1)+sum(currentCol==0) == nData)
		xNew = [xNew currentCol];
		theta = [theta -1000];
		origFeat = [origFeat i];
	else
		%colSort = sort(currentCol);
		colSort = sort(unique(currentCol));
			
		theta = [theta colSort(1)-100];
		origFeat = [origFeat i];
		xNew = [xNew (currentCol<colSort(1)-100)];
		%for j = 1:nData-1
		for j = 1:size(colSort,1)-1
			thetaNew = colSort(j)/2 + colSort(j+1)/2;
			theta = [theta thetaNew];	
			origFeat = [origFeat i];
			xNew = [xNew (currentCol<thetaNew)];
		end
		theta = [theta colSort(end)+100];
		origFeat = [origFeat i];
		xNew = [xNew (currentCol<colSort(end)+100)];
	end
end	
			 
