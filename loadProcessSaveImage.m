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
% Authors: Antonis Kantounias - Eleutherios Kantounias, Email: antonis.kantounias@gmail.com, Date: 2022.12.29

%% Load image
imageInitialName    = join([unprocessedImageDirectory,string(filesep),imageName],"");
imageInitial        = imread(imageInitialName);

%% Process image
imageFinal          = mat2gray(imageInitial);

%% Save image

% Create the processed data base folder and file name
imageFinalNamesParts        = split(imageInitialName,string(filesep));

% Find the label of each image file
if contains(imageFinalNamesParts(end),'In')
    categoryName = "Inclusion";
elseif contains(imageFinalNamesParts(end),'Pa')
    categoryName = "Patch";
elseif contains(imageFinalNamesParts(end),'PS')
    categoryName = "Spot";
else
    error('Unknown image category')
end

% Insert category name folder
imageFinalNamesParts(end-1) = join([imageFinalNamesParts(end-1),"Processed","_",alias,"\",categoryName],"");

% Change image file type
imageFinalNamesParts(end)   = replace(imageFinalNamesParts(end),'.bmp','.png');

% Generate images final name
imageFinalName              = join(imageFinalNamesParts,"\");

% Create the folder in case it is not exists
processedImageDirectory = fileparts(imageFinalName);
if ~exist(processedImageDirectory, 'dir')
    mkdir(processedImageDirectory)
end


% Save processed image

imwrite(imageFinal,imageFinalName);
