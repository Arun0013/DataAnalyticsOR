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

X = [train(:,1:end-4) train(:,end-2:end)];
Y = train(:,end-3);
Xtest = [test(:,1:end-4) test(:,end-2:end)];
Ytest = test(:, end-3);
Y(Y==0) = -1;
Ytest(Ytest == 0) = -1;


[X theta origFeat] = binaryExpand(X);

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

dim = size(X, 2);
A = linspace(1, dim, dim); 
rootNode = Node;
rootNode.A = A;
rootNode.x = X;
rootNode.y = Y;
rootNode = ConstructNode(rootNode, 1); 

predictYtest = zeros(length(Ytest), 1)-2;
predictYtrain = zeros(length(Y), 1)-2;



currentNode = rootNode;
for i = 1:length(Y)
        while(1)
                if(currentNode.isLeaf == 1)
                        predictYtrain(i) = currentNode.output;
                        currentNode = rootNode;
                        break;
                else
                        if(X(i,currentNode.feature) < currentNode.threshold)
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
			predictYtest(i) = currentNode.output;
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

fprintf('\n\nTraining Error: %f', sum(predictYtrain ~= Y)/length(Y));
fprintf('\n\nTesting Error : %f', sum(predictYtest ~= Ytest)/length(Ytest));
					

