function node = modifyFunction(node, k)

if(k<4)
    node.Value = k;
    node.rightChild = Class;
    node.leftChild = Class;
    
    fprintf('\ta.Value = %d\n', node.Value);
    fprintf('\ta.leftChild.Value = %d\n', node.leftChild.Value);
    fprintf('\ta.rightChild.Value = %d\n', node.rightChild.Value);
    node.leftChild = modifyFunction(node.leftChild, k+1);
    node.rightChild = modifyFunction(node.rightChild, k+1);
end
