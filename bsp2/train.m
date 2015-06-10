function rf = train( images, masks )
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

% initialize feature set and labels
contourPixelCount = 0;
for i = 1 : size(masks, 2)
    % iterate over test images and extract amount of contour pixels in masks
    contourPixelCount = contourPixelCount + sum(sum(masks{i} ~= 0));
end

% we need the same amount of samples (features) for foreground and
% background pixels, so the amount of features is double the amount of
% foreground pixels (countour pixels)
features = zeros(46, contourPixelCount * 2);
% labels define the classes "background"/"foreground" assigned to features
labels = cell(contourPixelCount * 2, 1);

% helper variable to keep track of the current indexing
firstNewFeatureIndex = 1;

for i = 1 : size(images, 2)
    disp(['Computing features for image #', num2str(i)]);
    
    currentImage = images{i};
    currentMask = masks{i};
    
    % calculate features for current image
    imageFeatures = cache(@computeFeatures, currentImage);
    
    % calculate number of foreground pixels in mask (contour)
    contourPixelCount = sum(sum(currentMask ~= 0));
    
    % at the indices where the mask vector ~= 0 (contour), extract
    % features, add them to the feature set and set the labels accordingly
    features(:, firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1) = imageFeatures(:, find(currentMask));
    for j = firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1
        labels{j} = 'Contour';
    end
    
%     labels{firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1} = 'Contour';
    % set the start index for further features to the end of both sets
    firstNewFeatureIndex = firstNewFeatureIndex + contourPixelCount;

    % create a vector containing all indices of the features and exclude
    % the indices of contour samples
    randIdx = 1 : size(imageFeatures, 2);
    randIdx = setdiff(randIdx, find(currentMask));
    
    % randomly select exactly contourPixelCount background pixel indices
    bgFeatureIdx = randsample(randIdx, contourPixelCount);
    features(:, firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1) = imageFeatures(:, bgFeatureIdx);
    for j = firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1
        labels{j} = 'Background';
    end
%     labels{firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1} = {'Background'};

    firstNewFeatureIndex = firstNewFeatureIndex + contourPixelCount;
    
end

disp('training random forest with extracted features');
% creating random forest for extracted features and labels
rf = TreeBagger(32, features', labels', 'OOBVarImp', 'on');

end

