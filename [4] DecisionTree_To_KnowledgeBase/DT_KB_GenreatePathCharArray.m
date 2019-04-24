function arrayCharRTN = DT_KB_GenreatePathCharArray(path, seperator)

    arrayCharRTN = [];
    
    [~, NumNodes] = size(path);
    
    for idxNode = 1:NumNodes
        
        nodeValue = path(idxNode);
        
        charNode = num2str(nodeValue);
        
        arrayCharRTN = [arrayCharRTN, charNode];
        
        if idxNode ~= NumNodes
            
            arrayCharRTN = [arrayCharRTN, seperator];
            
            
        end
        
    end
end