function features = computeFeatures( image )
%COMPUTEFEATURES Summary of this function goes here
%   Detailed explanation goes here

[height, width] = size(image);

% calculate gradients in x- and y-direction for image
[Gx, Gy] = gradient(double(image));

% calculate gradient magnitude
Gmag = sqrt(Gx .* Gx + Gy .* Gy);

% compute HaarLike features for image
haarlikeImage = computeHaarLike(image);

% compute HaarLike features for gradient magnitude
haarlikeGradientMag = computeHaarLike(Gmag);

pixelCounter = 0;
for i = 1 : height    
    for j = 1 : width
        pixelCounter = pixelCounter + 1;
        
        % storing gray scale image values in feature vector
        features(1, pixelCounter) = image(i, j);
        
        % storing gradients in x- and y-direction
        features(2, pixelCounter) = Gx(i, j);
        features(3, pixelCounter) = Gy(i, j);
        
        % storing all 20 haarlike features for image as single features
        features(4:23, pixelCounter) = haarlikeImage(1:20, pixelCounter);
        
        % storing all 20 haarlike features for gradient magnitude as single features
        features(24:43, pixelCounter) = haarlikeGradientMag(1:20, pixelCounter);
        
        % storing gradient magnitude
        features(44, pixelCounter) = Gmag(i, j);
        
        % storing x- and y-coordinates
        features(45, pixelCounter) = j;
        features(46, pixelCounter) = i;
    end    
end

end

