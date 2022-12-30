%% Main program
unprocessedImageDirectory = "C:\Users\Antonis Kantounias\Documents\ergasies\inteligentMachiningSystems\excersise3\Codes\Data";

%% Create all possible data sets 

% Possible data sets
optionNames                 =   { 
                                'process_imadjust',	'process_imbinarize',       'process_filter2laplacian',	'process_filter2prewitt',	'process_bwareopen',    'process_imfill'    
                                };

optionValuesCombinations	=	[ 
                                false,              false,                      false,                      false,                      false,                  false   % Filter1
                                true,               false,                      false,                      false,                      false,                  false   % Filter2
                                true,               true,                       false,                      false,                      false,                  false   % Filter3
                                true,               false,                      true,                       false,                    	false,                  false   % Filter4     
                                true,               true,                       true,                       false,                    	false,                  false   % Filter5     
                                true,               false,                      false,                      true,                    	false,                  false   % Filter6
                                false,              false,                      false,                      true,                    	false,                  false   % Filter6
                                ];
 
 aliasses       =   {
                    'Filter1'
                    'Filter2'
                    'Filter3'
                    'Filter4'
                    'Filter5'
                    'Filter6'
                    'Filter7'
                    };

for iDataCombination = 1:length(aliasses)
    % Generate the option values for current combination
    optionValues    = optionValuesCombinations(iDataCombination,:);
    alias           = aliasses{iDataCombination};
    % Generate varagin file
    varargin = cell(1,2*length(optionNames));
    for iOption  = 1:length(optionNames)
        varargin{2*iOption-1}   = optionNames{iOption};
        varargin{2*iOption}     = optionValues(iOption);
    end
    % Generate processed image data base
    processDBImages(unprocessedImageDirectory,alias,varargin{:})
end

%% Generate all possible neural networks

% Network possible layers
networkLayerCombinations    =   {   
                                [16,32,64,16]
                                [16,64,128,32]
                                [16,32,64]
                                [16,64,32]
                                };
                            
networkAliasses             =   {
                                'Network1'
                                'Network2'
                                'Network3'
                                'Network4'
                                };

for iNetworkCombination = 1:length(networkAliasses)
    for iDataCombination = 1:length(aliasses)
        networkAlias                = networkAliasses{iNetworkCombination};
        networkLayers               = networkLayerCombinations{iNetworkCombination};
        processedImageDirectory     = join([unprocessedImageDirectory,"Processed_",string(aliasses{iDataCombination})],"");
        createDeepLearningNetwork(processedImageDirectory,networkLayers,networkAlias)
    end
end
