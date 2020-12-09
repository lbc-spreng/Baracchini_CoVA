%% Dot product calculations within subject all networks
%% Between networks
clear all

load('Young_groupmatrix_fc_run01_finalsample.mat');
load('Young_groupmatrix_zmssd_run01_finalsample_reversed.mat');

% Rearrange first
load('/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels/Schaefer_200Parcels_7Network_atlas.mat');

for i=1:154
    rearranged_young_fc(:,:,i) = final_young_run01_fc(index,index,i);
    rearranged_young_mssd(:,:,i) = final_young_run01_mssd(index,index,i);
%     rearranged_young_mssd(:,:,i) = (rearranged_young_mssd(:,:,i) * -1) +1;
end

% Separate networks: Between 
% Visual
for i=1:154
    vis_som_fc(:,:,i) = rearranged_young_fc(30:64,1:29,i);
    vis_som_mssd(:,:,i) = rearranged_young_mssd(30:64,1:29,i);
end

for i=1:154
    vis_dan_fc(:,:,i) = rearranged_young_fc(65:90,1:29,i);
    vis_dan_mssd(:,:,i) = rearranged_young_mssd(65:90,1:29,i);
end

for i=1:154
    vis_van_fc(:,:,i) = rearranged_young_fc(91:112,1:29,i);
    vis_van_mssd(:,:,i) = rearranged_young_mssd(91:112,1:29,i);
end

for i=1:154
    vis_lim_fc(:,:,i) = rearranged_young_fc(113:124,1:29,i);
    vis_lim_mssd(:,:,i) = rearranged_young_mssd(113:124,1:29,i);
end

for i=1:154
    vis_cont_fc(:,:,i) = rearranged_young_fc(125:154,1:29,i);
    vis_cont_mssd(:,:,i) = rearranged_young_mssd(125:154,1:29,i);
end

for i=1:154
    vis_dmn_fc(:,:,i) = rearranged_young_fc(155:200,1:29,i);
    vis_dmn_mssd(:,:,i) = rearranged_young_mssd(155:200,1:29,i);
end

% Somatomotor
for i=1:154
    som_dan_fc(:,:,i) = rearranged_young_fc(65:90,30:64,i);
    som_dan_mssd(:,:,i) = rearranged_young_mssd(65:90,30:64,i);
end

for i=1:154
    som_van_fc(:,:,i) = rearranged_young_fc(91:112,30:64,i);
    som_van_mssd(:,:,i) = rearranged_young_mssd(91:112,30:64,i);
end

for i=1:154
    som_lim_fc(:,:,i) = rearranged_young_fc(113:124,30:64,i);
    som_lim_mssd(:,:,i) = rearranged_young_mssd(113:124,30:64,i);
end

for i=1:154
    som_cont_fc(:,:,i) = rearranged_young_fc(125:154,30:64,i);
    som_cont_mssd(:,:,i) = rearranged_young_mssd(125:154,30:64,i);
end

for i=1:154
    som_dmn_fc(:,:,i) = rearranged_young_fc(155:200,30:64,i);
    som_dmn_mssd(:,:,i) = rearranged_young_mssd(155:200,30:64,i);
end

%Dan
for i=1:154
    dan_van_fc(:,:,i) = rearranged_young_fc(91:112,65:90,i);
    dan_van_mssd(:,:,i) = rearranged_young_mssd(91:112,65:90,i);
end

for i=1:154
    dan_lim_fc(:,:,i) = rearranged_young_fc(113:124,65:90,i);
    dan_lim_mssd(:,:,i) = rearranged_young_mssd(113:124,65:90,i);
end

for i=1:154
    dan_cont_fc(:,:,i) = rearranged_young_fc(125:154,65:90,i);
    dan_cont_mssd(:,:,i) = rearranged_young_mssd(125:154,65:90,i);
end

for i=1:154
    dan_dmn_fc(:,:,i) = rearranged_young_fc(155:200,65:90,i);
    dan_dmn_mssd(:,:,i) = rearranged_young_mssd(155:200,65:90,i);
