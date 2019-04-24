function mapPathDataRTN= DT_KB_Calculate_Accuracy(nodeRoot, setData_Test)

    setLabel = setData_Test(:,1);
    setData = setData_Test(:,2:end);

    [NumEx, ~] = size(setData_Test);
    
    mapPathData = containers.Map('KeyType','char','ValueType','any');
%     mapPathCount = containers.Map('KeyType','char','ValueType','double');
%     mapPathLabel = containers.Map('KeyType','char','ValueType','int64');
    
    for idxEx = 1:NumEx
        
        labelTruth = setLabel(idxEx, 1);
        example = setData(idxEx, :);
        
        [labelPredicted, pathPredicted] = DT_KB_Query(nodeRoot, example);
        
        path = pathPredicted;
        
        arrayChar = DT_KB_GenreatePathCharArray(path, '_');
        
%         [pathRTN] = DT_KB_SeperatePathCharArray(arrayChar, '_');

        isPathDetected = isKey(mapPathData, arrayChar);
        
        if isPathDetected
            dataPath = mapPathData(arrayChar);
            
            if labelTruth == labelPredicted
                counterPos = dataPath.counterPos;
                dataPath.counterPos = counterPos + 1;
            else
                counterNeg = dataPath.counterNeg;
                dataPath.counterNeg = counterNeg + 1;
            end
            
            mapPathData(arrayChar) = dataPath;
            
        else
            
            dataPath.path = path;
            dataPath.counterPos = 0;
            dataPath.counterNeg = 0;
            
            if labelTruth == labelPredicted
                counterPos = dataPath.counterPos;
                dataPath.counterPos = counterPos + 1;
            else
                counterNeg = dataPath.counterNeg;
                dataPath.counterNeg = counterNeg + 1;
            end
            
            dataPath.label = labelTruth;
            
            mapPathData(arrayChar) = dataPath;
            
            
        end
        
%         mapPathData(arrayChar).counterPos
        
    end
    
    mapPathDataRTN = Calculate_Accuracy(mapPathData);
    
%     Test(mapPathDataRTN, mapPathData);
    
        
end

function mapPathDataRTN = Calculate_Accuracy(mapPathData)

    mapPathDataRTN = containers.Map('KeyType','char','ValueType','any');

    arrayKeys = keys(mapPathData);
    
    [~, NumKeys] = size(arrayKeys);
    
    for idxKey = 1:NumKeys
        
        charKey = arrayKeys{idxKey};
        
        dataPath = mapPathData(charKey);
        
        counterPos = dataPath.counterPos;
        counterNeg = dataPath.counterNeg;
        
        counterTotal = counterPos+counterNeg;
        accuracy = counterPos/counterTotal;
        
        dataPath.counterTotal = counterTotal;
        dataPath.accuracy = accuracy;
        
        mapPathDataRTN(charKey) = dataPath;
        
        
        
        
    end
    

end

function Test(mapPathDataRTN, mapPathData)

    arrayKeysRTN = keys(mapPathDataRTN);
    
    [~, NumKeysRTN] = size(arrayKeysRTN);
    
    for idxKeyRTN = 1:NumKeysRTN
        
        charKeyRTN = arrayKeysRTN{idxKeyRTN};
        
        dataPathRTN = mapPathDataRTN(charKeyRTN);
        
        dataPathCheck = mapPathData(charKeyRTN);
        
        if (dataPathRTN.counterPos ~= dataPathCheck.counterPos) || (dataPathRTN.counterNeg ~= dataPathCheck.counterNeg)
            asdf = 0;
        end
        
        dataPathRTN.counterTotal
        dataPathRTN.accuracy
        
        
        
    end
end

