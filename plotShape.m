function [  ] = plotShape( shapes, meanModel, eigenVectors, stdderivations )
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

% iteriere über alle Bildpunkte und variiere Standardabweichung des
% aktuellen Modes von -3 bis + 3
for i = 1 : size(stdderivations, 1)
    % Standardabweichung für aktuellen Modus i
    lambda = stdderivations(i, :);
    
    b = zeros(size(stdderivations, 1), 2);
    
    for j = -3 : 0.5 : 3
        % Variation der Standardabweichung des aktuellen Modes in
        % Parametervektor b schreiben
        b(i, :) = j * lambda;
        
        % uns interessiert die Abweichung des aktuellen Werts vom
        % Erwartungswert, deswegen wird Mean-Shape verwendet
        temp = generateShape(meanModel, eigenVectors, b);
        plot(temp(:, 1), temp(:, 2), 'Color', 'g');
    end
end

end

