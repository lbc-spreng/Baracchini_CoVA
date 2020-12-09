%% Dot product all networks together within network, within subject
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

% Separate networks

for i=1:154
    visual_fc(:,:,i) = rearranged_young_fc(1:29,1:29,i);
    visual_mssd(:,:,i) = rearranged_young_mssd(1:29,1:29,i);
end

for i=1:154
    somatomotor_fc(:,:,i) = rearranged_young_fc(30:64,30:64,i);
    somatomotor_mssd(:,:,i) = rearranged_young_mssd(30:64,30:64,i);
end

for i=1:154
    dan_fc(:,:,i) = rearranged_young_fc(65:90,65:90,i);
    dan_mssd(:,:,i) = rearranged_young_mssd(65:90,65:90,i);
end

for i=1:154
    van_fc(:,:,i) = rearranged_young_fc(91:112,91:112,i);
    van_mssd(:,:,i) = rearranged_young_mssd(91:112,91:112,i);
end

for i=1:154
    limbic_fc(:,:,i) = rearranged_young_fc(113:124,113:124,i);
    limbic_mssd(:,:,i) = rearranged_young_mssd(113:124,113:124,i);
end

for i=1:154
    control_fc(:,:,i) = rearranged_young_fc(125:154,125:154,i);
    control_mssd(:,:,i) = rearranged_young_mssd(125:154,125:154,i);
end

for i=1:154
    dmn_fc(:,:,i) = rearranged_young_fc(155:200,155:200,i);
    dmn_mssd(:,:,i) = rearranged_young_mssd(155:200,155:200,i);
end

% Vectorize them all
addpath '/lbc/lbc1/derivatives/GB/PLS_rest_behav_OctGB_200parcels'

roiIndx = [1:29];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:154
    g1_temp1 = visual_fc(:,:,i);
    rearr_visual_fc(i,:)= g1_temp1(lowTriagDataIndx)';
    
    g2_temp1 = visual_mssd(:,:,i);
    rearr_visual_mssd(i,:)= g2_temp1(lowTriagDataIndx)';
end

roiIndx = [1:35];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:154
    g3_temp1 = somatomotor_fc(:,:,i);
    rearr_somatomotor_fc(i,:)= g3_temp1(lowTriagDataIndx)';
    
    g4_temp1 = somatomotor_mssd(:,:,i);
    rearr_somatomotor_mssd(i,:)= g4_temp1(lowTriagDataIndx)';
end

roiIndx = [1:26];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:154
    g5_temp1 = dan_fc(:,:,i);
    rearr_dan_fc(i,:)= g5_temp1(lowTriagDataIndx)';
    
    g6_temp1 = dan_mssd(:,:,i);
    rearr_dan_mssd(i,:)= g6_temp1(lowTriagDataIndx)';
end

roiIndx = [1:22];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:154
    g7_temp1 = van_fc(:,:,i);
    rearr_van_fc(i,:)= g7_temp1(lowTriagDataIndx)';
    
    g8_temp1 = van_mssd(:,:,i);
    rearr_van_mssd(i,:)= g8_temp1(lowTriagDataIndx)';
end

roiIndx = [1:12];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:154
    g9_temp1 = limbic_fc(:,:,i);
    rearr_limbic_fc(i,:)= g9_temp1(lowTriagDataIndx)';
    
    g10_temp1 = limbic_mssd(:,:,i);
    rearr_limbic_mssd(i,:)= g10_temp1(lowTriagDataIndx)';
end

roiIndx = [1:30];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:154
    g11_temp1 = control_fc(:,:,i);
    rearr_control_fc(i,:)= g11_temp1(lowTriagDataIndx)';
    
    g12_temp1 = control_mssd(:,:,i);
    rearr_control_mssd(i,:)= g12_temp1(lowTriagDataIndx)';
end

roiIndx = [1:46];

lowTriagDataIndx = LowerTriangleIndex(length(roiIndx));
roiNames = ([roiIndx]);

for i = 1:154
    g13_temp1 = dmn_fc(:,:,i);
    rearr_dmn_fc(i,:)= g13_temp1(lowTriagDataIndx)';
    
    g14_temp1 = dmn_mssd(:,:,i);
    rearr_dmn_mssd(i,:)= g14_temp1(lowTriagDataIndx)';
end

% Ok now stack all networks together for FC and MSSD
fc_within = horzcat(rearr_visual_fc, rearr_somatomotor_fc, rearr_dan_fc, rearr_van_fc, rearr_limbic_fc, rearr_control_fc, rearr_dmn_fc);
mssd_within = horzcat(rearr_visual_mssd, rearr_somatomotor_mssd, rearr_dan_mssd, rearr_van_mssd, rearr_limbic_mssd, rearr_control_mssd, rearr_dmn_mssd);

% Now zscore them both
for i=1:154
    fc_within(i,:) = zscore(fc_within(i,:));
    mssd_within(i,:) = zscore(mssd_within(i,:));
end

% Now you can calculate dot product

for subj=1:154
    for i=1:length(fc_within)
        dotproduct_within(subj,i) = (fc_within(subj,i) * mssd_within(subj,i))/length(fc_within);
    end
    ccorr_within(subj) = sum(dotproduct_within(subj,:));
end

save('ccorr_within.mat', 'ccorr_within');