end

%Van
for i=1:154
    van_lim_fc(:,:,i) = rearranged_young_fc(113:124,91:112,i);
    van_lim_mssd(:,:,i) = rearranged_young_mssd(113:124,91:112,i);
end

for i=1:154
    van_cont_fc(:,:,i) = rearranged_young_fc(125:154,91:112,i);
    van_cont_mssd(:,:,i) = rearranged_young_mssd(125:154,91:112,i);
end

for i=1:154
    van_dmn_fc(:,:,i) = rearranged_young_fc(155:200,91:112,i);
    van_dmn_mssd(:,:,i) = rearranged_young_mssd(155:200,91:112,i);
end

%Limbic
for i=1:154
    lim_cont_fc(:,:,i) = rearranged_young_fc(125:154,113:124,i);
    lim_cont_mssd(:,:,i) = rearranged_young_mssd(125:154,113:124,i);
end

for i=1:154
    lim_dmn_fc(:,:,i) = rearranged_young_fc(155:200,113:124,i);
    lim_dmn_mssd(:,:,i) = rearranged_young_mssd(155:200,113:124,i);
end

%Control
for i=1:154
    cont_dmn_fc(:,:,i) = rearranged_young_fc(155:200,125:154,i);
    cont_dmn_mssd(:,:,i) = rearranged_young_mssd(155:200,125:154,i);
end

% Since all of them are already part of the lower triangle now you 
% just need to vectorize them
%Visual
vis_som_size = size(vis_som_fc,1)*size(vis_som_fc,2);
test_vis_som_fc = reshape(vis_som_fc, vis_som_size, size(vis_som_fc,3));
vis_som_fc = test_vis_som_fc';
test_vis_som_mssd = reshape(vis_som_mssd, vis_som_size, size(vis_som_mssd,3));
vis_som_mssd = test_vis_som_mssd';

vis_dan_size = size(vis_dan_fc,1)*size(vis_dan_fc,2);
test_vis_dan_fc = reshape(vis_dan_fc, vis_dan_size, size(vis_dan_fc,3));
vis_dan_fc = test_vis_dan_fc';
test_vis_dan_mssd = reshape(vis_dan_mssd, vis_dan_size, size(vis_dan_mssd,3));
vis_dan_mssd = test_vis_dan_mssd';

vis_van_size = size(vis_van_fc,1)*size(vis_van_fc,2);
test_vis_van_fc = reshape(vis_van_fc, vis_van_size, size(vis_van_fc,3));
vis_van_fc = test_vis_van_fc';
test_vis_van_mssd = reshape(vis_van_mssd, vis_van_size, size(vis_van_mssd,3));
vis_van_mssd = test_vis_van_mssd';

vis_lim_size = size(vis_lim_fc,1)*size(vis_lim_fc,2);
test_vis_lim_fc = reshape(vis_lim_fc, vis_lim_size, size(vis_lim_fc,3));
vis_lim_fc = test_vis_lim_fc';
test_vis_lim_mssd = reshape(vis_lim_mssd, vis_lim_size, size(vis_lim_mssd,3));
vis_lim_mssd = test_vis_lim_mssd';

vis_cont_size = size(vis_cont_fc,1)*size(vis_cont_fc,2);
test_vis_cont_fc = reshape(vis_cont_fc, vis_cont_size, size(vis_cont_fc,3));
vis_cont_fc = test_vis_cont_fc';
test_vis_cont_mssd = reshape(vis_cont_mssd, vis_cont_size, size(vis_cont_mssd,3));
vis_cont_mssd = test_vis_cont_mssd';

vis_dmn_size = size(vis_dmn_fc,1)*size(vis_dmn_fc,2);
test_vis_dmn_fc = reshape(vis_dmn_fc, vis_dmn_size, size(vis_dmn_fc,3));
vis_dmn_fc = test_vis_dmn_fc';
test_vis_dmn_mssd = reshape(vis_dmn_mssd, vis_dmn_size, size(vis_dmn_mssd,3));
vis_dmn_mssd = test_vis_dmn_mssd';

