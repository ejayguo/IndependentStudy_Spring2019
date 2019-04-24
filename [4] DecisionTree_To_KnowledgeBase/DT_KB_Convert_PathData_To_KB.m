function [KB, mapPathDataRTN] = DT_KB_Convert_PathData_To_KB(mapPathData)

    mapPathDataRTN = containers.Map('KeyType','char','ValueType','any');

    setKeys= keys(mapPathData);
    
%     setDataPath= values(mapPathData);
    
    [~, NumKeys] = size(setKeys);
    
    KB = [];
    
    for idxKey = 1:NumKeys
        
        key = setKeys{idxKey};
        
        dataPath = mapPathData(key);
        
        clauses = [dataPath.path * -1, dataPath.label];
        
        dataPath.KB.clauses = clauses;
        dataPath.KB.prob = dataPath.accuracy;
        
        mapPathDataRTN(key) = dataPath;
        
        KB(idxKey).clauses = clauses;
        KB(idxKey).prob = dataPath.accuracy;
        
    end

end