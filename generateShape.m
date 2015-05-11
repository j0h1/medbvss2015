function generatedShape = generateShape( meanModel, eigenVectors, b )
%GENERATESHAPE Summary of this function goes here
%   Detailed explanation goes here

generatedShape = eigenVectors' * b + meanModel;

end

