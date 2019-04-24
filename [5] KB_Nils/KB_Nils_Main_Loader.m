function KB_Nils_Main_Loader()

    load KnowledgeBase.mat;
    
    load dataMatrix_Converted.mat;
    
    [setData_DT_KB, accuracyDT, accuracyAbsKB, accuracyKB, counterErrorKB] = KB_Nils_Compare_DT_KB(KnowledgeBase, dataMatrix_Converted);

%     load KnowledgeBase01.mat;
%     
%     load dataMatrix_Converted01.mat;
%     
%     [setData_DT_KB01, accuracyDT01, accuracyAbsKB01, accuracyKB01, counterErrorKB01] = KB_Nils_Compare_DT_KB(KnowledgeBase, dataMatrix_Converted);
%     
%     load KnowledgeBase02.mat;
%     
%     load dataMatrix_Converted02.mat;
%     
%     [setData_DT_KB02, accuracyDT02, accuracyAbsKB02, accuracyKB02, counterErrorKB02] = KB_Nils_Compare_DT_KB(KnowledgeBase, dataMatrix_Converted);

end