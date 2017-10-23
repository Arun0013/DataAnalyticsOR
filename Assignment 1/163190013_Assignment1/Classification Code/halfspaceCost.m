function cost = halfspaceCost(variable, nVars)

w = variable(1:nVars);
zhi = variable(nVars+1: end);

cost = 0*sum(w(2:end)) + sum(zhi);