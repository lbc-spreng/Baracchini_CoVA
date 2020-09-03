%% SD calculations to see whether MSSD and SD are correlated 

% Initial steps // MSSD

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

%We need to make all values positive now before calculating PCS
%So find the min value across all people
for i=1:154
    minimum(i) = min(final{i,1}, [], 'all');
end

smallest = min(minimum); %-375

%Ok so now we add whatever to make everything positive, lets add +500
for i=1:154
    transformed_final{i,1} = final{i,1}+500;
end

%Now we can calculate PCS and SD

outdir='/lbc/lbc1/derivatives/GB/Finalsample_youngCornell_FC-MSSD_Groupatlas/conn_rest_Finalsample_200parcels_run01_hikts_young_RAW';

for i = 1:length(young_ids)
    
    SD = zeros(200,1);
    
    for jj = 1:200
        
        ts = transformed_final{i,1}(jj,:);
        
        pcs(jj) = (ts(1,jj)/mean(ts))*100;
        
        sd = [];
        for j = 1:length(pcs)  
            sd(j) = (pcs(j)-mean(pcs))^2; 
        end
        
        SD(jj) = sqrt(nanmean(sd));
        
    end

    filename=strcat(outdir, '/', young_ids(i),'_','run-01','_PercentSD_fromRAW_groupatlas.mat');
    save(filename, 'SD')
    
end    

%% ok now check whether SD and zMSSD are correlated to each other
clear all
[num txt raw] = xlsread('FinalSample_Cornell.xlsx');
agegroup = txt(:,2);
agegroup = string(agegroup);

%%% Young
[ii,bb] = find(strcmp(agegroup, 'Young'));
young_ids = txt(ii,1);
young_ids = string(young_ids);
 
zmssd_dir = dir('*zmssd_groupatlas.mat');
zmmsd_filenames = cell(length(young_ids),1);

for i = 1:length(young_ids)
    zmssd_filenames{i} = zmssd_dir(i).name;
    zmssd_tmp{i} = load(zmssd_dir(i).name);
end

sd_dir = dir('*PercentSD_fromRAW_groupatlas.mat');
sd_filenames = cell(length(young_ids),1);

for i = 1:length(young_ids)
    sd_filenames{i} = sd_dir(i).name;
    sd_tmp{i} = load(sd_dir(i).name);
end

for i=1:154
    A{1,i} = zmssd_tmp{1,i}.sdVol;
    B{1,i} = sd_tmp{1,i}.SD;
    
    R{1,i} = corrcoef(A{1,i},B{1,i});
    R{1,i} = R{1,i}(2);
  
end 

R = cell2mat(R);
%now z-transform these values via Fisher's r-z
%so that values look more normal and are not restricted btw [-1; 1]
z_transf = atanh(R);

[h,p,ci,stats] = ttest(z_transf); %cannot reject H0, p=0.5344 



