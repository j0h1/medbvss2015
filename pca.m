function [ dataMean, eigenVectors, eigenValues ] = pca( D )
%PCA Summary of this function goes here
%   Detailed explanation goes here

% Transponierung in n x dim
D = D';

n = size(D, 1);
dim = size(D, 2);

% Mittelwert-Vektor bestimmt das Zentrum der Daten
dataMean = mean(D, 1);

% Zentrierung der Daten durch Subtrahieren des Mittelwertes
D = D - repmat(dataMean, n, 1);

% Bilden der Kovarianzmatrix (ourCov verlangt dim x n Matrix)
C = ourCov(D');

% Berechnung der Eigenvektoren
% eigenVectors = Matrix mit normierten Eigenvektoren in den Spalten
% eigenValueMatrix = Diagonal-Matrix mit Eigenwerten als Eintr‰gen
[eigenVectors, eigenValueMatrix] = eig(C);

% nur Werte der Eigenwerte-Matrix anzeigen, die nicht 0 sind und
% anschlieﬂend transponieren, damit Reihenvektor daraus wird
eigenValues = eigenValueMatrix(eigenValueMatrix ~= 0)';

% Eigenwerte absteigend sortieren und Index von Eigenvektor-Matrix,
% sowie Eigenwert-Vektor entsprechend anpassen
[tmp, ind] = sort(eigenValues, 'descend');

eigenVectors = eigenVectors(:, ind);
eigenValues = eigenValues(ind);

% Reduzierung der Eigenwerte/Eigenvektoren auf 2 (2D) bzw. 3 (3D)
eigenVectors = eigenVectors(:, 1 : dim - 1);
eigenValues = eigenValues(1 : dim - 1);

end