%Somatomotor
som_dan_size = size(som_dan_fc,1)*size(som_dan_fc,2);
test_som_dan_fc = reshape(som_dan_fc, som_dan_size, size(som_dan_fc,3));
som_dan_fc = test_som_dan_fc';
test_som_dan_mssd = reshape(som_dan_mssd, som_dan_size, size(som_dan_mssd,3));
som_dan_mssd = test_som_dan_mssd';

som_van_size = size(som_van_fc,1)*size(som_van_fc,2);
test_som_van_fc = reshape(som_van_fc, som_van_size, size(som_van_fc,3));
som_van_fc = test_som_van_fc';
test_som_van_mssd = reshape(som_van_mssd, som_van_size, size(som_van_mssd,3));
som_van_mssd = test_som_van_mssd';

som_lim_size = size(som_lim_fc,1)*size(som_lim_fc,2);
test_som_lim_fc = reshape(som_lim_fc, som_lim_size, size(som_lim_fc,3));
som_lim_fc = test_som_lim_fc';
test_som_lim_mssd = reshape(som_lim_mssd, som_lim_size, size(som_lim_mssd,3));
som_lim_mssd = test_som_lim_mssd';

som_cont_size = size(som_cont_fc,1)*size(som_cont_fc,2);
test_som_cont_fc = reshape(som_cont_fc, som_cont_size, size(som_cont_fc,3));
som_cont_fc = test_som_cont_fc';
test_som_cont_mssd = reshape(som_cont_mssd, som_cont_size, size(som_cont_mssd,3));
som_cont_mssd = test_som_cont_mssd';

som_dmn_size = size(som_dmn_fc,1)*size(som_dmn_fc,2);
test_som_dmn_fc = reshape(som_dmn_fc, som_dmn_size, size(som_dmn_fc,3));
som_dmn_fc = test_som_dmn_fc';
test_som_dmn_mssd = reshape(som_dmn_mssd, som_dmn_size, size(som_dmn_mssd,3));
som_dmn_mssd = test_som_dmn_mssd';

%Dan
dan_van_size = size(dan_van_fc,1)*size(dan_van_fc,2);
test_dan_van_fc = reshape(dan_van_fc, dan_van_size, size(dan_van_fc,3));
dan_van_fc = test_dan_van_fc';
test_dan_van_mssd = reshape(dan_van_mssd, dan_van_size, size(dan_van_mssd,3));
dan_van_mssd = test_dan_van_mssd';

dan_lim_size = size(dan_lim_fc,1)*size(dan_lim_fc,2);
test_dan_lim_fc = reshape(dan_lim_fc, dan_lim_size, size(dan_lim_fc,3));
dan_lim_fc = test_dan_lim_fc';
test_dan_lim_mssd = reshape(dan_lim_mssd, dan_lim_size, size(dan_lim_mssd,3));
dan_lim_mssd = test_dan_lim_mssd';

dan_cont_size = size(dan_cont_fc,1)*size(dan_cont_fc,2);
test_dan_cont_fc = reshape(dan_cont_fc, dan_cont_size, size(dan_cont_fc,3));
dan_cont_fc = test_dan_cont_fc';
test_dan_cont_mssd = reshape(dan_cont_mssd, dan_cont_size, size(dan_cont_mssd,3));
dan_cont_mssd = test_dan_cont_mssd';

dan_dmn_size = size(dan_dmn_fc,1)*size(dan_dmn_fc,2);
test_dan_dmn_fc = reshape(dan_dmn_fc, dan_dmn_size, size(dan_dmn_fc,3));
dan_dmn_fc = test_dan_dmn_fc';
test_dan_dmn_mssd = reshape(dan_dmn_mssd, dan_dmn_size, size(dan_dmn_mssd,3));
dan_dmn_mssd = test_dan_dmn_mssd';

%Van
van_lim_size = size(van_lim_fc,1)*size(van_lim_fc,2);
test_van_lim_fc = reshape(van_lim_fc, van_lim_size, size(van_lim_fc,3));
van_lim_fc = test_van_lim_fc';
test_van_lim_mssd = reshape(van_lim_mssd, van_lim_size, size(van_lim_mssd,3));
van_lim_mssd = test_van_lim_mssd';

