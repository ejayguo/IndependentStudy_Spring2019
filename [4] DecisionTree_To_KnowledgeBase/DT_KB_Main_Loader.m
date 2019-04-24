function  DT_KB_Main_Loader()

    load DecisionTree.mat;
    
    nodeRoot = DecisionTree.nodeRoot;
    
    
    load dataMatrix_Converted.mat;
        
    setDataDev = [dataMatrix_Converted.setDataTrain; dataMatrix_Converted.setDataDev];
    
    mapPathData = DT_KB_Calculate_Accuracy(nodeRoot, setDataDev);
    
    [KB, mapPathDataRTN] = DT_KB_Convert_PathData_To_KB(mapPathData);
    
    listVariableUsed_DT = DecisionTree.listVariableUsed_DT;
    
    [KB_Condensed, listVariableMapping_DT2KB] = DT_KB_Condense_Variables(KB, listVariableUsed_DT);
        
    KnowledgeBase.KB = KB;
    KnowledgeBase.KB_Condensed = KB_Condensed;
    KnowledgeBase.listVariableMapping_DT2KB = listVariableMapping_DT2KB;
    KnowledgeBase.mapPathData = mapPathData;
    KnowledgeBase.DecisionTree = DecisionTree;

    save('KnowledgeBase.mat','KnowledgeBase');
    
end

