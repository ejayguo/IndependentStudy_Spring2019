function [setData_DT_KB, accuracyDT, accuracyAbsKB, accuracyKB, counterErrorKB] = KB_Nils_Compare_DT_KB(KnowledgeBase, dataMatrix_Converted)

    KB = KnowledgeBase.KB_Condensed;
    
    listVariableUsed_DT = KnowledgeBase.DecisionTree.listVariableUsed_DT;
    
    [~, NumVariables] = size(listVariableUsed_DT);
    
    ARRAY_INITIAL = 0.5*ones(NumVariables,1);

    setDataOnly = dataMatrix_Converted.setDataTest;

    decisionTree = KnowledgeBase.DecisionTree;
    
    listVariableMapping_DT2KB = KnowledgeBase.listVariableMapping_DT2KB;
    
    [setData_DT, accuracyDT] = KB_Nils_DT_Predicte_Examples(decisionTree, setDataOnly);
    
     setData_DT_KB_NotPredicted = KB_Nils_Convert_Examples(setData_DT, listVariableMapping_DT2KB);
     
     listAtomVariables = [1, 2, 3];
     
     [setData_DT_KB, accuracyAbsKB, accuracyKB, counterErrorKB] = KB_Nils_KB_Predicte_Examples(KB, setData_DT_KB_NotPredicted, NumVariables, listAtomVariables);
     
end
