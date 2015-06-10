function optimizeShape ( eigenVector, b, meanModel, predictedLabels, image, landmarks )
%OPTIMIZESHAPE Summary of this function goes here
%   Detailed explanation goes here

% setting boundaries for optimization
minimums = [ -0.2 * pi; 0.9; min(landmarks(1, :)); min(landmarks(2, :)) ];
maximums = [ 0.2 * pi; 1.1; max(landmarks(1, :)); max(landmarks(2, :)) ];
    
costFunction = makeCostFunction;

best = optimize(costFunction, minimums, maximums);

best

function f = makeCostFunction
    f = @costFunction;    
    function c = costFunction(params)
        generatedShape = generateShape(eigenVector, b, meanModel, params(1), params(2), params(3), params(4));
    
        % extract coordinates of prediction where contour was found
        [y, x] = find(predictedLabels);
        
        figure;
        imshow(image);
        hold on;
        plot(generatedShape(:, 1), generatedShape(:, 2));
        hold on;

        % TODO find a better way to find a cost for a shape...
        
        % calculate the minimum euclidean distance for every sample as cost
        c = 0;
        for i = 1 : size(generatedShape, 1)
            x_shape = generatedShape(i, 1);
            y_shape = generatedShape(i, 2);
            
            minDist = intmax('int16');
            for j = 1 : size(x)
                diff_x = x(j) - x_shape;
                diff_y = y(j) - y_shape;
                
                dist = sqrt(diff_x * diff_x + diff_y * diff_y);
                
                if (dist < minDist)
                    minDist = dist;
                end
            end
            c = c + minDist;
        end
        disp(['mindistance=', num2str(c)]);
    end
end

% function h = drawPopulation(population, bestInd)    
%     imshow(image);
    
%     for i = 1 : size(population, 2)
%         params = population(:, i);
%         shape = generateShape(eigenVector, b, meanModel, params(1), params(2), params(3), params(4));
% 
%         hold on;
%             
%         if (i == bestInd)
%             bestShape = shape;
%         else 
%             h = plot(shape(:,1), shape(:,2));
%             h.Color = 'blue';
%             h.LineStyle = '--';
%         end
%     end
%     params = population(:, bestInd);
%     plot(population(1, bestInd), population(2, bestInd),'g+');
%     
%     h = plot(bestShape(:, 1), bestShape(:, 2));
%     h.Color = 'green';
%     h.LineWidth = 2;
% end

end

