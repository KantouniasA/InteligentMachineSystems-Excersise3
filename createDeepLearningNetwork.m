function [networkResult,dirNameResult] = createDeepLearningNetwork(datasetPath)
%% createDeepLearningNetwork
% Creates and trains a convolutional neural network for image recognition.
% The network is saved at the datasetPath folder.
% 
% Inputs:
%     datasetPath        Directory where the processed image data are located       [string]
%
% Output:
%     network           Contains the trained network file and the accuracy result	[structure]
%     datasetPath       Trained network file location                               [string]
%
% Authors: Antonis Kantounias - Eleutherios Kantounias, Email: antonis.kantounias@gmail.com, Date: 2022.12.29

%% Constant data
PERCENTAGEOFTRAINFILES = 0.80;

%% Load image data

% Load sample data as an image datastore
imageData = imageDatastore( datasetPath,...
                            'IncludeSubFolders',true,...
                            'LabelSource','foldernames');

% Specify the size of the images in the input layer
imageExample                = readimage(imageData,1);
[resolutionX, resolutionY]  = size(imageExample);
resolutionZ                 = 1; % 2d image

% Specify the categorical label number
labelCount          = countEachLabel(imageData);
[numOfLabels,~]     = size(labelCount);

%% Specify training and validation sets

% Split the homogenous datastore into the train data store and the validation datastore randomly
[imageDataTrain,imageDataValidation] = splitEachLabel(imageData,PERCENTAGEOFTRAINFILES,'randomize');

%% Define network architecture

layers =    [
    imageInputLayer([resolutionX resolutionY resolutionZ])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(numOfLabels)
    softmaxLayer
    classificationLayer
            ];

%% Specify training options

options =   trainingOptions(...
                            'sgdm', ...
                            'InitialLearnRate',0.01, ...
                            'MaxEpochs',4, ...
                            'Shuffle','every-epoch', ...
                            'ValidationData',imageDataTrain, ...
                            'ValidationFrequency',30, ...
                            'Verbose',false, ...
                            'Plots','training-progress'...
                            );

%% Train the network
networkTrained =       trainNetwork(imageDataTrain,layers,options);

%% Compute the accuracy of the network
classificationPredicted =  	classify(networkTrained,imageDataValidation);
classificationReal      =  	imageDataValidation.Labels;   
networkAccuracy         =   sum(classificationPredicted == classificationReal)/numel(classificationReal);

%% Save network training results

networkResult.networkTrained	=   networkTrained;
networkResult.networkAccuracy   =   networkAccuracy;

% Create result directory
dirNameSplit                    =   split(datasetPath,string(filesep));
dirNameResult                  =   join([dirNameSplit(1:end-1)',"Results"],string(filesep));
resultName                      =   dirNameSplit(end);

if ~exist(dirNameResult, 'dir')
    mkdir(dirNameResult)
end

% Create result figure directory
dirNameResultsFigures        	=   join([dirNameResult,"Figures"],string(filesep));

if ~exist(dirNameResultsFigures, 'dir')
    mkdir(dirNameResultsFigures)
end

% Create result network directory
dirNameResultsNetworks       	=   join([dirNameResult,"Networks"],string(filesep));

if ~exist(dirNameResultsNetworks, 'dir')
    mkdir(dirNameResultsNetworks)
end

% Save generated figure
FigList                         = 	findobj(allchild(0), 'flat', 'Type', 'figure');
FigHandle                       = FigList(1);
FigHandle.Name                  = resultName;
savefig(FigHandle, join([dirNameResultsFigures,"\", resultName, ".fig"],""));

% Save generated network structure
save(join([dirNameResultsNetworks,"\",resultName,".mat"],""),'networkResult')

end


