%% This script was run on my matlab on my laptop not on server

clear all

xlsx_dir = fullfile('/Users','giulia', 'Desktop','McGill_PhD', 'Cornell', 'Imaging', 'FC_MSSD', 'final_morphometric_groupatlas', 'formatlab');

[num txt raw] = xlsread('Young_final_Cornell.xlsx');
ids = txt(:,1);

for i = 1:length(ids)
    [~, ~, data{i}]=xlsread(fullfile(xlsx_dir,sprintf('%s_lhrh_run01_morphometric_similarity.xlsx',ids{i})));
end

for i = 1:length(data)
    
    lh_surfarea(:,i) = cell2mat(data{1,i}(:,2));
    rh_surfarea(:,i) = cell2mat(data{1,i}(:,8));
    
    lh_vol(:,i) = cell2mat(data{1,i}(:,3));
    rh_vol(:,i) = cell2mat(data{1,i}(:,9));
    
    lh_thick(:,i) = cell2mat(data{1,i}(:,4));
    rh_thick(:,i) = cell2mat(data{1,i}(:,10));
    
    lh_meancurv(:,i) = cell2mat(data{1,i}(:,5));
    rh_meancurv(:,i) = cell2mat(data{1,i}(:,11));
    
    lh_gauscurv(:,i) = cell2mat(data{1,i}(:,6));
    rh_gauscurv(:,i) = cell2mat(data{1,i}(:,12));

end

lhrh_surfarea = vertcat(lh_surfarea, rh_surfarea);
lhrh_vol = vertcat(lh_vol, rh_vol);
lhrh_thick = vertcat(lh_thick, rh_thick);
lhrh_meancurv = vertcat(lh_meancurv, rh_meancurv);
lhrh_gauscurv = vertcat(lh_gauscurv, rh_gauscurv);

%% Now that we have the matrices per measure, let's start building the individual morphometric similarity matrices
% z-score the inputs:
surfarea_zscore=zscore(lhrh_surfarea);
vol_zscore=zscore(lhrh_vol);
thick_zscore=zscore(lhrh_thick);
meancurv_zscore=zscore(lhrh_meancurv);
gauscurv_zscore=zscore(lhrh_gauscurv);

%Create individ dataset with 5 measures x subj
for subj=1:length(ids)
    individ_matrix{1,subj}(:,1)=surfarea_zscore(:,subj);
    individ_matrix{1,subj}(:,2)=vol_zscore(:,subj);
    individ_matrix{1,subj}(:,3)=thick_zscore(:,subj);
    individ_matrix{1,subj}(:,4)=meancurv_zscore(:,subj);
    individ_matrix{1,subj}(:,5)=gauscurv_zscore(:,subj);
end

% Calculate the MS matrices by correlating all inputs and set the diagonal to zero:
for subj=1:length(ids)
    subj_MSN_5{1,subj}=corr(transpose(individ_matrix{1,subj}));
    subj_MSN_5{1,subj}(logical(eye(size(subj_MSN_5{1,subj})))) = NaN;
    subj_MSN_5{2,subj}=ids{subj};
end

headings = {'data', 'names'};
morphometric_similarity = cell2struct(subj_MSN_5, headings,1);

save('Individ_morphometricsimilarity_finalyoung.mat', 'morphometric_similarity');

%This is the order: 'surface_area', 'GM_volume', 'Cortical_thickness', 'Mean_curvature', 'Gaussian_curvature'
