function processDBImages(unprocessedImageDirectory,alias,varargin)
%% processDBImages
% Loads all image files from a specific directory, process the images and
% save them to an equivalent, processed directory
% 
% Inputs:
%     unprocessedImagesDirectory        Directory where the unprocessed data are stored, full name [string]
%     alias                             Name extension for the processed data [string]
%
% Authors: Antonis Kantounias - Eleutherios Kantounias, Email: antonis.kantounias@gmail.com, Date: 2022.12.29

%% Get a list of all files and folders in this folder.
unprocessedImageDir     = dir(unprocessedImageDirectory);
unprocessedImageFiles   =  unprocessedImageDir(~[unprocessedImageDir.isdir]);

%% Process and save the image files
for iFile = 1:length(unprocessedImageFiles)
    
    fileName            = unprocessedImageFiles(iFile).name;
    [~,~,fileExtension] = fileparts(fileName);
    
    if strcmp(fileExtension,'.bmp')
        imageName = fileName;
        loadProcessSaveImage(unprocessedImageDirectory,alias,imageName,varargin{:});
    end
    
end

