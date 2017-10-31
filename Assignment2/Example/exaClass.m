clear;
clc;
close all;

a = Class;
a.Value = 0;
a.leftChild = Class;
a.rightChild = Class;
a.leftChild.Value = 0;
a.rightChild.Value = 0;

fprintf('a.Value = %d\n', a.Value);
fprintf('a.leftChild.Value = %d\n', a.leftChild.Value);
fprintf('a.rightChild.Value = %d\n', a.rightChild.Value);

a.leftChild = modifyFunction(a.leftChild, 1);
a.rightChild = modifyFunction(a.rightChild, 1);

fprintf('a.Value = %d\n', a.Value);
fprintf('a.leftChild.Value = %d\n', a.leftChild.Value);
fprintf('a.rightChild.Value = %d\n', a.rightChild.Value);
