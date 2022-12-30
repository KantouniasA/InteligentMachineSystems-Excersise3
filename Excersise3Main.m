%% Main program
unprocessedImageDirectory = "C:\Users\Antonis Kantounias\Documents\ergasies\inteligentMachiningSystems\excersise3\Codes\Data";

%% Create all possible data sets 

% Possible data sets
optionNames     =   { 
                    'process_imadjust',	'process_imbinarize',       'process_filter2laplacian',	'process_filter2prewitt',	'process_bwareopen',    'process_imfill'    
                    };


                
optionValuesCombinations	=	[ 
                                false,              false,                      false,                      false,                      false,                  false   % Filter1
                                true,               false,                      false,                      false,                      false,                  false   % Filter2
                                true,               true,                       false,                      false,                      false,                  false   % Filter3
                                true,               true,                       true,                       false,                    	false,                  false   % Filter4     
                                true,               true,                       true,                       false,                    	false,                  true    % Filter5   
                                true,               true,                       true,                       false,                    	true,                   true    % Filter6
                                true,               true,                       false,                      true,                    	false,                  true    % Filter7
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

for iCombination = 1:length(aliasses)
    % Generate the option values for current combination
    optionValues    = optionValuesCombinations(iCombination,:);
    alias           = aliasses{iCombination};
    % Generate varagin file
    varargin = cell(1,2*length(optionNames));
    for iOption  = 1:length(optionNames)
        varargin{2*iOption-1}   = optionNames{iOption};
        varargin{2*iOption}     = optionValues(iOption);
    end
    % Generate processed image data base
    processDBImages(unprocessedImageDirectory,alias,varargin{:})
end
                    

