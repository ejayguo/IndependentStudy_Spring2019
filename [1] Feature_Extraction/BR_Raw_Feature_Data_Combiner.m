function setData = BR_Raw_Feature_Data_Combiner()

    NumBins = 10;

    listStrFeature = ["label", "NumPixels", "MeanPosM", "MeanPosN", "StdPosM", "StdPosN", ...
        "Curv_Bin_01", "Curv_Bin_02", "Curv_Bin_03", "Curv_Bin_04", "Curv_Bin_05", "Curv_Bin_06", "Curv_Bin_07", ...
        "Curv_Bin_08", "Curv_Bin_09", "Curv_Bin_10"];

    charFolderPath = uigetdir();

    listInfoFiles = dir([charFolderPath '/*.mat']);

    NumFiles = size(listInfoFiles,1);

    matrixExamples = [];
    listExamples = [];
    listProperties = [];
    
    setData.listStrFeature = listStrFeature;
    
    setData.data = [];


    for idxFile = 1:NumFiles

        infoFile = listInfoFiles(idxFile);
        charFileName = infoFile.name;
        charFileFolder = infoFile.folder;

        strFilePath = convertCharsToStrings(charFileFolder) + "\" + convertCharsToStrings(charFileName);
        charFilePath = char(strFilePath);

        S = load(charFilePath);
        
        listFrames = S.listFrames;
        
        [NumFrames, ~] = size(listFrames);
        
        for idxFrame = 1:NumFrames
            
            vectorFeature_Raw = [];
            
            frame = listFrame(idxFrame);
            
            label = frame.label;
            
            NumPixels = frame.data.NumPixels.num;
            
            listPts = frame.data.NumPixels.listPts;
            
            listPtsM = listPts(:,1);
            
            meanM = mean(listPtsM);
            
            stdM = std(listPtsM);
            
            listPtsN = listPts(:,2);
            
            meanN = mean(listPtsN);
            
            stdN = std(listPtsN);
            
            listCurvature = frame.data.listCurvature;
            
            listHistCounters = hist(listCurvature, NumBins);
            
            listHistCounters_Normalized = listHistCounters./NumPixels;
            
            vectorFeature_Raw = [label, NumPixels, meanM, stdM, meanN, stdN, listHistCounters_Normalized];
            
            frame.feature.listStrFeature = listStrFeature;
            
            frame.feature.vectorFeature_Raw = vectorFeature_Raw;
            
            setData.data = [setData.data; vectorFeature_Raw];
            
        end
        
    end
    
    strFileName = "MatrixRaw";
    
    csvwrite(char(strFileName), setData.data);
    
end