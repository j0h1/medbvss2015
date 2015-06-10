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

features = zeros(46, width * height);

pixelCounter = 0;
for i = 1 : width    
    for j = 1 : height
        pixelCounter = pixelCounter + 1;
        
        % storing gray scale image values in feature vector
        features(1, pixelCounter) = image(j, i);
        
        % storing gradients in x- and y-direction
        features(2, pixelCounter) = Gx(j, i);
        features(3, pixelCounter) = Gy(j, i);
        
        % storing all 20 haarlike features for image as single features
        features(4:23, pixelCounter) = haarlikeImage(1:20, pixelCounter);
        
        % storing all 20 haarlike features for gradient magnitude as single features
        features(24:43, pixelCounter) = haarlikeGradientMag(1:20, pixelCounter);
        
        % storing gradient magnitude
        features(44, pixelCounter) = Gmag(j, i);
        
        % storing x- and y-coordinates
        features(45, pixelCounter) = i;
        features(46, pixelCounter) = j;
    end    
end

end

