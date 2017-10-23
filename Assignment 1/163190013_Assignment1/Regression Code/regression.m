clear;
clc;
close all;
warning off;

trainFileName = 'Regression_TRAIN.csv';
testFileName = 'Regression_TEST.csv';
try 
    train = load(trainFileName);
    test = load(testFileName);
catch
    train = dlmread(trainFileName,',',1,0);
    test = dlmread(testFileName,',',1,0);
end

X = [ones(length(train),1) train(:,1:end-1)];
y = train(:,end);
Xtest = [ones(length(test),1) test(:,1:end-1)];
ytest = test(:,end);

nVars = size(X,2);
m = size(X,1);

initw = ones(nVars,1);
[w_linReg, cost_linReg, exitflag_linReg] = fminunc(@(w)(linRegCost(w,X,y)), initw);
fprintf('Linear Regression:');
fprintf('\n\tw: %f', w_linReg(2:end));
fprintf('\n\tb: %f', w_linReg(1));
fprintf('\n\tTraining Set RMSE: %f', sqrt((y-(X*w_linReg))'*(y-(X*w_linReg))/m));
fprintf('\n\tTesting Set RMSE: %f\n', sqrt((ytest-(Xtest*w_linReg))'*(ytest-(Xtest*w_linReg))/size(Xtest,1)));

epsSet = linspace(0.1,1,10);
%epsSet = [0.1 0.2];
initw = zeros(nVars,1);
initzhi = zeros(m,1)+20;
testRMSEeps = zeros(size(epsSet));
trainRMSEeps = zeros(size(epsSet));
exitFlagSVR = zeros(size(epsSet));
w_svr_eps = zeros(size(epsSet,1), nVars);

for i = 1:length(epsSet)
    eps = epsSet(i);
    fprintf('\nSVR - eps : %f', eps);
    options = optimoptions('fmincon','MaxFunEvals',100000,'display','off');
    [w_zhi_svr, cost, exitFlagSVR(i)] = fmincon(@(variable)(svrCost(variable, nVars)), [initw; initzhi], [],[],[],[],[],[], @(variable)(svrCons(variable, nVars, X, y, eps)), options);
    w_svr_eps(i, :) = w_zhi_svr(1:nVars);
    testRMSEeps(i) = (ytest-(Xtest*w_zhi_svr(1:nVars)))'*(ytest-(Xtest*w_zhi_svr(1:nVars)))/size(Xtest,1);
    trainRMSEeps(i) = (y-(X*w_zhi_svr(1:nVars)))'*(y-(X*w_zhi_svr(1:nVars)))/m;
end

bestepsIndex = find(testRMSEeps == min(testRMSEeps));
bestepsIndex = bestepsIndex(1);

fprintf('\nSVR:');
fprintf('\n\tEps with minimum test RMSE: %f', epsSet(bestepsIndex)); 
fprintf('\n\tw: %f', w_svr_eps(bestepsIndex, 2:end));
fprintf('\n\tb: %f', w_svr_eps(bestepsIndex, 1));
w_svr_best = w_svr_eps(bestepsIndex, :)';
fprintf('\n\tTraining Set RMSE: %f', sqrt((y-(X*w_svr_best))'*(y-(X*w_svr_best))/m));
fprintf('\n\tTesting Set RMSE: %f\n', sqrt((ytest-(Xtest*w_svr_best))'*(ytest-(Xtest*w_svr_best))/size(Xtest,1)));

figure(1)
plot(epsSet, sqrt(testRMSEeps), 'b');
hold on;
plot(epsSet, sqrt(trainRMSEeps), 'r');
xlabel('Eps');
ylabel('RMSE');
title('Testing and Training RMSE vs Eps');
legend('Test Set RMSE', 'Training Set RMSE');

