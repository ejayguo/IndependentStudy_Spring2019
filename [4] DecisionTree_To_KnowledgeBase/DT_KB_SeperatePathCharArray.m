function [pathRTN] = DT_KB_SeperatePathCharArray(arrayChar, seperator)

    pathRTN = [];
    
    
    arrayCell = strsplit(arrayChar,seperator);
    
    [~, NumNodes] = size(arrayCell);
    
    for idxNode = 1:NumNodes
        
        charNode = arrayCell{idxNode};
        
        node = str2num(charNode);
        
        pathRTN = [pathRTN, node];
        
        
    end

end