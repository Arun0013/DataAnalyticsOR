clear;
clc;
close all;


FileName = 'BCDataMod.csv';
CompleteData = dlmread(FileName, ',');

X = CompleteData(:, 3:end);
% Normalization
average = zeros(1, size(X,2));
range = zeros(1, size(X,2));
for j = 1:size(X,2)
    average(j) = mean(X(:,j));
    range(j) = max(X(:,j)) - min(X(:,j));
    %range(j) = std(X(:,j));
    %X(:,j) = (X(:,j) - average(j)) / range(j);
    %X(:,j) = normc(X(:,j));
end
y = CompleteData(:, 2);

Xm = X(y==1, :);
Xb = X(y==0, :);

for j = 1:size(Xm,2)
    average = mean(Xm(:,j));
    range = max(Xm(:,j)) - min(Xm(:,j));
    %range = std(Xm(:,j));
    Xm(:,j) = (Xm(:,j) - average) / range;
    %X(:,j) = normc(X(:,j));
end
for j = 1:size(Xb,2)
    average = mean(Xb(:,j));
    range = max(Xb(:,j)) - min(Xb(:,j));
    %range = std(Xb(:,j));
    Xb(:,j) = (Xb(:,j) - average) / range;
    %X(:,j) = normc(X(:,j));
end


% KMeans Malignant
minK = 2;
maxK = 29;
seed = 8;

thetam = zeros(1, maxK -minK +1);
for K = minK:maxK
%K = 30;
    rng(seed);
    [idxm, Cm] = kmeans(Xm, K);
    davgm = 0;
    for k = 1:K
        for i = 1:size(Xm,1)
            if(idxm(i) == k)
                diff = Xm(i,:) - Cm(k, :);
                davgm = davgm + sqrt(diff * diff');
            end
        end
    end
    davgm = davgm/size(Xm,1);

    dminm = inf;
    for k = 1:K-1
        for kk = k+1:K
            dist = Cm(k,:) - Cm(kk,:);
            dist = dist * dist';
            if(dist < dminm)
                dminm = dist;
            end
        end
    end

    thetam(K-minK+1) = davgm/dminm;
end
plot(minK:maxK, thetam);

thetab = zeros(1, maxK -minK +1);
for K = minK:maxK
%K = 30;
    rng(seed);
    [idxb, Cb] = kmeans(Xb, K);
    davgb = 0;
    for k = 1:K
        for i = 1:size(Xb,1)
            if(idxb(i) == k)
                diff = Xb(i,:) - Cb(k, :);
                davgb = davgb + sqrt(diff * diff');
            end
        end
    end
    davgb = davgb/size(Xb,1);

    dminb = inf;
    for k = 1:K-1
        for kk = k+1:K
            dist = Cb(k,:) - Cb(kk,:);
            dist = sqrt(dist * dist');
            if(dist < dminb)
                dminb = dist;
            end
        end
    end

    thetab(K-minK+1) = davgb/dminb;
end
figure
plot(minK:maxK, thetab, 'r');
