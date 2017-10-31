function cost = logisticCost(w, X, y)

cost = sum(log(1+exp(-y.*(X*w))));
