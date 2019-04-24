function DT_Main_Driver()

    load dataMatrix_Converted.mat;
    
    DEPTH_MAX = dataMatrix_Converted.DEPTH_MAX;
        
    setDataTrain = dataMatrix_Converted.setDataTrain;
    
    listDataNames = dataMatrix_Converted.listDataNames;
    
    listDataRange = dataMatrix_Converted.listRangeIntData;

    [nodeRoot, depth] = DT_ID3(setDataTrain, listDataNames, listDataRange, DEPTH_MAX);
    
    listVariableUsed = DT_Find_Variable_Used(nodeRoot, listDataRange);
    
    DisplayDecisionTree(nodeRoot);
    
    DecisionTree.listDataNames = dataMatrix_Converted.listDataNames;
    DecisionTree.listRangeIntData = dataMatrix_Converted.listRangeIntData;
    DecisionTree.nodeRoot = nodeRoot;
    DecisionTree.listVariableUsed_DT = listVariableUsed;

    save('DecisionTree.mat','DecisionTree');
    
end