%% Variability computations by Giulia Baracchini
% using mean centering approach prior to variability calculations
% PS check if your data is already centered (eg to 0) if so add a constant
% before mean centering

%transformed_final is [1xn] with n= # of subjects
%transformed_final{1,1} is a ROI x timepoint matrix for subject 1
%transformed_final{1,1}(1,:) is the time series of the first region for subject 1
%yound_ids = 154
%200 ROIs and 200 timepoints per ROI


%%%% SD
for i = 1:length(young_ids)
    
    SD = zeros(200,1);
    
    meanhund{i,1} = 100 * transformed_final{i,1} / mean(mean(transformed_final{i,1}));
    %mean center to have mean set to 100 across the whole matrix (region x timepoints)
    
    for jj = 1:200
        
        ts = meanhund{i,1}(jj,:); %regional timeseries
        
        sd = [];
        for j = 1:length(ts)  %%calculate SD for each ROI time series
            sd(j) = (ts(j)-mean(ts))^2; %SD
        end
        
        SD(jj) = sqrt(nanmean(sd));
    end

    filename=strcat(outdir, '/', young_ids(i),'_','run-01','_MeancenteredSD_groupatlas.mat');
    save(filename, 'SD')
    
end 

%%%% MSSD
for i = 1:length(young_ids)
    
    sdVol = zeros(200,1);
    
    meanhund{i,1} = 100 * transformed_final{i,1} / mean(mean(transformed_final{i,1}));
    
    for jj = 1:200
        
        ts = meanhund{i,1}(jj,:);
        
        mssd = [];
        for j = 1:length(ts)-1  %%calculate MSSD for each regional time series
            mssd(j) = (ts(j+1)-ts(j))^2; %MSSD
        end
        
        sdVol(jj) = sqrt(nanmean(mssd));
        
    end

    filename=strcat(outdir, '/', young_ids(i),'_','run-01','_MeanCenteredmssd_groupatlas.mat');
    save(filename, 'sdVol')
    
end  



