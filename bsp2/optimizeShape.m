function bestShape = optimizeShape ( eigenVector, b, meanModel, prediction, minimums, maximums )
%OPTIMIZESHAPE Summary of this function goes here
%   Detailed explanation goes here

costFunctionCallCount = 0;
    
costFunction = makeCostFunction;

% calculate parameters (rotation, scale, x- and y- translation) for best
% fitting shape
best = optimize(costFunction, minimums, maximums);

% generate best shape
bestShape = generateShape(eigenVector, b, meanModel, best(1), best(2), best(3), best(4));

disp(['Anzahl der Aufrufe der Kostenfunktion: ', num2str(costFunctionCallCount)]);

function f = makeCostFunction
    f = @costFunction;    
    function c = costFunction(params)
        costFunctionCallCount = costFunctionCallCount + 1;
        
        generatedShape = generateShape(eigenVector, b, meanModel, params(1), params(2), params(3), params(4));
        
%         % hit-or-miss classification
%         binLabels = zeros(size(prediction));
%         % extract coordinates of prediction where contour was found
%         [y, x] = find(prediction);
%
%         for i = 1 : size(generatedShape, 1)
%             x = round(generatedShape(i, 1));
%             y = round(generatedShape(i, 2));
%             if (x > 0 && y > 0 && x < size(binLabels, 2) && y < size(binLabels, 1))
%                 binLabels(y, x) = 1;
%             end
%         end
%         
%         overlap = prediction - binLabels;
%         
%         where pixels are -1, no matches were found
%         misses = sum(sum(overlap == -1));
%         
%         c = misses / size(generatedShape, 1);
        
%         % calculate the minimum euclidean distance for every sample as cost
%         c = 0;
%         % extract coordinates of prediction where contour was found
%         [y, x] = find(prediction);
%
%         for i = 1 : size(generatedShape, 1)
%             x_shape = generatedShape(i, 1);
%             y_shape = generatedShape(i, 2);
%             
%             minDist = intmax('int16');
%             for j = 1 : size(x)
%                 diff_x = x(j) - x_shape;
%                 diff_y = y(j) - y_shape;
%                 
%                 dist = sqrt(diff_x * diff_x + diff_y * diff_y);
%                 
%                 if (dist < minDist)
%                     minDist = dist;
%                 end
%             end
%             c = c + minDist;
%         end

        % für jeden Punkt im Shape, untersuche Nachbarschaft in prediction
        sumNeighborhoodHits = 0;
        for i = 1 : size(generatedShape, 1)
            xShape = round(generatedShape(i, 1));
            yShape = round(generatedShape(i, 2));
            % border checking
            if (xShape - 1 > 0 && yShape - 1 > 0 && xShape + 1 <= size(prediction, 2) && yShape + 1 <= size(prediction, 1))
                % check neighborhood in prediction at points in shape
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape - 1);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape + 1);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape - 1);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape + 1);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape - 1);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape);
                sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape + 1);
            end
        end
        c = 1 / sumNeighborhoodHits;
        
%         % 25er Nachbarschaft
%         sumNeighborhoodHits = 0;
%         for i = 1 : size(generatedShape, 1)
%             xShape = round(generatedShape(i, 1));
%             yShape = round(generatedShape(i, 2));
%             % border checking
%             if (xShape - 1 > 0 && yShape - 1 > 0 && xShape + 1 <= size(prediction, 2) && yShape + 1 <= size(prediction, 1))
%                 % check neighborhood in prediction at points in shape
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape + 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape + 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape + 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 2, xShape - 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 2, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 2, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 2, xShape + 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 2, xShape + 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape + 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape + 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape + 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 2, xShape + 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 2, xShape + 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 2, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 2, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 2, xShape - 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape + 1, xShape - 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape, xShape - 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + prediction(yShape - 1, xShape - 2);
%             end
%         end
%         c = 1 / sumNeighborhoodHits;
        
%         % Manhattan Nachbarschaft
%         sumNeighborhoodHits = 0;
%         for i = 1 : size(generatedShape, 1)
%             xShape = round(generatedShape(i, 1));
%             yShape = round(generatedShape(i, 2));
%             % border checking
%             if (xShape - 2 > 0 && yShape - 2 > 0 && xShape + 2 <= size(predictedLabels, 2) && yShape + 2 <= size(predictedLabels, 1))
%                 % check neighborhood in prediction at points in shape
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape - 1, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape - 1, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape - 2, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape - 1, xShape + 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape, xShape - 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape, xShape + 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape, xShape + 2);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape + 1, xShape - 1);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape + 1, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape + 2, xShape);
%                 sumNeighborhoodHits = sumNeighborhoodHits + predictedLabels(yShape + 1, xShape + 1);
%             end
%         end
%         c = 1 / sumNeighborhoodHits;
    end
end

end

