function cost = svrCost(variable, nVars)

%cost = sum(epsLoss(X*w - y, eps)) + (w'*w - w(1)^2)/2;

w = variable(1:nVars);
zhi = variable(nVars+1: end);

cost = sum(zhi) + 0*(w'*w - w(1)^2)/2;