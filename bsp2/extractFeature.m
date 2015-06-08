function [ feature ] = extractFeature( features, featureId, imgSize )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

feature = zeros(imgSize);
for k = 1 : size(features, 2)
    x = features(45, 1);
    y = features(46, 2);
    feature(y,x) = features(featureId, k);
end

end