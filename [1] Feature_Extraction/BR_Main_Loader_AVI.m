function listResultVideos = BR_Main_Loader_AVI(charFolderPath)
    
%     load objectRef.mat
%     objectRef = BR_Image_Object_Extract_Feature(object,0);
    
    strFolderPath = convertCharsToStrings(charFolderPath);
    
    listInfoFiles = dir([charFolderPath '/*.avi']);
    
    NumVideo = size(listInfoFiles,1);
    
%     listResultVideos = {};
%     listResultVideosAll = {};
    
    for n = 1:NumVideo
        
        clear listResultVideos;
        
        listResultVideos = {};
        
        
        infoFile = listInfoFiles(n);
        
        charFileName = infoFile.name;
        charFileFolder = infoFile.folder;
        
        strFilePath = convertCharsToStrings(charFileFolder) + "/" + convertCharsToStrings(charFileName);
        charFilePath = char(strFilePath);
        
        videoRef = VideoReader(charFilePath);
        
%         imRef_RGB = BR_Video_Generate_ImRef(videoRef);
%         save('imRef_RGB','imRef_RGB');
        

        fileImRef = convertCharsToStrings(charFileFolder) + "\" + "imRef_RGB.mat";
        load(fileImRef);
%         imRef_RGB = 0;
        
        video = VideoReader(charFilePath);
                
        listResults = BR_Video_Process_AVI(video, imRef_RGB);
        
        listResultVideos{1} = listResults;
        
        strFileSaveName = strFolderPath+ "dataFile" + n + ".mat";
        charFileSaveName = char(strFileSaveName);
        save(charFileSaveName, 'listResultVideos');
        
        
%         listResultVideosAll{n} = listResults;

    end
    
%     listResultVideos = listResultVideosAll;
    

end

