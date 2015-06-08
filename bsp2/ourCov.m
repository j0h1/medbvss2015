function [ cov ] = ourCov ( D )
%OURCOV Summary of this function goes here
%   Detailed explanation goes here

% Formel: 1 / (n - 1) * sum(1, n)(x - m)*(x - m)^T
dim = size(D, 1);
n = size(D, 2);

% Mittelwert-Vektor der Daten D berechnen
meanVector = mean(D, 2);

% Kovarianzmatrix initialisieren
cov = zeros(dim);

% Summen-Part der Kovarianzmatrix-Berechnung
for i = 1 : n
   cov = cov + ((D(:, i) - meanVector) * (D(:, i) - meanVector)');
end

cov = 1 / (n - 1) * cov;

end