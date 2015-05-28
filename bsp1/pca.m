function [ dataMean, eigenVectors, eigenValues ] = pca( D )
%PCA Summary of this function goes here
%   Detailed explanation goes here

% D needs to be dxn
[dim, n] = size(D);

% Mittelwert-Vektor bestimmt das Zentrum der Daten
dataMean = mean(D, 2);

% Zentrierung der Daten durch Subtrahieren des Mittelwertes
D = D - repmat(dataMean, 1, n);

% Bilden der Kovarianzmatrix (ourCov verlangt dim x n Matrix)
C = ourCov(D);

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

end