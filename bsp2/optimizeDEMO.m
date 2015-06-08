function optimizeDEMO

close all
dbstop if error

[surface, minimums, maximums] = makeOptimizationLandscape1;
costFunction = makeCostFunction(surface);

figure;
imagesc(surface);

optimize(costFunction,minimums,maximums,@drawPopulation);
end

function [r, mi, ma] = makeOptimizationLandscape1
    mi = [1; 1];
    ma = [ 300;  200];
    [X,Y] = meshgrid((mi(1):ma(1))-100,(mi(2):ma(2))-70);
    r = sqrt(X.^2 + Y.^2)/5;
    r = -sin(r)./r;
    r(isnan(r)) = -1;
end

function f = makeCostFunction(costSurface)
    f = @costFunction;
    function c = costFunction(params)
        c = costSurface(round(params(2)),round(params(1)));
    end
end

function h = drawPopulation(population, bestInd)
    h(1) = plot(population(1,:),population(2,:),'wx'); hold on
    h(2) = plot(population(1,:),population(2,:),'b+'); hold on
    h(3) = plot(population(1,bestInd),population(2,bestInd),'g+');
end