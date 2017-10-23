function i_star = chooseFeature(x, y, option)

nFeatures = size(x, 2);
gain = zeros(nFeatures, 1);
threshold = zeros(nFeatures, 1);

if(option == 2) 
	for i = 1:nFeatures
		%gainCff(x,y,i)
		gain(i) = gainCff(x, y, i); 
		%gain(i) = gainCART(x, y, i);
	end
else
	for i = 1:nFeatures
		gain(i) = gainCART(x, y, i);
	end
end
%gain = -1*gain;
i_high = find(gain == max(gain));
try
	i_star = i_high(1); 
catch
	gain
end
