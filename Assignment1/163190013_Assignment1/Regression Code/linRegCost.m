function cost = linRegCost(w, X, y)

cost = (X*w - y)' * (X*w - y)/size(X, 1);