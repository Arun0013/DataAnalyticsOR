function cost = svmCost(variable, lambda, nVars)

w = variable(1:nVars);
zhi = variable(nVars+1: end);

cost = (lambda/2)*w(2:end)'*w(2:end) + sum(zhi);