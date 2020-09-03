%% Young correlation analyses: FC and MSSD zscored
clear all

[num txt raw] = xlsread('FinalSample_Cornell.xlsx');
agegroup = txt(:,2);
agegroup = string(agegroup);

%%% Young
[ii,bb] = find(strcmp(agegroup, 'Young'));
young_ids = txt(ii,1);
young_ids = string(young_ids);

%FC
run1_mefc = load('/lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/conn_rest_Finalsample_200parcels_run01_mefc_young/Matrices_with_IDs/transformed_matrices_run1.mat');
run1_mefc = run1_mefc.transformed_matrices_run1;

%MSSD 
run1_mssd_dir = '/lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/conn_rest_Finalsample_200parcels_run01_hikts_young_RAW'


for i = 1:length(young_ids)
    mssd_fn_1{i} = fullfile(run1_mssd_dir, sprintf('%s_run-01_zmssd_groupatlas_squarematrix_difference.mat', young_ids{i}));
    mssd_fn_1{i} = load(mssd_fn_1{i});
end


%% Now correlate FC-MSSD 
% First get lower triangles

addpath '/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels'

roiIndx = [1:200];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:length(young_ids)
    temp1 = run1_mefc{1,i};
    lowertriangle_fc_fn_1{i}= temp1(lowTriagDataIndx)';
        
    temp3 = mssd_fn_1{1,i}.square_mssd;
    lowertriangle_mssd_fn_1{i}= temp3(lowTriagDataIndx)';
     
end

save('lowertriangle_fc_fn_1.mat', 'lowertriangle_fc_fn_1')
save('lowertriangle_zmssd_fn_1.mat', 'lowertriangle_mssd_fn_1')

% Now run correlations across ppl
clear all
load('lowertriangle_fc_fn_1.mat')
load('lowertriangle_zmssd_fn_1.mat')

fc_fn_1 = cell2mat(lowertriangle_fc_fn_1);
fc_fn_1 = reshape(fc_fn_1, 19900, 154)';

mssd_fn_1 = cell2mat(lowertriangle_mssd_fn_2);
mssd_fn_1 = reshape(mssd_fn_1, 19900, 154)';

mssd_fn_1 = (mssd_fn_1 * -1) +1; %reverse irsMSSD for interpretability and make 
%everything positive

for i= 1:19900
    correlations_run01(i) = corr(fc_fn_1(:,i), mssd_fn_1(:,i));
end

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
    empty_matrix(g:200,i) = correlations_run01(z:j);
    g = g+1;
    z = j+1;
    m = length(empty_matrix(g:200,i));
end

% Mirror lower triang to upper triang to get full matrix: Inverted bootstrap ratio
correlation_matrix_fc_zmssd_run1_young_reversed = tril(empty_matrix) + tril(empty_matrix,-1)';
save('Correlation_matrix_run1_young_fc_zmssd_finalsample_reversed.mat', 'correlation_matrix_fc_zmssd_run1_young_reversed')

%% Visualization
clear all

addpath '/lbc/lbc1/derivatives/GB/Colorpalette_Brewermap';
load('/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels/Schaefer_200Parcels_7Network_atlas.mat');
load('Correlation_matrix_run1_young_fc_zmssd_finalsample_reversed.mat');
rearranged_corr = correlation_matrix_fc_zmssd_run1_young_reversed(index,index);

imagesc(rearranged_corr);
caxis([-0.3 0.3]);
%adding lines btw networks to better visualize them
xL = get(gca, 'XLim');
yL = get(gca, 'YLim');
line([29.5 29.5],yL, 'LineWidth', 2, 'Color', 'k');
line(xL,[29.5 29.5], 'LineWidth', 2, 'Color', 'k');
line([64.5 64.5],yL, 'LineWidth', 2, 'Color', 'k');
line(xL,[64.5 64.5], 'LineWidth', 2, 'Color', 'k');
line([90.5 90.5],yL, 'LineWidth', 2, 'Color', 'k');
line(xL,[90.5 90.5], 'LineWidth', 2, 'Color', 'k');
line([112.5 112.5],yL, 'LineWidth', 2, 'Color', 'k');
line(xL,[112.5 112.5], 'LineWidth', 2, 'Color', 'k');
line([124.5 124.5],yL, 'LineWidth', 2, 'Color', 'k');
line(xL,[124.5 124.5], 'LineWidth', 2, 'Color', 'k');
line([154.5 154.5],yL, 'LineWidth', 2, 'Color', 'k');
line(xL,[154.5 154.5], 'LineWidth', 2, 'Color', 'k');
set(gca,'Layer','top','YTick',...
    [1 30 65 91 113 125 155],'XTick',...
    [1 30 65 91 113 125 155],'YTickLabel',...
    {'VIS','SOM','DAN','VAN','LIM','FPN','DN'},'XTickLabel',...
    {'VIS','SOM','DAN','VAN','LIM','FPN','DN'});
xtickangle(45);
colormap(flipud(brewermap([],'RdBu')));

% Save FC and MSSD young group matrices
for z = 1:length(young_ids)
    temp1{z} = (mssd_fn_1{1,z}.square_mssd*-1) +1;
end

final_young_run01_mssd = cat(3, temp1{:});

final_young_run01_fc = cat(3, run1_mefc{:});

save('Young_groupmatrix_zmssd_run01_finalsample_reversed.mat', 'final_young_run01_mssd');

save('Young_groupmatrix_fc_run01_finalsample.mat', 'final_young_run01_fc');




