function [  ] = plotShape( shapes, meanModel )
%PLOTSHAPE Summary of this function goes here
%   Detailed explanation goes here

% plotte alle Shapes in blau
figure;

for i = 1 : size(shapes, 3)
    plot(shapes(:, 1, i), shapes(:, 2, i), 'Color', 'b');
    hold on;
end

% plotte Mean-Model in rot
plot(meanModel(:, 1), meanModel(:, 2), 'Color', 'r');

end
