function [dstar, thetastar] = WeakLearner(X, y, prob)

[m n] = size(X);
dstar = 0;
thetastar = 0;
Fbest = 50000;
Ftemp = 0;

index = (y == 1);
notindex = not(index);
for j = 1:n
	Xtemp = X(:, j);
	[Xtemp order] = sort(Xtemp);
	thetaVec = (Xtemp(1:m-1) + Xtemp(2:m))/2;
	thetaVec = [Xtemp(1) - 1; thetaVec; Xtemp(m) + 1];
	
	probtemp = prob(order);
	ytemp = y(order);
	for i = 1:m+1
		theta = thetaVec(i);
		if(i==1)
			Ftemp = prob(index)*(X(index, j) > theta);
			Ftemp = Ftemp + prob(notindex)*(X(notindex, j) <= theta);
		else
			%Ftemp = Ftemp - probtemp(i-1)*ytemp(i-1);
			Ftemp = prob(index)*(X(index, j) > theta);
                        Ftemp = Ftemp + prob(notindex)*(X(notindex, j) <= theta);
		end
		if(Fbest > Ftemp)
			Fbest = Ftemp;
			dstar = j;
			thetastar = theta;
		end
	end
end	
%dstar
%theta
%min(X(:, dstar))
%max(X(:, dstar))
