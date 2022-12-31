function [processedImageDirectory] = loadProcessSaveImage(unprocessedImageDirectory,alias,imageName,varargin)
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
%% Add parameters
p = inputParser;
p.addParameter('process_imadjust',          true);
p.addParameter('process_average',           false);
p.addParameter('process_imbinarize',        true);
p.addParameter('process_filter2laplacian',	true);
p.addParameter('process_filter2prewitt',	false);
p.addParameter('process_bwareopen',         true);
p.addParameter('process_imfill',            true);

p.parse(varargin{:})
process_imadjust            = p.Results.process_imadjust;
process_average           	= p.Results.process_average;
process_imbinarize          = p.Results.process_imbinarize;
process_filter2prewitt      = p.Results.process_filter2prewitt;
process_filter2laplacian 	= p.Results.process_filter2laplacian;
process_bwareopen           = p.Results.process_bwareopen;
process_imfill              = p.Results.process_imfill;

%% Load image

% Read image file
imageInitialName    = join([unprocessedImageDirectory,string(filesep),imageName],"");
imageFinal          = imread(imageInitialName);

%% Process image

% Scale correction
imageFinal          = mat2gray(imageFinal);

% Adjust image intensity
if process_imadjust
    imageFinal = imadjust(imageFinal,[],[0.8,1]);
end

% Average filter
if process_average
    imageFinal = filter2(fspecial('average'),imageFinal);
end

% Convert the image into binary using adaptive thresholding
if process_imbinarize
    imageFinal  = imbinarize(imageFinal,'adaptive','ForegroundPolarity','dark','Sensitivity',0.5);
end

% Perform filter operation to look for edges (2nd degree derivative detection)
if process_filter2laplacian
    imageFinal = filter2(fspecial('laplacian'),imageFinal);
end

% Perform filter operation to look for edges (1nd degree derivative detection)
if process_filter2prewitt
    imageFinal = filter2(fspecial('prewitt'),imageFinal);
    imageFinal = imadjust(imageFinal);
end

% Scale correction
imageFinal          = mat2gray(imageFinal);

% Convert the image into binary using adaptive thresholding
if process_imbinarize
    imageFinal  = imbinarize(imageFinal);
end

% Remove small objects from binary image
if process_bwareopen
    pixelSize  = 2;
    imageFinal = bwareaopen(imageFinal, pixelSize);
end

% Fill the holes
if process_imfill
    imageFinal(1,:)     = 1-imageFinal(1,:);
    imageFinal(end,:)   = 1-imageFinal(end,:);
    imageFinal(:,1)     = 1-imageFinal(:,1);
    imageFinal(:,end)   = 1-imageFinal(:,end);
    imageFinal = imfill(imageFinal, 'holes');
end

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