van_cont_size = size(van_cont_fc,1)*size(van_cont_fc,2);
test_van_cont_fc = reshape(van_cont_fc, van_cont_size, size(van_cont_fc,3));
van_cont_fc = test_van_cont_fc';
test_van_cont_mssd = reshape(van_cont_mssd, van_cont_size, size(van_cont_mssd,3));
van_cont_mssd = test_van_cont_mssd';

van_dmn_size = size(van_dmn_fc,1)*size(van_dmn_fc,2);
test_van_dmn_fc = reshape(van_dmn_fc, van_dmn_size, size(van_dmn_fc,3));
van_dmn_fc = test_van_dmn_fc';
test_van_dmn_mssd = reshape(van_dmn_mssd, van_dmn_size, size(van_dmn_mssd,3));
van_dmn_mssd = test_van_dmn_mssd';

%Limbic
lim_cont_size = size(lim_cont_fc,1)*size(lim_cont_fc,2);
test_lim_cont_fc = reshape(lim_cont_fc, lim_cont_size, size(lim_cont_fc,3));
lim_cont_fc = test_lim_cont_fc';
test_lim_cont_mssd = reshape(lim_cont_mssd, lim_cont_size, size(lim_cont_mssd,3));
lim_cont_mssd = test_lim_cont_mssd';

lim_dmn_size = size(lim_dmn_fc,1)*size(lim_dmn_fc,2);
test_lim_dmn_fc = reshape(lim_dmn_fc, lim_dmn_size, size(lim_dmn_fc,3));
lim_dmn_fc = test_lim_dmn_fc';
test_lim_dmn_mssd = reshape(lim_dmn_mssd, lim_dmn_size, size(lim_dmn_mssd,3));
lim_dmn_mssd = test_lim_dmn_mssd';

%Control
cont_dmn_size = size(cont_dmn_fc,1)*size(cont_dmn_fc,2);
test_cont_dmn_fc = reshape(cont_dmn_fc, cont_dmn_size, size(cont_dmn_fc,3));
cont_dmn_fc = test_cont_dmn_fc';
test_cont_dmn_mssd = reshape(cont_dmn_mssd, cont_dmn_size, size(cont_dmn_mssd,3));
cont_dmn_mssd = test_cont_dmn_mssd';

%Now put them all together
fc_between = horzcat(vis_som_fc, vis_dan_fc, vis_van_fc, vis_lim_fc, vis_cont_fc, vis_dmn_fc, som_dan_fc, som_van_fc, som_lim_fc, som_cont_fc, som_dmn_fc,dan_van_fc, dan_lim_fc, dan_cont_fc, dan_dmn_fc, van_lim_fc, van_cont_fc, van_dmn_fc, lim_cont_fc, lim_dmn_fc, cont_dmn_fc);
mssd_between = horzcat(vis_som_mssd, vis_dan_mssd, vis_van_mssd, vis_lim_mssd, vis_cont_mssd, vis_dmn_mssd, som_dan_mssd, som_van_mssd, som_lim_mssd, som_cont_mssd, som_dmn_mssd, dan_van_mssd, dan_lim_mssd, dan_cont_mssd, dan_dmn_mssd, van_lim_mssd, van_cont_mssd, van_dmn_mssd, lim_cont_mssd, lim_dmn_mssd, cont_dmn_mssd);

% Now zscore them both
for i=1:154
    fc_between(i,:) = zscore(fc_between(i,:));
    mssd_between(i,:) = zscore(mssd_between(i,:));
end

% Now you can calculate dot product

for subj=1:154
    for i=1:length(fc_between)
        dotproduct_between(subj,i) = (fc_between(subj,i) * mssd_between(subj,i))/length(fc_between);
    end
    ccorr_between(subj) = sum(dotproduct_between(subj,:));
end

save('ccorr_between.mat', 'ccorr_between');
