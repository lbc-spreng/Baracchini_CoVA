clear all

load('lowertriangle_fc_fn_1.mat');
load('lowertriangle_zmssd_fn_1.mat');

lowertriangle_fc_young_run01 = vertcat(lowertriangle_fc_fn_1{:});
lowertriangle_mssd_young_run01 = vertcat(lowertriangle_mssd_fn_1{:});

lowertriangle_mssd_young_run01 = (lowertriangle_mssd_young_run01 * -1) +1; 
%reverse MSSD for interpretability and make everything positive

[perm_id txt raw] = xlsread('200Parcels7Networks_spins.xlsx');

% Since the spins were generated in Python you need to add +1 to your
% indices
perm_id = perm_id + 1;

% These inputs are already zscored both FC and MSSD
unpermuted_fc = lowertriangle_fc_young_run01;
unpermuted_mssd = lowertriangle_mssd_young_run01;

% Calculate real Pearson correlation btw unpermuted FC and unpermuted MSSD
for i= 1:19900
    realrho(:,i) = corr(unpermuted_fc(:,i), unpermuted_mssd(:,i));
end

% Permutations
original_fc_matrix = load('Young_groupmatrix_fc_run01_finalsample.mat'); 
original_fc_matrix1 = struct2cell(original_fc_matrix);
original_fc_matrix = original_fc_matrix1{1,1};

original_mssd_matrix = load('Young_groupmatrix_zmssd_run01_finalsample_reversed.mat');
original_mssd_matrix1 = struct2cell(original_mssd_matrix);
original_mssd_matrix = original_mssd_matrix1{1,1};

nperm = 200;

addpath '/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels'

for j=1:nperm
    
    roiIndx(:,j) = perm_id(:,j);
    lowTriagDataIndx(:,j) = LowerTriangleIndex(length(roiIndx(:,j)));
    roiNames(:,j) = ([roiIndx(:,j)]);
    
    permuted_fc{j} = original_fc_matrix(roiIndx(:,j), roiIndx(:,j), :); %permute matrix based on spin labels
    permuted_mssd{j} = original_mssd_matrix(roiIndx(:,j), roiIndx(:,j), :);
    
    for i = 1:154 %calculate lower triangle
        g1_temp1{j} = permuted_fc{j}(:,:,i);
        permuted_lowertriangle_fc_young_run01{j}(i,:)= g1_temp1{j}(lowTriagDataIndx(:,j))';
        
        g2_temp2{j} = permuted_mssd{j}(:,:,i);
        permuted_lowertriangle_mssd_young_run01{j}(i,:)= g2_temp2{j}(lowTriagDataIndx(:,j))';
    end
    
end

% correlation to unpermuted measures

rho_null_fcmssd = zeros(nperm,19900);
rho_null_mssdfc = zeros(nperm,19900);
for r = 1:nperm
    for n=1:19900 %has to be modified cause now only 1 value gets saved
        rho_null_fcmssd(r,n) = corr(permuted_lowertriangle_fc_young_run01{1,r}(:,n), unpermuted_mssd(:,n)); % correlate permuted x to unpermuted y
        rho_null_mssdfc(r,n) = corr(unpermuted_fc(:,n), permuted_lowertriangle_mssd_young_run01{1,r}(:,n)); % correlate permuted y to unpermuted x
    end
end

%AA IMPO: some of the permuted lower triangle values are NaNs cause if you
%look at the permutation xlsx sheet you can see that eg in one column not
%all 1-200 numbers are present. Eg it could be that 100 gets repeated 3
%times meaning that 2 numbers wont get reassigned in that column given that
%each column still keeps a length of 200 cells. That means that some rows
%wont get expressed thus no values and no rhos for them

% p-value definition depends on the sign of the empirical correlation (aka
% the realrho)
% Here I am calculating a two tailed null distribution 
% so basically I am saying: how many null r values my original r values 
% are greater than and I am dividing by the number of permutations (200). 
% Basically I am calculating for every r its percentile in the distribution
%(looking at the upper tail if the original r is positive, lower tail if the original r is negative)
% And by having a permuted FC and a permuted MSSD I basically have 400
% permutations
for g=1:19900
    if realrho(g) > 0
        p_perm_fcmssd(g) = sum(rho_null_fcmssd(:,g) > realrho(g))/nperm;
        p_perm_mssdfc(g) = sum(rho_null_mssdfc(:,g) > realrho(g))/nperm;
    else
        p_perm_fcmssd(g) = sum(rho_null_fcmssd(:,g) < realrho(g))/nperm;
        p_perm_mssdfc(g) = sum(rho_null_mssdfc(:,g) < realrho(g))/nperm;
    end
    
    % average p-values
    p_perm(g) = (p_perm_fcmssd(g) + p_perm_mssdfc(g))/2;
end

%now rebuild matrix of pvalues run01
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
    empty_matrix(g:200,i) = p_perm(z:j);
    g = g+1;
    z = j+1;
    m = length(empty_matrix(g:200,i));
end

% Mirror lower triang to upper triang to get full matrix: Inverted bootstrap ratio
pvalue_matrix_fc_zmssd_run1_young = tril(empty_matrix) + tril(empty_matrix,-1)';
save('Pvalue_matrix_run1_young_fcZmssd_correlation_finalsample_reversed.mat', 'pvalue_matrix_fc_zmssd_run1_young')

%Visualization
addpath '/lbc/lbc1/derivatives/GB/Colorpalette_Brewermap';
load('/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels/Schaefer_200Parcels_7Network_atlas.mat');

rearranged_corr = pvalue_matrix_fc_zmssd_run1_young(index,index);

imagesc(rearranged_corr);
caxis([0.01 0.06]);
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
colormap(flipud(brewermap([],'Blues')));
%colormap(flipud(brewermap([],'RdBu')));

save('Rearranged_pvalue_matrix_fc_mssd_run1_young_reversed.mat', 'rearranged_corr')
