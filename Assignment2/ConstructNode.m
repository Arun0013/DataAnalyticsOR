
function node = ConstructNode(node, option )
	if(isempty(node.A) == 1)
		%fprintf('\n\t\tExiting node since A is empty');
		node.isLeaf = 1;
		if(sum(node.y == 1) >= sum(node.y == -1))
			node.output = 1;
		else
			node.output = -1;
		end
	elseif(node.y == 1)
		%fprintf('\n\t\tExiting node since all y are 1'); 
		node.isLeaf = 1;
		node.output = 1;
	elseif(node.y == -1)
		%fprintf('\n\t\tExiting node since all y are -1');
		node.isLeaf = 1;
		node.output = -1;
    else
 	        tempFeature = chooseFeature(node.x, node.y, option); % Change
		%tempFeature = randi([1 length(node.A)], 1, 1);
		node.feature = node.A(tempFeature); % Change
		node.threshold = 0.5; %Change
		A_temp = node.A;
		A_temp(tempFeature) = [];
		x_temp = node.x;
		x_temp(:, tempFeature) = [];
		index = (node.x(:,tempFeature) < node.threshold);
		
		if(sum(index)==0 || sum(index)==size(node.x, 1))
			%fprintf('\n\t\tExiting node since all data have same feature value');
			node.isLeaf = 1;
			if(sum(node.y == 1) >= sum(node.y == -1))
				node.output = 1;
			else
				node.output = -1;
			end
		else
			node.leftChild = Node;
			node.leftChild.A = A_temp;
			node.leftChild.x = x_temp(index, :);
			node.leftChild.y = node.y(index);

			node.rightChild = Node;
			node.rightChild.A = A_temp;
			node.rightChild.x = x_temp(~index, :);
			node.rightChild.y = node.y(~index);

			%fprintf('\n\tEntering Left Child');	
			node.leftChild = ConstructNode(node.leftChild, option);
			%fprintf('\n\tEntering Right Child');
			node.rightChild = ConstructNode(node.rightChild, option);
		end
	end
