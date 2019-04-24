function [setValuePath01_Condensed, setValuePath02_Condensed] = KB_Nils_Merge_Condense_Value_Path(KnowledgeBase_Merged, setData_KB_NotPredicted)

    listVariableMapping_DT2KB = KnowledgeBase_Merged.listVariableMapping_DT2KB;
    
    setData01 = setData_KB_NotPredicted.setData01;
    setData02 = setData_KB_NotPredicted.setData02;
    setValuePath01 = setData_KB_NotPredicted.setValuePath01;
    setValuePath02 = setData_KB_NotPredicted.setValuePath02;
    
    varSeperator = KnowledgeBase_Merged.varSeperator;

    setValuePath01_Condensed = [];
    setValuePath02_Condensed = [];
    
    [NumEx, ~] = size(setData01);
    
    for idxEx = 1:NumEx
        
        example01 = setData01(idxEx, :);
        label = example01(1);
        
        valuePath01 = setValuePath01{idxEx};
        valuePath01_Condensed = [];
        
        [~, NumVal01] = size(valuePath01);
        
        for idxVal = 1:NumVal01
            
            value01 = valuePath01(idxVal);
            
            value01Mapped = listVariableMapping_DT2KB(value01);
            
            valuePath01_Condensed = [valuePath01_Condensed, value01Mapped];
            
        end
        
        setValuePath01_Condensed{idxEx} = valuePath01_Condensed;
        
        
        valuePath02 = setValuePath02{idxEx};
        valuePath02_Condensed = [];
        
        [~, NumVal02] = size(valuePath02);
        
        for idxVal = 1:NumVal02
            
            value02 = valuePath02(idxVal);
            
            value02Mapped = listVariableMapping_DT2KB(value02);
            
            valuePath02_Condensed = [valuePath02_Condensed, value02Mapped];
            
        end
        
        setValuePath02_Condensed{idxEx} = valuePath02_Condensed;
        
    end

end