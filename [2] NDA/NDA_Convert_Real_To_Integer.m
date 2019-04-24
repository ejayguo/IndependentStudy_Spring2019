function listData_Converted = NDA_Convert_Real_To_Integer(listData, listThresholds, varAccumulator)
    listData_Converted = [];
    
    [NumData,~] = size(listData);
    
    for idxData = 1:NumData
        
        realNum = listData(idxData);
        
        integerFeature = Convert_Real_To_Integer(realNum, listThresholds, varAccumulator);
        
        listData_Converted = [listData_Converted; integerFeature];
        
    end

end

function integerFeature = Convert_Real_To_Integer(realNum, listThresholds, varAccumulator)

    [NumThresholds,~] = size(listThresholds);

    integerFeature = -1;
    
    for idxThreshold = 1:NumThresholds
        threshold = listThresholds(idxThreshold);

        if realNum <= threshold
            integerFeature = idxThreshold;
            break;
        end
    end
    
    if integerFeature == -1
        asdf = 0;
    end
    
    integerFeature = integerFeature + varAccumulator;

end

