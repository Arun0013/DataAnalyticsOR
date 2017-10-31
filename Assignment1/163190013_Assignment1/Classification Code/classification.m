clear;
clc;
close all;
warning off;

trainFileName = 'Classification_TRAIN.csv';
testFileName = 'Classification_TEST.csv';
try 
    train = load(trainFileName);
    test = load(testFileName);
catch
    train = dlmread(trainFileName,',',1,0);
    test = dlmread(testFileName,',',1,0);
end
trueIndex = (train(:,3)==1);
plot(train(trueIndex,1), train(trueIndex,2), '+k');
falseIndex = not(trueIndex);
hold on;
plot(train(falseIndex,1), train(falseIndex,2), 'or');

X = [ones(length(train),1) train(:,1) train(:,2)];
y = train(:,3);
Xtest = [ones(length(test),1) test(:,1) test(:,2)];
ytest = test(:,3);

nVars = size(X,2);
m = size(X,1);
 
initw = zeros(nVars,1);
options = optimoptions('fminunc','Display','off');
[w_logistic costLogistic exitFlagLogistic] = fminunc(@(w)(logisticCost(w,X,y)), initw, options);
fprintf('Logistic Regression:');
fprintf('\n\tw: %f', w_logistic(2:end));
fprintf('\n\tb: %f', w_logistic(1));
fprintf('\n\tTraining Set Accuracy: %f', sum(y.*(X*w_logistic)>=0)/m);
fprintf('\n\tTesting Set Accuracy: %f\n', sum(ytest.*(Xtest*w_logistic)>=0)/size(Xtest,1));

x1 = linspace(min(train(:,1)),max(train(:,1)), 500);
x2 = -w_logistic(2)*x1-w_logistic(1);
x2 = x2./w_logistic(3);
hold on;
plot(x1,x2,'b');

lambdaSet = linspace(0,10,21);
initw = zeros(nVars,1);
initzhi = zeros(m,1)+20;
testAccuracyLambda = zeros(size(lambdaSet));
trainAccuracyLambda = zeros(size(lambdaSet));
exitFlagSVM = zeros(size(lambdaSet));
w_svm_Lambda = zeros(size(lambdaSet,1), nVars);

for i = 1:length(lambdaSet)
    lambda = lambdaSet(i);
    fprintf('\nSVM - Lambda : %f', lambda);
    options = optimoptions('fmincon','MaxFunEvals',100000,'display','off');
    [w_zhi_svm, cost, exitFlagSVM(i)] = fmincon(@(variable)(svmCost(variable, lambda, nVars)), [initw; initzhi], [],[],[],[],[],[], @(variable)(svmCons(variable, nVars, X, y)), options);
    w_svm_Lambda(i, :) = w_zhi_svm(1:nVars);
    testAccuracyLambda(i) = sum(ytest.*(Xtest*w_zhi_svm(1:nVars))>=0)/size(Xtest,1);
    trainAccuracyLambda(i) = sum(y.*(X*w_zhi_svm(1:nVars))>=0)/m;
end

bestLambdaIndex = find(testAccuracyLambda == max(testAccuracyLambda));
bestLambdaIndex = bestLambdaIndex(1);

fprintf('\nSVM:');
fprintf('\n\tLambda with maxiumum test accuracy: %f', lambdaSet(bestLambdaIndex)); 
fprintf('\n\tw: %f', w_svm_Lambda(bestLambdaIndex, 2:end));
fprintf('\n\tb: %f', w_svm_Lambda(bestLambdaIndex, 1));
w_svm_best = w_svm_Lambda(bestLambdaIndex, :)';
fprintf('\n\tTraining Set Accuracy: %f', sum(y.*(X*w_svm_best)>=0)/m);
fprintf('\n\tTesting Set Accuracy: %f\n', sum(ytest.*(Xtest*w_svm_best)>=0)/size(Xtest,1));

figure(2)
plot(lambdaSet, testAccuracyLambda, 'b');
hold on;
plot(lambdaSet, trainAccuracyLambda, 'r');
xlabel('Lambda');
ylabel('Accuracy');
title('Testing and Training Error vs Lambda');
legend('Test Set Accuracy', 'Training Set Accuracy');

figure(1)
%x1 = linspace(min(train(:,1)),max(train(:,1)), 500);
x2 = -w_svm_best(2)*x1-w_svm_best(1);
x2 = x2./w_svm_best(3);
hold on;
plot(x1,x2,'r');


initw = zeros(nVars,1);
initzhi = zeros(m,1)+20;
options = optimoptions('fmincon','MaxFunEvals',100000, 'display', 'off');
[w_zhi_hs, cost, exitflagHS] = fmincon(@(variable)(halfspaceCost(variable, nVars)), [initw; initzhi], [],[],[],[],[],[], @(variable)(hsCons(variable, nVars, X, y)), options);
w_hs = w_zhi_hs(1:nVars);
  
fprintf('Half Spaces:');
fprintf('\n\tw: %f', w_hs(2:end));
fprintf('\n\tb: %f', w_hs(1));
fprintf('\n\tTraining Set Accuracy: %f', sum(y.*(X*w_hs)>=0)/m);
fprintf('\n\tTesting Set Accuracy: %f\n', sum(ytest.*(Xtest*w_hs)>=0)/size(Xtest,1));
 
% x1 = linspace(min(train(:,1)),max(train(:,1)), 500);
figure(1);
x2 = -w_hs(2)*x1-w_hs(1);
x2 = x2./w_hs(3);
hold on;
plot(x1,x2,'m');
xlabel('x');
ylabel('y');
title('Classification');
legend('Positive Label', 'Negative Label', 'Logistic Regression', 'SVM (best lambda)', 'Halfspaces');
