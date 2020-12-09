%% Apply Kundu correction on CONN mefc matrices run01
clear all

[num txt raw] = xlsread('CornellYorkacceptedcomps.xlsx');

%Grab just useful columns aka ID and run-1 and run-2 components only for
%Cornell subjs
comp_run1 = num(1:250,6);
ids = txt(2:251,1);

%Run01
cd '/lbc/lbc1/derivatives/GB/Cornell_mefc_CONN/run1_mefc/conn_rest_MarchGB_200parcels_run01_mefc/Matrices_with_IDs';

%remove ppl not to be included in run1
ids(6,:) = [];
comp_run1(6,:) = [];
ids(114,:) = [];
comp_run1(114,:) = [];
ids(139,:) = [];
comp_run1(139,:) = [];
ids(203,:) = [];
comp_run1(203,:) = [];

for i = 1:length(ids)
    Z_files_dir{i} = dir(sprintf('%s_rest.mat', ids{i}));
    
    Z_files{:,i} = cellfun(@load, {Z_files_dir{1,i}.name});
    Z_matrices_run1{:,i} = Z_files{1,i}.conn_mat;
end

%%Applying Kundu correction: Z=arctanh*sqrt(Nacceptedcomp-3)
%given that CONN matrices are already ztransf (aka z=arctanh(r), you just
%need to do the sqrt part)
for j = 1:length(ids)
    transformed_matrices_run1{:,j} = Z_matrices_run1{:,j}*sqrt(comp_run1(j)-3);
end

save('transformed_matrices_run1.mat', 'transformed_matrices_run1');

%% Apply Kundu correction on CONN mefc matrices run02
clear all

[num txt raw] = xlsread('CornellYorkacceptedcomps.xlsx');

%Grab just useful columns aka ID and run-1 and run-2 components only for
%Cornell subjs
comp_run2 = num(1:250,7);
ids = txt(2:251,1);

%Run01
cd '/lbc/lbc1/derivatives/GB/Cornell_mefc_CONN/run2_mefc/conn_rest_MarchGB_200parcels_run02_mefc/Matrices_with_IDs';

toberemoved = find(isnan(comp_run2));

%remove ppl not to be included in run2
ids(16,:) = [];
comp_run2(16,:) = [];
ids(39,:) = [];
comp_run2(39,:) = [];
ids(57,:) = [];
comp_run2(57,:) = [];
ids(57,:) = [];
comp_run2(57,:) = [];
ids(113,:) = [];
comp_run2(113,:) = [];
ids(175,:) = [];
comp_run2(175,:) = [];


for i = 1:length(ids)
    Z_files_dir{i} = dir(sprintf('%s_rest.mat', ids{i}));
    
    Z_files{:,i} = cellfun(@load, {Z_files_dir{1,i}.name});
    Z_matrices_run2{:,i} = Z_files{1,i}.conn_mat;
end

%%Applying Kundu correction: Z=arctanh*sqrt(Nacceptedcomp-3)
%given that CONN matrices are already ztransf (aka z=arctanh(r), you just
%need to do the sqrt part)
for j = 1:length(ids)
    transformed_matrices_run2{:,j} = Z_matrices_run2{:,j}*sqrt(comp_run2(j)-3);
end

save('transformed_matrices_run2.mat', 'transformed_matrices_run2');
