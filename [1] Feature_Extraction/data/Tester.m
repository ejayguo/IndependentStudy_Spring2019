function Tester()

    load dataFile.mat
    

    [charFileName,charFilePath] = uigetfile({'*.avi'; '*.mov'; '*.*'});
    
    strVideoFilePath = convertCharsToStrings(charFilePath) + convertCharsToStrings(charFileName);
    
    charVideoFilePath = char(strVideoFilePath);
    
    [~,lengthName] = size(charFileName);
    
    if lengthName > 1
        
%         videoRef = VideoReader(charVideoFilePath);
%         imRef_RGB = BR_Video_Generate_ImRef(videoRef);
%         pathRef = [charFilePath,'/imRef_RGB'];
%         save(pathRef,'imRef_RGB');
        
        fileImRef = convertCharsToStrings(charFilePath) + "imRef_RGB.mat";
        if isfile(fileImRef)
            load(fileImRef);
        else
            videoRef = VideoReader(charVideoFilePath);
            imRef_RGB = BR_Video_Generate_ImRef(videoRef);
            pathRef = [charFilePath,'/imRef_RGB'];
            save(pathRef,'imRef_RGB');
        end
        
        video = VideoReader(charVideoFilePath);
        
        n = 0;
        
        while hasFrame(video)
            n = n + 1;
            
            im_RGB = readFrame(video);
            
            if n < 30
                continue;
            end
        
            im_Cut = im_RGB(200:400, 1:450, :);
            
            imshow(im_Cut);
                        
        end

end