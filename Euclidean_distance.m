%% Script to calculate pairwise Euclidean distance based on Schaefer 200_7
clear all
[num txt raw] = xlsread('Schaefer_200_7_CentroidCoord.xlsx');

dist_matrix = pdist2(num,num);

save('Euclidean_distance_Schaefer_200_7.mat', 'dist_matrix');



