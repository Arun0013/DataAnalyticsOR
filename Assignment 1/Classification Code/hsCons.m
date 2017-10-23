function [c ceq] = hsCons(variables, nVars, X, y)

w = variables(1:nVars);
zhi = variables(nVars+1:end);
m = length(zhi);

% if(m ~= length(X))
%     m
%     length(X)
%     display('You are screwed');
% end

ceq = [];

c = 1 - zhi - y.* (X*w);
c = [c; -zhi];