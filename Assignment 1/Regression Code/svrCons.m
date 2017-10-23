function [c ceq] = svrCons(variables, nVars, X, y, eps)

w = variables(1:nVars);
zhi = variables(nVars+1:end);
m = length(zhi);

if(m ~= length(X))
    m
    length(X)
    display('You are screwed');
end

ceq = [];

c = zeros(3*m,1);
c(1:m) =  y - (X*w) -eps - zhi ;
c(m+1:2*m) =   X*w - y -eps - zhi;
c(2*m+1:3*m) = -zhi;