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
    currentImage = images{i};
    currentMask = masks{i};
    
    % calculate features for current image
    imageFeatures = cache(@computeFeatures, currentImage);
    
    % calculate number of foreground pixels in mask (contour)
    contourPixelCount = sum(sum(currentMask ~= 0));
    
    % flatten mask to vector
    flattenedMask = currentMask(:);
    
    % at the indices where the mask vector ~= 0 (contour), extract
    % features, add them to the feature set and set the labels accordingly
    features(:, firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1) = imageFeatures(:, flattenedMask ~= 0);
    for j = firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1
        labels{j} = 'Contour';
    end
%     labels{firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1} = 'Contour';
    % set the start index for further features to the end of both sets
    firstNewFeatureIndex = firstNewFeatureIndex + contourPixelCount;
    
    % now we have to randomly choose the same amount of background samples
    % as contour samples (contourPixelCount); to achieve this, we generate
    % indices for all features, exclude the indices of the contour features
    % and chose from a randomly permutated set of indices
    randIdx = randperm(size(imageFeatures, 2));
    % since flattenedMask is not binary (has values of either 0 or 10), we
    % make it binary, to be able to use find on it, which retrieves indices
    % of non-zero elements; to filter out the contour indices, we invert
    % the binary mask and use find to get all indices of contour pixels (to
    % filter them out)
    binFlattenedMask = flattenedMask;
    binFlattenedMask(binFlattenedMask > 0) = 1;
    % exclude indices that were used for contour features from selection
    randIdx = setdiff(randIdx, find(~binFlattenedMask));
    
    % select exactly as much background pixel indices as contour pixels
    bgFeatureIdx = randIdx(1:contourPixelCount);
    features(:, firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1) = imageFeatures(:, bgFeatureIdx);
    for j = firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1
        labels{j} = 'Background';
    end
%     labels{firstNewFeatureIndex : firstNewFeatureIndex + contourPixelCount - 1} = {'Background'};

    firstNewFeatureIndex = firstNewFeatureIndex + contourPixelCount;
    
end

% creating random forest for extracted features and labels
rf = TreeBagger(32, features', labels', 'OOBVarImp', 'on');

end

