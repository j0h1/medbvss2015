function generatedShape = generateShape( meanModel, eigenVectors, b, r, s, x, y )
%GENERATESHAPE Summary of this function goes here
%   Detailed explanation goes here

generatedShape = eigenVectors' * b + meanModel;

end

