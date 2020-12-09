%% Tentative Diffusion Map Embedding/Gradients analyses

clear all
addpath(genpath('./BrainSpace-0.1.1'));
addpath(genpath('./../gifti-master'));

% First load mean connectivity matrix and Schaefer parcellation
conn_matrix = load('Correlation_matrix_run1_young_fc_zmssd_finalsample_reversed.mat');
labeling = load_parcellation('schaefer',200);

% The loader functions output data in a struct array for when you
% load multiple parcellations. Let's just bring them to numeric arrays.
conn_matrix = conn_matrix.correlation_matrix_fc_zmssd_run1_young_reversed;
conn_matrix(find(eye(size(conn_matrix)))) = 1;

labeling = labeling.schaefer_200;

% and load the conte69 hemisphere surfaces
[surf_lh, surf_rh] = load_conte69();

% Construct the gradients
gm = GradientMaps();
gm = gm.fit(conn_matrix);

%Gradients are flipped so multiply them by -1 (signs are arbitrary so you
%can do that)
gradients = gm.gradients{1} * -1;

plot_hemispheres(gradients(:,1:2),{surf_lh,surf_rh}, ...
             'parcellation', labeling, ...
             'labeltext',{'Gradient 1','Gradient 2'});
         
scree_plot(gm.lambda{1}); %first gradient

% getting percent variance explained first 2 gradients
%first gradients
variance_gr1 = (gm.lambda{1,1}(1)/sum(gm.lambda{1,1}))*100; % 14%
variance_gr2 = (gm.lambda{1,1}(2)/sum(gm.lambda{1,1}))*100; % 11%

gradient_in_euclidean(gradients(:,1:2));

gradient_in_euclidean(gradients(:,1:2),{surf_lh,surf_rh},labeling);

gradient1 = gradients(:,1);
gradient2 = gradients(:,2);

save('Gradient1_young_fcmssd.mat','gradient1');
save('Gradient2_young_fcmssd.mat','gradient2');

%Rearrange gradients
clear all
load('Gradient1_young_fcmssd.mat')
load('Gradient2_young_fcmssd.mat')

load('/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels/Schaefer_200Parcels_7Network_atlas.mat');

rearranged_gradient1 = gradient1(index,1);
rearranged_gradient2 = gradient2(index,1);

save('Rearr_Gradient1_young_fcmssd.mat','rearranged_gradient1');
save('Rearr_Gradient2_young_fcmssd.mat','rearranged_gradient2');


