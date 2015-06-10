function predictionLabels = predict_( randomForest, image )
%PREDICT Summary of this function goes here
%   Detailed explanation goes here

features = cache(@computeFeatures, image);

predictionLabels = randomForest.predict(double(features)');

end

