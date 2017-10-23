function value = gainCff(x, y, i)

len_y = length(y);
sum(y==1);
Py1 = sum(y == 1)/len_y;

index = (x(:,i) >= 0.5);

Pxgz = sum(index)/len_y;
Pxlz = sum(~index)/len_y;

Py1xgz = 0.5;
Py1xlz = 0.5;

if(Pxgz > 0)
	y1 = y(index, :);
	Py1xgz = sum(y1==1)/length(y1);
end

if(Pxlz > 0)
	y2 = y(~index, :);
	Py1xlz = sum(y2==1)/length(y2);
end


if(Py1xgz>0  & Py1xgz<1 & Py1xlz>0 & Py1xlz<1)
	value = C45(Py1) - (Pxgz*C45(Py1xgz) + Pxlz*C45(Py1xlz));
elseif(Py1xgz>0 & Py1xgz<1)
	value = C45(Py1) - (Pxgz*C45(Py1xgz));
elseif(Py1xlz>0 & Py1xlz<1)
	value = C45(Py1) - (Pxlz*C45(Py1xlz));
else
	value = C45(Py1);
end
%value
