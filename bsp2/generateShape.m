function generatedShape = generateShape(eigenVectors, b, meanModel, r, s, x, y )
%GENERATESHAPE Summary of this function goes here
%   Detailed explanation goes here

generatedShape = eigenVectors' * b + meanModel;

% scaling
generatedShape = generatedShape * s;

% rotation
generatedShape = generatedShape * [cos(r) -sin(r); sin(r) cos(r)];

% x-translation
generatedShape(:, 1) = generatedShape(:, 1) + x;

% y-translation
generatedShape(:, 2) = generatedShape(:, 2) + y;

end