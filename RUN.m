function [  ] = RUN ( ~ )
%RUN Summary of this function goes here
%   Detailed explanation goes here

%%
% Fragestellung 1: Kovarianzmatrix
%
% disp('--------------------')
% disp('Fragestellung 1 - Kovarianzmatrix')
% disp(' ')
% 
% daten = load('daten.mat');
% 
% fieldNames = fieldnames(daten);
% 
% for i = 1 : numel(fieldNames)
%     data = daten.(fieldNames{i});
%     disp(fieldNames{i});
%     disp(ourCov(data));
%     x = data(1, :);
%     y = data(2, :);
%     
%     figure('name', fieldNames{i});
%     plot(x, y, '*');
%     axis equal;
% end

%%
% Fragestellung 2: PCA
% 
% disp(' ')
% disp('--------------------')
% disp('Fragestellung 2 - PCA')
% disp(' ')
% for i = 1 : numel(fieldNames)
%     data = daten.(fieldNames{i});
%     [ dataMean, eigenVectors, eigenValues ] = pca(data);
%     
%     rowDataAdjust = data - repmat(dataMean, size(data, 2), 1)';
%     rowFeatureVector = eigenVectors(:, 1)';
%     finalData = rowFeatureVector * rowDataAdjust;
%     recData = (rowFeatureVector' * finalData) + repmat(dataMean, size(data, 2), 1)';    
%     
%     % data ist eine d x n Matrix, also müssen wir diese transponieren
%     plot2DPCA(data', dataMean, recData, eigenVectors, eigenValues, 0, 0);
% end

%%
% Fragestellung 3: Unterraum-Projektion
% 
% disp(' ')
% disp('--------------------')
% disp('Fragestellung 3a')
% disp(' ')
% daten = load('daten.mat');
% data = daten.data3;
% 
% dim = size(data, 1);
% n = size(data, 2);
% 
% [ dataMean, eigenVectors, eigenValues ] = pca(data);
% 
% rowDataAdjust = data - repmat(dataMean, n, 1)';
% 
% rowFeatureVector = eigenVectors(:, 1)';
% 
% % Ableitung der Daten nach Hauptvektor
% finalData = rowFeatureVector * rowDataAdjust;
% 
% figure('name', 'Fragestellung 3 - Projektion von data3 auf Hautpvektor');
% plot(finalData, '*');
% 
% % Rekonstruktion der Daten
% recData = (rowFeatureVector' * finalData) + repmat(dataMean, n, 1)';
% 
% % Plotten der rekonstruierten Daten
% plot2DPCA(data', dataMean, recData', eigenVectors, eigenValues, 0, 1);
% 
% % durchschnittlicher Fehler
% avg_error = sum(abs(data' - recData')) / n;
% disp('Durchschnittlicher Fehler zwischen Rekonstruktion und Originaldaten:');
% disp('für X:');
% disp(avg_error(1));
% disp('für Y:');
% disp(avg_error(2));
% 
% %%
% % selbe Untersuchung mit Nebenvektor statt Hauptvektor
% %
% disp(' ')
% disp('Fragestellung 3b')
% disp(' ')
% rowDataAdjust = data - repmat(dataMean, n, 1)';
% 
% rowFeatureVector = eigenVectors(:, 2)';
% 
% % Ableitung der Daten nach Hauptvektor
% finalData = rowFeatureVector * rowDataAdjust;
% 
% % Rekonstruktion der Daten
% recData = (rowFeatureVector' * finalData) + repmat(dataMean, n, 1)';
% 
% % Plotten der rekonstruierten Daten
% plot2DPCA(data', dataMean, recData', eigenVectors, eigenValues, 0, 1);
% 
% % durchschnittlicher Fehler
% avg_error = sum(abs(data' - recData')) / n;
% disp('Durchschnittlicher Fehler zwischen Rekonstruktion und Originaldaten:');
% disp('für X:');
% disp(avg_error(1));
% disp('für Y:');
% disp(avg_error(2));

%%
% Fragestellung 4a: Untersuchung in 3D
%
% disp(' ');
% disp('--------------------')
% disp('Fragestellung 4a - Untersuchung in 3D');
% disp(' ');
% daten = load('daten3d.mat');
% 
% data = daten.data;
% 
% dim = size(data, 1);
% n = size(data, 2);
% 
% [ dataMean, eigenVectors, eigenValues ] = pca(data);
% 
% plot3DPCA(data', dataMean, eigenVectors, eigenValues, [1 1]);
% 
% %%
% %Fragestellung 4b: Untersuchung in 3D
% %
% rowDataAdjust = data - repmat(dataMean, n, 1)';
% rowFeatureVector = eigenVectors(:, 1:2)';
% finalData = rowFeatureVector * rowDataAdjust;
% 
% figure('name', 'Fragestellung 4b - Projektion auf Unterraum (1. und 2. Eigenvektor)');
% plot(finalData(1, :), finalData(2, :), '*');
% 
% % Rekonstruktion der Daten
% recData = (rowFeatureVector' * finalData) + repmat(dataMean, n, 1)';
% 
% plot3DPCA(recData', dataMean, eigenVectors, eigenValues);
% Welche Information wurde verloren?
% eigenValues = 5.0861   28.6518   121.1251
% es ist relativ wenig Information verloren gegangen, da nur der
% Eigenvektor mit dem geringsten Eigenwert entfernt wurde
% Der entfernte Eigenvektor bezieht sich auf die X-Koordinaten


%%
% Fragestellung 5a: Shape Modell
% 
disp(' ');
disp('--------------------')
disp('Fragestellung 5a - Shape Modell');
disp(' ');

daten = load('shapes.mat');
aligned = daten.aligned;

% Mean-Modell generieren
meanModel = mean(aligned, 3);

eigenValueRowVector = zeros(1, size(meanModel, 1));
eigenVectorMatrix = zeros(size(meanModel));

for i = 1 : size(aligned, 1)
    % squeeze entfernt eine Dimension: wir interessieren uns für die
    % x-/y-Werte der 14 Shapes -> 1 Reihe, 2 Spalten in 14 Dimensionen
    % "nach hinten" -> squeeze macht 2D-Array draus
    [ dataMean, eigenVectors, eigenValues ] = pca(squeeze(aligned(i, :, :)));
    
    eigenValueRowVector(i) = eigenValues;
    eigenVectorMatrix(i, :) = eigenVectors';
end

%%
% Fragestellung 5b
%
% berechne Standardabweichung für Shapes
stdderivations = std(aligned, 0, 3);

% plotte Shapes
plotShape(aligned, meanModel, eigenVectorMatrix, stdderivations);

disp('Rot = Mean-Model');
disp('Blau = Shapes');
disp('Grün = Standardabweichung der Modes bezogen auf Mean-Model');

%%
% Fragestellung 5c
%
% Parameter-Vektor entspricht der Standardabweichung der Punkte, wobei
% jeder Punkt mit einem random-Zahlenwert multipliziert wird
% b = repmat(randn(1, size(eigenVectorMatrix, 1)), 2, 1)' .* stdderivations
% 
% % berechne Varianz für Shapes
% variance = var(aligned, 0, 3);
% 
% % Gesamtvarianz
% sumVariance = sum(variance);
% 
% a = generateShape(meanModel, eigenVectorMatrix, b);
% figure;
% plot(a(:, 1), a(:, 2));


end