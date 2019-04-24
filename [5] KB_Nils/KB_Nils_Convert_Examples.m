function setData_DT_KB_NotPredicted = KB_Nils_Convert_Examples(setData_DT, listVariableMapping_DT2KB)
    
    setData_DT_KB_NotPredicted = [];
    
    [~, NumEx] = size(setData_DT);
    
    for idxEx = 1:NumEx
        
        dataEx = setData_DT(idxEx);
        
        pathValueDT = setData_DT(idxEx).DT.pathValue_Predicted;
        
        [~, NumValues] = size(pathValueDT);
        
        pathValueKB = [];
        
        for idxValue = 1:NumValues
            valueDT = pathValueDT(idxValue);
            
            valueKB = listVariableMapping_DT2KB(valueDT);
            
            pathValueKB = [pathValueKB, valueKB];
        end
        
        setData_DT(idxEx).KB.pathValue = pathValueKB;
        
        setData_DT_KB_NotPredicted(idxEx).DT = setData_DT(idxEx).DT;
        setData_DT_KB_NotPredicted(idxEx).LABEL = setData_DT(idxEx).LABEL;
        setData_DT_KB_NotPredicted(idxEx).KB = setData_DT(idxEx).KB;
    end

end