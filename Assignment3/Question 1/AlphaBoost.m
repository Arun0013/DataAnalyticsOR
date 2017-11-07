clear;
clc;
close all;

FileName = 'pima-indians-diabetes.csv';
CompleteData = dlmread(FileName, ',', 1, 0);

X = CompleteData(:, 1:end-1);
y = CompleteData(:, end);
y(y == 0) = -1;

T = 100;
[m n] = size(X);
prob = zeros(1, m) + 1/m;
weightage = zeros(1, m);
%hypothesis = zeros(m, T);
finalhypothesis = zeros(m, 1);
eeta = 1;

for t = 1:T
	[dstar, thetastar] = WeakLearner(X, y, prob);
	hneww = (X(:, dstar) <= thetastar);
        hnew = ones(m, 1);
        for i = 1:m
                if(hneww(i) == 0)
                        hnew(i) = -1;
                end
        end
	eps =  prob * (hnew ~= y);
	weightage = 0.5*log10(1/eps - 1);
	
	for i = 1:m
		prob(i) = prob(i) * (1 + (hnew(i)==y(i))*(exp(-eeta)-1));
	end
	prob = prob/sum(prob);
	%if(t > 1)
		finalhypothesis = weightage*hnew + finalhypothesis;
	%end
end
prediction = sign(finalhypothesis);
