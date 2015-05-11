function [  ] = RUN ( ~ )
%RUN Summary of this function goes here
%   Detailed explanation goes here

%
%Fragestellung 1: Kovarianzmatrix
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
%     % data ist eine d x n Matrix -> transponieren
%     plot2DPCA(data', dataMean, data', eigenVectors, eigenValues, 1, 1);
% end

%%
% Fragestellung 3: Unterraum-Projektion
% 
% disp(' ')
% disp('--------------------')
% disp('Fragestellung 3a')
% disp(' ')
% 
% daten = load('daten.mat');
% data = daten.data3;
% 
% dim = size(data, 1);
% n = size(data, 2);
% 
% [ dataMean, eigenVectors, eigenValues ] = pca(data);
% 
% % zenriere Daten
% rowDataAdjust = data - repmat(dataMean, 1, size(data, 2));
% 
% % extrahiere Hauptkomponente
% rowFeatureVector = eigenVectors(:, 1)';
% 
% % Ableitung der Daten nach Hauptvektor (Reduktion um 1 Dimension)
% finalData = rowFeatureVector * rowDataAdjust;
% 
% % Rekonstruktion der Daten
% recData = (rowFeatureVector' * finalData) + repmat(dataMean, 1, size(data, 2));
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
% rowDataAdjust = data - repmat(dataMean, 1, size(data, 2));
% 
% % Extrahiere Nebenvektor
% rowFeatureVector = eigenVectors(:, 2)';
% 
% % Ableitung der Daten nach Nebenvektor
% finalData = rowFeatureVector * rowDataAdjust;
% 
% % Rekonstruktion der Daten
% recData = (rowFeatureVector' * finalData) + repmat(dataMean, 1, size(data, 2));
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
disp(' ');
disp('--------------------')
disp('Fragestellung 4a - Untersuchung in 3D');
disp(' ');

daten = load('daten3d.mat');
data = daten.data;

dim = size(data, 1);
n = size(data, 2);

[ dataMean, eigenVectors, eigenValues ] = pca(data);

plot3DPCA(data', dataMean', eigenVectors, eigenValues, 1, 1);

%%
%Fragestellung 4b: Untersuchung in 3D
%
rowDataAdjust = data - repmat(dataMean, 1, size(data, 2));
rowFeatureVector = eigenVectors(:, 1:2)';
finalData = rowFeatureVector * rowDataAdjust;

% Rekonstruktion der Daten
recData = (rowFeatureVector' * finalData) + repmat(dataMean, 1, size(data, 2));

plot3DPCA(recData', dataMean', eigenVectors, eigenValues, 1, 1);
% Welche Information wurde verloren?
% eigenValues = 5.0861   28.6518   121.1251
% es ist relativ wenig Information verloren gegangen, da nur der
% Eigenvektor mit dem geringsten Eigenwert entfernt wurde
% Der entfernte Eigenvektor bezieht sich auf die X-Koordinaten


% %%
% % Fragestellung 5a: Shape Modell
% % 
disp(' ');
disp('--------------------')
disp('Fragestellung 5a - Shape Modell');
disp(' ');

daten = load('shapes.mat');
aligned = daten.aligned;

% Mean-Modell generieren
meanModel = mean(aligned, 3);

% converting data to 256x14 coordVector (page 29 - RAASM)
for i = 1 : size(aligned, 2) - 1
    coordVector = cat(1, aligned(:, i, :), aligned(:, i + 1, :));
    coordVector = squeeze(coordVector);  %removes singleton dimensions
end

size(coordVector)

[ dataMean, eigenVectors, eigenValues ] = pca(coordVector);

%%
% Fragestellung 5b: Shape Modell
% 

shapes = zeros(128, 2, 7);
for i = 1 : 7
    % Parametervektor b mit Länge der Eigenvektoren initialisieren
    b = zeros(size(eigenVectors(:, 1)));
    % sqrt(eigenValue) entspricht der Standardabweichung des Faktors in PCA
    b(1) = (i - 4) * sqrt(eigenValues(1));
    shapes(:, :, i) = generateShape(meanModel, eigenVectors(:, 1), b);  
end

plotShape(shapes, meanModel);

%%
% Fragestellung 5c: Shape Modell
% 

% berechne Parametervektor lt. Angabe
stdDeviations = sqrt(eigenValues);
b = randn(1, size(eigenVectors(: , 1), 1)) .* stdDeviations; % Zeilenvektor

% sumEigenValues entspricht der GESAMTVARIANZ
sumEigenValues = sum(eigenValues);

normalizedEigenValues = eigenValues / sumEigenValues;

currentSumOfVariances = 0;
found80 = false;
found90 = false;
found95 = false;

figure;
b_ = zeros(size(b))';
for i = 1 : size(normalizedEigenValues, 2)
    currentSumOfVariances = currentSumOfVariances + normalizedEigenValues(i);
    
    if (currentSumOfVariances >= 0.8)
        % momentane Anzahl i an Eigenwerten repräsentieren >= 80% der
        % Gesamtvarianz
        if (found80 == false)
            found80 = true;
            disp(['reached 80% at position ', num2str(i)]);
            
            b_(1:i) = b(1:i);
            shape = generateShape(meanModel, eigenVectors(:, 1), b_);
            plot(shape(:, 1), shape(:, 2), 'Color', [1, 1, 0]); % yellow
            hold on;
        end
    end
    if (currentSumOfVariances >= 0.9)
        if (found90 == false)
            found90 = true;
            disp(['reached 90% at position ', num2str(i)]);
            
            b_(1:i) = b(1:i);
            shape = generateShape(meanModel, eigenVectors(:, 1), b_);
            plot(shape(:, 1), shape(:, 2), 'Color', [1, 0, 0]); % red
            hold on;
        end
    end
    if (currentSumOfVariances >= 0.95)
        if (found95 == false)
            found95 = true;
            disp(['reached 95% at position ', num2str(i)]);
            
            b_(1:i) = b(1:i);
            shape = generateShape(meanModel, eigenVectors(:, 1), b_);
            plot(shape(:, 1), shape(:, 2), 'Color', [0, 1, 0]); % green
            hold on;
        end
    end
    if (currentSumOfVariances >= 1)
        disp(['reached 100% at position ', num2str(i)]);

        b_(1:i) = b(1:i);
        shape = generateShape(meanModel, eigenVectors(:, 1), b_);
        plot(shape(:, 1), shape(:, 2), 'Color', [0, 0, 1]); % blue
        hold on;

        break;  % break out of loop after finding 100%
    end
    
end

clear;


end