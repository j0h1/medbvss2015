function [predictionLabels, predictionProbabilities] = predict_( randomForest, image )
%PREDICT Summary of this function goes here
%   Detailed explanation goes here

features = cache(@computeFeatures, image);

[predictionLabels, predictionProbabilities] = randomForest.predict(double(features)');

end

