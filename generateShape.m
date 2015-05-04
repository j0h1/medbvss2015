function [ generatedShape ] = generateShape( meanModel, eigenVectors, b )
%GENERATESHAPE Summary of this function goes here
%   Detailed explanation goes here

% shape model
generatedShape = meanModel + eigenVectors .* b;

end

