% plot3DPCA visualize eigenvectors and eigenvalues
%
%  plot3DPCA(origData, dataMean, eigenVectors, eigenValues)
%  plot3DPCA(origData, dataMean, eigenVectors, eigenValues, showStd)
%  plot3DPCA(origData, dataMean, eigenVectors, eigenValues, showStd, showReconstruction)
%
%  Plots the original 3d dataset and mean of data. The direction of the
%  Eigenvectors is shown and scaled according to the corresponding Eigenvalues.
%
%  Optionally isosurfaces can be displayed showing 1x, 2x and 3x standard
%  deviation. Reconstructed data using the 2 most significant eigenvectors can
%  be displayed too.
%
%  origData: original data values (Nx2 matrix)
%  dataMean: mean (center) of data values (1x2 matrix)
%  eigenVectors: 3x3 matrix containing eigenvectors in colums (sorted by
%           descending eigenvalues)
%  eigenValues: 1x3 diagonal matrix containing eigenvalus (sorted descending)
%  showStd: (optional) default: 0=don't plot std deviations, 1=show std deviations
%  showReconstruction: (optional) default: 0=don't reconstruct data,
%  1=reconstruct data using the 2 most significant eigenvectors

function plot3DPCA(data, mju, eigVec, eigVal, varargin)

if nargin>=5
    showStd = varargin{1};
else
    showStd=0;
end

if nargin == 6
    showReconstruct=varargin{2};
else
    showReconstruct = 0;
end

figure
plot3(data(:,1), data(:,2), data(:,3), 'b.')
hold on

%plot([-10 10], [-10 10].*(v1(2)/v1(1)), 'g-')
%plot([-22 22], [-22 22].*(v2(2)/v2(1)), 'r-')


v1 = eigVec(:,1)';
e1 = eigVal(1);
dir1 = v1.*sqrt(e1);

v2 = eigVec(:,2)';
e2 = eigVal(2);
dir2 = v2.*sqrt(e2);

v3 = eigVec(:,3)';
e3 = eigVal(3);
dir3 = v3.*sqrt(e3);


C = cov(data);


% 
varData = data-repmat(mju, length(data), 1);



% mean
plot3(mju(1), mju(2), mju(3), 'ro')

% eigvec 1
plot3([mju(1)-dir1(1), mju(1)+dir1(1)], [mju(2)-dir1(2), mju(2)+dir1(2)], [mju(3)-dir1(3), mju(3)+dir1(3)], 'b-')

% eigvec 2
plot3([mju(1)-dir2(1), mju(1)+dir2(1)], [mju(2)-dir2(2), mju(2)+dir2(2)], [mju(3)-dir2(3), mju(3)+dir2(3)], 'b-')

% eigvec 3
plot3([mju(1)-dir3(1), mju(1)+dir3(1)], [mju(2)-dir3(2), mju(2)+dir3(2)], [mju(3)-dir3(3), mju(3)+dir3(3)], 'b-')



legs = {'Daten', 'Mittelwert', 'Eigenvektor', '', ''};

if showStd
alpha = 0.2;
h = error_ellipse(C, mju, 'conf', 0.683);
set(h, 'FaceColor', 'r', 'EdgeColor', 'r', 'FaceAlpha', alpha, 'EdgeAlpha', 0);

h = error_ellipse(C, mju, 'conf', 0.954);
set(h, 'FaceColor', 'g', 'FaceAlpha', alpha, 'EdgeAlpha', 0);

h = error_ellipse(C, mju, 'conf', 0.997);
set(h, 'FaceColor', 'b', 'FaceAlpha', alpha, 'EdgeAlpha', 0);

legs = {legs{:}, '1x Standardabweichung', '2x Standardabweichung', '3x Standardabweichung'};
end

if showReconstruct
    neuData = (eigVec' * varData')';
    %neuData(:,3) = 0;
    rekData = (eigVec(:,[1 2]) * neuData(:,[1 2])')'+repmat(mju,length(neuData), 1);
    plot3(rekData(:,1), rekData(:,2), rekData(:,3), 'g*');
    legs = {legs{:} 'Reconstruction'};

    
    for i=1:length(data)
        h = line([data(i,1) rekData(i,1)], [data(i,2) rekData(i,2)], [data(i,3) rekData(i,3)]);
        set(h, 'LineStyle', ':');
    end

legend(legs)
axis equal
grid on

end