function [  ] = RUN ( ~ )
%RUN Summary of this function goes here
%   Detailed explanation goes here
%%
% Fragestellung 1: Shape-Modell
% 
% handdata = load('handdata.mat');
% aligned = handdata.aligned;
% 
% % extrahiere Dimensionen von Datensatz
% [n dim numberOfShapes] = size(aligned);
% 
% % Mean-Modell generieren
% meanModel = mean(aligned, 3);
% 
% for i = 1 : dim - 1
%     coordVector = cat(1, aligned(:, i, :), aligned(:, i + 1, :));
%     coordVector = squeeze(coordVector);
% end
% 
% % berechne PCA f�r Datensatz
% [ dataMean, eigenVectors, eigenValues ] = pca(coordVector);
% 
% generatedShapes = zeros(n, dim, 7);
% 
% for i = 1 : 7
%     % Parametervektor b mit L�nge der Eigenvektoren initialisieren
%     b = zeros(size(eigenVectors(:, 1)));
%     % sqrt(eigenValue) entspricht der Standardabweichung des Faktors in PCA
%     b(1) = (i - 4) * sqrt(eigenValues(1));
%     generatedShapes(:, :, i) = generateShape(eigenVectors(:, 1), b, meanModel, i * 30, i * 2, i * 100, i * 20);  
% end
% 
% % plotte generierte Shapes (blau) und Mean-Shape (rot)
% plotShape(generatedShapes, meanModel);

%%
% Fragestellung 2: Featureberechnung
% 
% handdata = load('handdata.mat');
% images = handdata.images;
% 
% % extract first image from dataset
% image = images{1};
% 
% % compute features for image
% features = computeFeatures(image);
% 
% [height, width] = size(image);
% 
% % reconstructing image data with computed features
% pixelCount = 0;
% for i = 1 : width
%     for j = 1 : height
%         pixelCount = pixelCount + 1;
%         image_(j, i) = features(1, pixelCount);
%         imageGx(j, i) = features(2, pixelCount);
%         imageGy(j, i) = features(3, pixelCount);
%         imageHaarlike1(j, i) = features(4, pixelCount);
%         imageHaarlike2(j, i) = features(24, pixelCount);
%         imageGradientMag(j, i) = features(44, pixelCount);
%     end
% end
% 
% figure('name', 'Originalbild'); imshow(image); axis('equal');
% figure('name', 'Feature: Gray values', 'NumberTitle', 'off'); imagesc(image_); axis('equal');
% figure('name', 'Feature: Gradient in x-direction', 'NumberTitle', 'off'); imagesc(imageGx); axis('equal');
% figure('name', 'Feature: Gradient in y-direction', 'NumberTitle', 'off'); imagesc(imageGy); axis('equal');
% figure('name', 'Feature: HaarLike features for image', 'NumberTitle', 'off'); imagesc(imageHaarlike1); axis('equal');
% figure('name', 'Feature: HaarLike features for gradient magnitude', 'NumberTitle', 'off'); imagesc(imageHaarlike2); axis('equal');
% figure('name', 'Feature: Gradient magnitude', 'NumberTitle', 'off'); imagesc(imageGradientMag); axis('equal');

%%
% Fragestellung 3: Klassifikation & Feature-Selection
% 
% handdata = load('handdata.mat');
% trainImages = handdata.images(1:30);
% trainMasks = handdata.masks(1:30);
% 
% % train a random forest with training dataset
% randomForest = cache(@train, trainImages, trainMasks);
% % randomForest = train(trainImages, trainMasks);
% 
% figure('name', 'Out-of-bag classification error');
% plot(oobError(randomForest));
% xlabel 'Number of grown trees';
% ylabel 'Out-of-bag classification error';
% 
% figure('name', 'Feature significance');
% bar(randomForest.OOBPermutedVarDeltaError);

%%
% Fragestellung 4: Shape Particle Filters
% 
handdata = load('handdata.mat');
images = handdata.images;
masks = handdata.masks;
aligned = handdata.aligned;
landmarks = handdata.landmarks{1};

rf = cache(@train, images(1:30), masks(1:30));

testImage = images{31};
predictionLabels = predict_(rf, testImage);

% reconstruction of binary image by predicted labels
binLabels = zeros(size(testImage));
binLabels(strcmp(predictionLabels, 'Contour')) = 1;

% calculating PCA for aligned shapes in handdata
[n, dim, numberOfShapes] = size(aligned);

% generate mean shape
meanShape = mean(aligned, 3);

for i = 1 : dim - 1
    coordVector = cat(1, aligned(:, i, :), aligned(:, i + 1, :));
    coordVector = squeeze(coordVector);
end

[ dataMean, eigenVectors, eigenValues ] = pca(coordVector);

b = zeros(size(eigenVectors(:, 1)));
b(1) = sqrt(eigenValues(1));

optimizeShape(eigenVectors(:, 1), b, meanShape, binLabels, testImage, landmarks);


end