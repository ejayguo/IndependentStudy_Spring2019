function KB_Nils_Merge_Loader()

    load KnowledgeBase01.mat;
    
    KnowledgeBase01 = KnowledgeBase;
    DecisionTree01 = KnowledgeBase01.DecisionTree;
    
    load KnowledgeBase02.mat;
    
    KnowledgeBase02 = KnowledgeBase;
    DecisionTree02 = KnowledgeBase02.DecisionTree;
    
    listVariables = [1,2,3];
    
    load dataMatrix_Converted01.mat;
    
    setData01 = dataMatrix_Converted.setDataTest;
    
    load dataMatrix_Converted02.mat;
    
    setData02 = dataMatrix_Converted.setDataTest;
    
    %     [setData_DT_KB, accuracyDT, accuracyAbsKB, accuracyKB] = KB_Nils_Compare_DT_KB(KnowledgeBase01, dataMatrix_Converted);
    
    [setData_DT01, accuracyDT01] = KB_Nils_DT_Predicte_Examples(DecisionTree01, setData01);
    
    [setData_DT02, accuracyDT02] = KB_Nils_DT_Predicte_Examples(DecisionTree02, setData02);
    
    KnowledgeBase_Merged = KB_Nils_Merge_KB(KnowledgeBase01, KnowledgeBase02, listVariables);
    
    [setValuePath01, accuracyDT01] = KB_Nils_Gereate_Value_Path(KnowledgeBase_Merged.DecisionTree01, setData01, 0);
    
    [setValuePath02, accuracyDT02] = KB_Nils_Gereate_Value_Path(KnowledgeBase_Merged.DecisionTree02, setData02, KnowledgeBase_Merged.varSeperator);
    
    KB_Merged = KnowledgeBase_Merged.KB;
%     setData_KB_NotPredicted = dataMatrix_Converted.setData;
    
    [~, NumVariable01] = size(KnowledgeBase01.DecisionTree.listVariableUsed_DT);
    [~, NumVariable02] = size(KnowledgeBase02.DecisionTree.listVariableUsed_DT);
    
    NumVariables = NumVariable01 + NumVariable02 - 3;
    listAtomVariables = [1, 2, 3];
    
    setData_KB_NotPredicted.setData01 = setData01;
    setData_KB_NotPredicted.setData02 = setData02;
    setData_KB_NotPredicted.setValuePath01 = setValuePath01;
    setData_KB_NotPredicted.setValuePath02 = setValuePath02;
    
    [setValuePath01_Condensed, setValuePath02_Condensed] = KB_Nils_Merge_Condense_Value_Path(KnowledgeBase_Merged, setData_KB_NotPredicted);
    
    setDataMerged.setData01 = setData01;
    setDataMerged.setData02 = setData02;
    setDataMerged.setValuePath01_Condensed = setValuePath01_Condensed;
    setDataMerged.setValuePath02_Condensed = setValuePath02_Condensed;
    
    [setData_KB_Merged, accuracyAbsKB_Merged, accuracyKB_Merged, counterErrorKB_Merged] = KB_Nils_Merge_Predicte_Examples(KnowledgeBase_Merged.KB_Condensed, setDataMerged, NumVariables, listAtomVariables);
    
    
    

end