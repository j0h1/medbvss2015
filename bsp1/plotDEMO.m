

%% demonstration of 2d pca visualization:

clear all
load demoData

disp('2d pca demo... ')
dummyReconstruction2 = data2;  % here you would use your reconstructed data
plot2DPCA(data2, dataMean2, dummyReconstruction2, sortedEigVec2, sortedEigVal2, 1, 1)


% demonstration of 3d pca visualization:
disp('3d pca demo... ')
dummyReconstruction3 = data3;  % here you would use your reconstructed data
plot3DPCA(data3, dataMean3, sortedEigVec3, diag(sortedEigVal3), 1, 1)

