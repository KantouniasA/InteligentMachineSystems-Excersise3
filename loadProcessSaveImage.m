function [processedImageDirectory] = loadProcessSaveImage(unprocessedImageDirectory,alias,imageName)
%% loadProcessSaveImage
% loadProcessSaveImage loads the images of the database folder. Process
% the images and saves them to a new database folder that will be used for
% network training and validation
% 
% Inputs:
%     unprocessedImagesDirectory        Directory where the unprocessed data are stored, full name [string]
%     alias                             Name extension for the processed data [string]
%
% Outpus:
%     processedImagesDirectory          Directory where the unprocessed data are stored, full name [string]
%
% Created by:
%
% Author: Antonis Kantounias, Email: antonis.kantounias@gmail.com, Date: 2022.12.29

%% Load image
imageInitialName    = join([unprocessedImageDirectory,string(filesep),imageName]);
imageInitial        = imread(imageInitialName);

%% Process image
imageFinal          = mat2gray(imageInitial);

%% Save image

% Create the processed data base folder and file name
imageFinalNamesParts        = split(imageInitialName,string(filesep));
imageFinalNamesParts(end-1) = ([imageFinalNamesParts(end-1),"Processed","_",alias]);
imageFinalName              = join(imageFinalNamesParts);

% Create the folder in case it is not exists
processedImageDirectory = fileparts(imageFinalNames);
if ~exist(processedImageDirectory, 'dir')
    mkdir(processedImageDirectory)
end

% Save processed image
save(imageFinalName,imageFinal)

