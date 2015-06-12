function [  ] = RUN ( ~ )
%RUN Summary of this function goes here
%   Detailed explanation goes here
%%
% Fragestellung 1: Shape-Modell
% 
handdata = load('handdata.mat');
aligned = handdata.aligned;

[n dim numberOfShapes] = size(aligned);

% generating mean model
meanModel = mean(aligned, 3);

for i = 1 : dim - 1
    coordVector = cat(1, aligned(:, i, :), aligned(:, i + 1, :));
    coordVector = squeeze(coordVector);
end

% calculating pca
[ dataMean, eigenVectors, eigenValues ] = pca(coordVector);

generatedShapes = zeros(n, dim, 7);
for i = 1 : 7
    % initialize parameter vector b with number of eigenvalues
    b = zeros(size(eigenVectors(:, 1)));
    % sqrt(eigenValue) = standard deviation
    b(1) = (i - 4) * sqrt(eigenValues(1));
    generatedShapes(:, :, i) = generateShape(eigenVectors(:, 1), b, meanModel, pi * i * 0.25, i * 2, i * 100, i * 20); 
end

% plotting generated shapes (blue) and mean shape (red)
figure('name', 'Shapes mit unterschiedlichen Werten für Skalierung, Rotation und x-, sowie y-Translation');
plotShape(generatedShapes, meanModel);

%%
% Fragestellung 2: Featureberechnung
% 
clear;

handdata = load('handdata.mat');
images = handdata.images;

% extract first image from dataset
image = images{1};

% compute features for image
features = computeFeatures(image);

[height, width] = size(image);

% reconstructing image data with computed features
pixelCount = 0;
for i = 1 : width
    for j = 1 : height
        pixelCount = pixelCount + 1;
        image_(j, i) = features(1, pixelCount);
        imageGx(j, i) = features(2, pixelCount);
        imageGy(j, i) = features(3, pixelCount);
        imageHaarlike1(j, i) = features(4, pixelCount);
        imageHaarlike2(j, i) = features(24, pixelCount);
        imageGradientMag(j, i) = features(44, pixelCount);
    end
end

% plotting features
fig = figure;
set(fig, 'Position', [0 0 1600 1200])

subplot(2, 3, 1);
imagesc(image_);
colormap winter
axis('equal')
title('Feature: Gray values')

subplot(2, 3, 2);
imagesc(imageGx);
axis('equal')
title('Feature: Gradient in x-direction')

subplot(2, 3, 3);
imagesc(imageGy);
axis('equal')
title('Feature: Gradient in y-direction')

subplot(2, 3, 4);
imagesc(imageHaarlike1);
axis('equal')
title('Feature: HaarLike features for image')

subplot(2, 3, 5);
imagesc(imageHaarlike2);
axis('equal')
title('Feature: HaarLike features for gradient magnitude')

subplot(2, 3, 6);
imagesc(imageGradientMag);
axis('equal')
title('Feature: Gradient magnitude')

%%
% Fragestellung 3: Klassifikation & Feature-Selection
% 
clear;

handdata = load('handdata.mat');
trainImages = handdata.images(1:30);
trainMasks = handdata.masks(1:30);

% train a random forest with training dataset
randomForest = cache(@train, trainImages, trainMasks);

figure('name', 'Out-of-bag classification error');
plot(oobError(randomForest));
grid on;
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';

figure('name', 'Feature significance');
bar(randomForest.OOBPermutedVarDeltaError);
grid on;

% 
%%
% Fragestellung 4: Shape Particle Filters
% 
clear;

handdata = load('handdata.mat');
images = handdata.images;
masks = handdata.masks;
aligned = handdata.aligned;
landmarks = handdata.landmarks;

% train random forest for classification on test data
rf = cache(@train, images(1:30), masks(1:30));

% calculating PCA for aligned shapes in handdata
[n, dim, numberOfShapes] = size(aligned);

% generate mean shape
meanShape = mean(aligned, 3);

% align x- and y- coordinates for all shapes (reduce dimensionality)
for i = 1 : dim - 1
    coordVector = cat(1, aligned(:, i, :), aligned(:, i + 1, :));
    coordVector = squeeze(coordVector);
end

% calculate pca with aligned shape data
[ dataMean, eigenVectors, eigenValues ] = pca(coordVector);

% calculate b that contains 100% of total variance
b = zeros(size(eigenVectors(:, 1)));

sumEigenValues = sum(eigenValues);
normalizedEigenValues = eigenValues / sumEigenValues;

currentSumOfVariances = 0;
amountOfEigenValuesNeeded = 0;
b = zeros(size(eigenVectors(:, 1)));
for i = 1 : size(eigenVectors(:, 1))
    currentSumOfVariances = currentSumOfVariances + normalizedEigenValues(i);
    if (currentSumOfVariances >= 0.99)
        amountOfEigenValuesNeeded = i;
        break;
    end
end
b(1:amountOfEigenValuesNeeded) = eigenValues(1:amountOfEigenValuesNeeded);

% calculate minimums and maximums for optimization over training set
minX = intmax('int16');
minY = intmax('int16');
maxX = 0;
maxY = 0;
for i = 1 : 30
    mins = min(landmarks{i}, [], 2);
    maxs = max(landmarks{i}, [], 2);
    if (mins(1) < minX)
        minX = mins(1);
    end
    if (mins(2) < minY)
        minY = mins(2);
    end
    if (maxs(1) > maxX)
        maxX = maxs(1);
    end
    if (maxs(2) > maxY)
        maxY = maxs(2);
    end
end

minimums = [ - pi * 0.3; 0.8; minX; minY ];
maximums = [ pi * 0.3; 1.2; maxX; maxY ];

shapeDiffs = zeros(64, 20);

% calculate best fitting shape for test dataset
for i = 31 : 50
    % extract current image from data set
    currentImage = images{i};
    currentLandmarks = landmarks{i}';
    
    % get prediction for current image from classificator (results in
    % labels that show class membership)
    predictionLabels = predict_(rf, currentImage);
    
    % construct binary image from predicted labels
    binLabels = zeros(size(currentImage));
    binLabels(strcmp(predictionLabels, 'Contour')) = 1;
    
    % optimize shape
    bestShape = optimizeShape(eigenVectors(:, 1), b, meanShape, binLabels, minimums, maximums);
    
    % plot best shape
    figure('name', ['Segmentation for image ', num2str(i)]);
    subplot(1, 2, 1)
    imshow(currentImage);
    hold on;
    plot(bestShape(:, 1), bestShape(:, 2));
    
    subplot(1, 2, 2)
    imshow(binLabels);
    hold on;
    plot(bestShape(:, 1), bestShape(:, 2));
    
    % calculate average error for each data point
    shapeDiffs(:, i - 30) = sum(abs(bestShape - currentLandmarks), 2) / 2;
end

% visualize error rate
figure('name', 'Average error of single data points');
boxplot(shapeDiffs, 'notch', 'on');
grid on;



end