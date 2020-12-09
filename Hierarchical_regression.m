% These are group-level analyses
clear all

% Load FC, aka y = response variable
fc = load('Young_groupmatrix_fc_run01_finalsample');
fc = fc.final_young_run01_fc;
fc = nanmean(fc,3);

% Load x = predictors
mssd = load('Young_groupmatrix_zmssd_run01_finalsample_reversed');
mssd = mssd.final_young_run01_mssd;
mssd = nanmean(mssd,3);

euclidean_distance = load('Euclidean_distance_Schaefer_200_7.mat');
euclidean_distance = euclidean_distance.dist_matrix;
euclidean_distance(find(eye(size(euclidean_distance)))) = NaN;

load('/lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/morphometric_similarity_groupatlas/Individ_morphometricsimilarity_finalyoung.mat');
morphometric_similarity = cat(3,morphometric_similarity(:).data);
morphometric_similarity = nanmean(morphometric_similarity,3);

%Vectorize them all
addpath '/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels'

roiIndx = [1:200];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

lowertriangle_fc = fc(lowTriagDataIndx)';
lowertriangle_mssd = mssd(lowTriagDataIndx)';
lowertriangle_dist = euclidean_distance(lowTriagDataIndx)';
lowertriangle_ms = morphometric_similarity(lowTriagDataIndx)';

%Now zscore their lowertriangles
zscored_mssd = zscore(lowertriangle_mssd);
zscored_dist = zscore(lowertriangle_dist);
zscored_ms = zscore(lowertriangle_ms);

%Now rebuild the matrices
diagonal(:,1:200)=NaN;

empty_matrix(1:200,1:200) = 0;

%Put diagonal back in
empty_matrix(find(eye(size(empty_matrix)))) = diagonal;

g = 2;
j = 199;
z = 1;
m = 0;

for i = 1:200
    j = j+m;
    empty_matrix(g:200,i) = zscored_mssd(z:j);
    g = g+1;
    z = j+1;
    m = length(empty_matrix(g:200,i));
end

% Mirror lower triang to upper triang to get full matrix: Inverted bootstrap ratio
zscored_mssd = tril(empty_matrix) + tril(empty_matrix,-1)';

for jj=1:200
    
    y = fc(:, jj);
    
    x1 = zscored_dist(:, jj);
    x2 = zscored_ms(:, jj);
    x3 = zscored_mssd(:, jj);
     
%     %Get predictors matrix
    nointerest = [x1 x2];
    middle = [nointerest x3];
    
    % fit multiple regression (OLS, main effects only)
    % exclude self-connections for all variables
    % N.B., `fitlm` adds an intercept by default
    lm_dist = fitlm(x1,y,'Exclude', jj); %just distance
    lm0 = fitlm(nointerest, y, 'Exclude', jj); %excluding the node itself
    lm1 = fitlm(middle, y, 'Exclude', jj);
    lm2 = fitlm(final, y,'y ~ x1 + x2 + x3 + x3*x4', 'Exclude', jj);
    % record adjusted R-square for node jj
    rsq_dist(jj) = lm_dist.Rsquared.Adjusted;
    rsq0(jj) = lm0.Rsquared.Adjusted;
    rsq1(jj) = lm1.Rsquared.Adjusted;
    rsq2(jj) = lm2.Rsquared.Adjusted;
    % record SSresidual
    ssres_dist(jj) = lm_dist.SSE;
    ssres0(jj) = lm0.SSE;
    ssres1(jj) = lm1.SSE;
    ssres2(jj) = lm2.SSE;
    
end

% Rearrange Rsq to have L nodes with R nodes
load('/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels/Schaefer_200Parcels_7Network_atlas.mat');
rearranged_rsq_dist = rsq_dist(1,index);
rearranged_rsq0 = rsq0(1,index);
rearranged_rsq1 = rsq1(1,index);
rearranged_rsq2 = rsq2(1,index);
plot(rearranged_rsq_dist,'y')
hold on
plot(rearranged_rsq0,'b')
hold on
plot(rearranged_rsq1,'g')
hold on
plot(rearranged_rsq2,'r')
hold off

save('Rearranged_rsq_dist.mat','rearranged_rsq_dist')
save('Rearranged_rsq0.mat','rearranged_rsq0')
save('Rearranged_rsq1.mat','rearranged_rsq1')
save('Rearranged_rsq2.mat','rearranged_rsq2')

% Determine R2 change per each node between models
for jj=1:200
    rearranged_rchange_dist0(jj) = rearranged_rsq0(jj) - rearranged_rsq_dist(jj); %add ms
    rearranged_rchange_01(jj) = rearranged_rsq1(jj) - rearranged_rsq0(jj); %add mssd
    rearranged_rchange_12(jj) = rearranged_rsq2(jj) - rearranged_rsq1(jj); %add wb
end

% Rchange not rearranged to create nii files to feed into BrainNet
for jj=1:200
    rchange_dist0(jj) = rsq0(jj) - rsq_dist(jj); %add ms
    rchange_01(jj) = rsq1(jj) - rsq0(jj); %add mssd
end

save('Rearranged_rchange_dist+ms.mat', 'rearranged_rchange_dist0')
save('Rearranged_rchange_nointerest+mssd.mat', 'rearranged_rchange_01');