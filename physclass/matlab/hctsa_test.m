%% First run startup.m to get htcsa ready:
cd C:\Users\inesc_000\Documents\PhD\BHD21\hctsa-master\hctsa-master;
startup

%% Prepare Input data:
% Read physiological data:
T = readtable('C:\Users\inesc_000\Documents\PhD\BHD21\hbm_physio_challenge\time_Series.csv');
T = table2array(T);

tags = readtable('C:\Users\inesc_000\Documents\PhD\BHD21\hbm_physio_challenge\annotations.csv');
tags = table2cell(tags);

% Maybe some data preparation is needed here (like standardizing, detrending, denoising, downsampling)

% Prepare the data as input:
timeSeriesData = T';
labels = {tags{:,1}};
keywords = {tags{:,3}};

% Save these variables out to INP_test.mat:
save('INP_test.mat','timeSeriesData','labels','keywords');

%% Initialize a new hctsa analysis using these data and the default feature library:
%TS_Init('INP_test.mat')%default

% To use a set of 22 features instead:
TS_Init('INP_test.mat','INP_mops_catch22.txt','INP_ops_catch22.txt')

%This creates a HCTSA.mat in the folder. Has 3 tables: MasterOperations
%(code to evaluate); Operations (individual outputs) and TimeSeries.
%Also initializes tables for Calculation times, Data matrix and Operation
%quality

%% since I'm not using TISEAN (sacrificing ~300 implementations of nonlinear time-series analysis methods), 
% it's best to remove those methods from the computed library:
TS_LocalClearRemove('raw','ops',TS_GetIDs('tisean','raw','ops'),true);

%% evaluate the code on all of the time series in your dataset:
TS_Compute(true);%true to do parallel

%if too long, it may be better to use : 
%sample_runscript_matlab
%in order to perform calculations iteratively saving the data

%% To check the quality:
TS_InspectQuality('summary');

%% 
% label your data using the keywords
TS_LabelGroups; %this is by default but you can manually select the labels

%% normalize and filter the data using the default sigmoidal transformation
TS_Normalize('mixedSigmoid',[0.8,1.0]);

%% Clustering rows (data) and columns (features)
% to help visualization, put together similar ones:
distanceMetricRow = 'euclidean'; % time-series feature distance
linkageMethodRow = 'average'; % linkage method
distanceMetricCol = 'corr_fast'; % a (poor) approximation of correlations with NaNs
linkageMethodCol = 'average'; % linkage method

TS_Cluster(distanceMetricRow, linkageMethodRow, distanceMetricCol, linkageMethodCol);

%% Visualizing the data matrix:

TS_PlotDataMatrix('norm')
TS_PlotDataMatrix('norm','colorGroups',true)

%% Low-dimensional representation (PCA)

TS_PlotLowDim('norm','pca');

%% Finding Nearest Neighbours

TS_SimSearch('whatPlots',{'matrix'}, 'numNeighbors', 239);
%TS_SimSearch(1,'whatPlots',{'network'});%gives error
%TS_SimSearch(50,'whatPlots',{'scatter'});%not useful for us

%% Investigate specific operations:
%see the value of a single index in all time series 
for i=1:22
    TS_FeatureSummary(i)
end

%annotateParams = struct('maxL',500);
%TS_FeatureSummary(10,'raw',true,annotateParams); %for violin plot. Gives error.

%% Classifying labeled groups
TS_Classify('norm')

%?
numNulls = 100;
dataFile = 'HCTSA_N.mat';
cfnParams = GiveMeDefaultClassificationParams(dataFile);
TS_Classify(dataFile,cfnParams,numNulls,'doParallel',true)

% to see if classification results depend on simple types of features:
%TS_CompareFeatureSets('norm')%gives error

TS_ClassifyLowDim()%PCS

%% Finding informative features:
TS_TopFeatures()

%% Interpretate a feature:
%to find a feature based on their ID
Operations(Operations.ID==11,:)
MasterOperations(MasterOperations.ID==11,:)
help catch22_MD_hrv_classic_pnn40 %says its a mex file

