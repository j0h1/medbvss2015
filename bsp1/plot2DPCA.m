%plot2DPCA visualize eigenvectors and eigenvalues
%  plot2DPCA(origData, dataMean, recData, eigenVectors, eigenValues, showStd, showReconstruction)
%
%  Plots the original 2d dataset and mean of data. The direction of the
%  Eigenvectors is shown and scaled according to the corresponding Eigenvalues.
%
%  Isolines can be displayed showing 1x, 2x and 3x standard
%  deviation. Reconstructed data using the more significant eigenvector can
%  be displayed too.
%
%  origData: original data values (Nx2 matrix)
%  dataMean: mean (center) of data values (1x2 matrix)
%  recData: reconstructed data values
%  eigenVectors: 2x2 matrix containing eigenvectors in colums (sorted by
%           descending eigenvalues)
%  eigenValues: 1x2 diagonal matrix containing eigenvalus (sorted descending)
%  showStd: 0=don't plot std deviations, 1=show std deviations
%  showReconstruction: 0=don't reconstruct data,
%  1=reconstruct data using the more significant eigenvector


function plot2DPCA(data, mju, recData, eigVec, eigVal, showStd, showReconstruction)



figure
plot(data(:,1), data(:,2), 'b.')
hold on



v1 = eigVec(:,1)';
e1 = eigVal(1,1);
dir1 = v1.*sqrt(e1);

v2 = eigVec(:,2)';
e2 = eigVal(2);
dir2 = v2.*sqrt(e2);

C = cov(data, 1);





% mean
plot(mju(1), mju(2), 'ro');

% eigvec 1
plot([mju(1)-dir1(1), mju(1)+dir1(1)], [mju(2)-dir1(2), mju(2)+dir1(2)], 'b-');

% eigvec 2
plot([mju(1)-dir2(1), mju(1)+dir2(1)], [mju(2)-dir2(2), mju(2)+dir2(2)], 'b-');




legs = {'Daten', 'Mittelwert', 'Eigenvektoren', ''};


if showStd==1
    %ellipse(sqrt(e2),sqrt(e1),ang,mju(1),mju(2))
    alpha = 0.1;
    h = error_ellipse(C, mju, 'conf', 0.683);
    set(h, 'Color', 'r', 'LineStyle', '--');

    h = error_ellipse(C, mju, 'conf', 0.954);
    set(h, 'Color', 'g', 'LineStyle', '--');
    h = error_ellipse(C, mju, 'conf', 0.997);
    set(h, 'Color', 'b', 'LineStyle', '--');

    legs = {legs{:} '1x Standardabweichung', '2x Standardabweichung', '3x Standardabweichung'};
end

if showReconstruction==1
    
    plot(recData(:,1), recData(:,2), 'g*');
    legs = {legs{:} 'Reconstruction'};

    
    for i=1:length(data)
        h = line([data(i,1) recData(i,1)], [data(i,2) recData(i,2)]);
        set(h, 'LineStyle', ':');
    end
    
end


legend(legs)
    
axis equal

grid on

end
