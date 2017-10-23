clear;
clc;
close all;

%X = [0 0 1 1; 1 0 0 1; 1 0 0 0; 1 0 1 0; 1 0 1 1; 1 1 1 1; 1 0 1 1; 0 0 1 1; 0 0 0 1; 0 1 0 0; 0 1 1 1];
%Y = [1;1;-1;-1;-1;1;1;-1;-1;1;1];

%X = [1 1 0 -5; 0 10 0 5; 1 2 1 1; 1 4 0 2; 1 6 0 3; 0 8 1 -4.5; 0 9 0 -1; 1 7 1 0; 1 3 1 4.5; 0 5 1 -2];
%Y = [1; -1; -1; 1; -1; 1; 1; -1; -1; 1];

trainFileName = 'TrainModified.csv';
testFileName = 'TestModified.csv';
try
	train = load(trainFileName);
	test = load(testFileName);
catch
	train = dlmread(trainFileName, ',', 1, 1);
	test = dlmread(testFileName, ',', 1, 1);
end

Xorig = [train(:,1:end-4) train(:,end-2:end)];
Yorig = train(:,end-3);
Xtest = [test(:,1:end-4) test(:,end-2:end)];
Ytest = test(:, end-3);
Yorig(Yorig==0) = -1;
Ytest(Ytest == 0) = -1;

[Xorig theta origFeat] = binaryExpand(Xorig);

XtestNew = [];
for i = 1:length(theta)
	if(theta(i) == -1000)
		XtestNew = [XtestNew Xtest(:, origFeat(i))];
		
	else
		XtestNew = [XtestNew (Xtest(:, origFeat(i)) < theta(i))];
	end
end
Xtest = XtestNew;

option = input('Enter 1 for CART and 2 for C45: ');
nTrees = input('\nEnter the number of trees: ');

predictYtrainComp = zeros(nTrees, length(Yorig))-2;
predictYtestComp = zeros(nTrees, length(Ytest))-2;
dim = size(Xorig, 2);
A = linspace(1, dim, dim); 

for j = 1:nTrees
	fprintf('\n\tLearning Tree %d', j);
	mTree = randi([1 size(Xorig,1)], 1);
	indexTree = randi([1 size(Xorig,1)], mTree, 1);
	%mTree = size(Xorig, 1);
	%indexTree = 1:mTree;
	X = Xorig(indexTree, :);
	Y = Yorig(indexTree, :);
	
	rootNode = Node;
	rootNode.A = A;
	rootNode.x = X;
	rootNode.y = Y;
	rootNode = ConstructNode(rootNode, 1); 

	%predictYtest = zeros(length(Ytest), 1);
	%predictYtrain = zeros(length(Y), 1);

	currentNode = rootNode;
	for i = 1:length(Yorig)
        	while(1)
                	if(currentNode.isLeaf == 1)
        	                predictYtrainComp(j, i) = currentNode.output;
                	        currentNode = rootNode;
                       		break;
               		 else
                        	if(Xorig(i,currentNode.feature) < currentNode.threshold)
                                	currentNode = currentNode.leftChild;
                      		else
                              		currentNode = currentNode.rightChild;
                       		end
           		 end
       		 end
	end

	currentNode = rootNode;
	for i = 1:length(Ytest)
		while(1)
			if(currentNode.isLeaf == 1)
				predictYtestComp(j, i) = currentNode.output;
				currentNode = rootNode;
				break;
			else
				if(Xtest(i,currentNode.feature) < currentNode.threshold)
					currentNode = currentNode.leftChild;
				else
					currentNode = currentNode.rightChild;
				end
			end
		end
	end
end

predictYtest = zeros(length(Ytest), 1)-2;
predictYtestRatio = zeros(length(Ytest), 1)-2;
predictYtrain = zeros(length(Yorig), 1)-2;
predictYtrainRatio = zeros(length(Yorig), 1)-2;

m = length(Yorig);
for j = 1:m
	predictYtrainRatio(j) = sum(predictYtrainComp(:, j)==1)/nTrees;
	if(predictYtrainRatio(j) >= 0.5)
		predictYtrain(j) = 1;
	else
		predictYtrain(j) = -1;
	end
end

m = length(Ytest);
for j = 1:m
	predictYtestRatio(j) = sum(predictYtestComp(:, j)==1)/nTrees;
	if(predictYtestRatio(j) >= 0.5)
		predictYtest(j) = 1;
	else
		predictYtest(j) = -1;
	end
end

fprintf('\n\nTraining Error: %f', sum(predictYtrain ~= Yorig)/length(Yorig));
fprintf('\n\nTesting Error : %f', sum(predictYtest ~= Ytest)/length(Ytest));
					

