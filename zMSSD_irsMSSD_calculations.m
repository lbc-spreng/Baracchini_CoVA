%% Extracting timeseries per parcel Schaefer atlas

clear all
[num txt raw] = xlsread('FinalSample_Cornell.xlsx');
agegroup = txt(:,2);
agegroup = string(agegroup);

%%% Young
[ii,bb] = find(strcmp(agegroup, 'Young'));
young_ids = txt(ii,1);
young_ids = string(young_ids);

matfiles = dir('*Condition000.mat');
filenames = cell(length(young_ids),1);

for i = 1:length(young_ids)
    filenames{i} = matfiles(i).name;
    tmp{i} = load(matfiles(i).name);
    roi_data{i} = tmp{1,i}.data'; %transpose to have parcels as rows
end

for j = 1:length(young_ids)
    
    for z = 1:200
        final{1,j}{z,1} = roi_data{1,j}{z,1}';      
    end
    
    final{1,j} = vertcat(final{1,j}{:}) %nice! parcel x timeseries for each subject
end

final = final';

% Now that you have that calculate MSSD
outdir='/lbc/lbc1/derivatives/GB/conn_rest_Finalsample_200parcels_run02_hikts_young_RAW';

for i = 1:length(young_ids)
    
    sdVol = zeros(200,1);
    
    for jj = 1:200
        
        ts = final{i,1}(jj,:);
        
        ts = zscore(ts); %%transform to unit variance
        
        mssd = [];
        for j = 1:length(ts)-1  %%calculate MSSD for each voxel time series
            mssd(j) = (ts(j+1)-ts(j))^2; 
        end
        
        sdVol(jj) = sqrt(nanmean(mssd));
        
    end

    filename=strcat(outdir, '/', young_ids(i),'_','run-02','_zmssd_groupatlas.mat');
    save(filename, 'sdVol')
    
end    

%% Script to create irsMSSD
clear all
[num txt raw] = xlsread('FinalSample_Cornell.xlsx');
agegroup = txt(:,2);
agegroup = string(agegroup);

%%% Young
[ii,bb] = find(strcmp(agegroup, 'Young'));
young_ids = txt(ii,1);
young_ids = string(young_ids);

outdir='/lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/conn_rest_Finalsample_200parcels_run02_hikts_young_RAW';
mat = dir('*groupatlas.mat');

for j = 1:length(mat)
    
    load(mat(j).name)
    
    transpose = sdVol';
    
    square_mssd = abs(sdVol-transpose); %irsMSSD
    
    for i = 1:200
        square_mssd(i,i) = NaN; %remove diagonal values
    end
    
    filename=strcat(outdir, '/', young_ids(j),'_','run-02','_zmssd_groupatlas_squarematrix_difference.mat');
    save(filename, 'square_mssd')

end




