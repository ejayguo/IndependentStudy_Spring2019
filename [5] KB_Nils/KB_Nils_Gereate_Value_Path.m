function [setValuePath, accuracyDT] = KB_Nils_Gereate_Value_Path(DecisionTree, setData, varSeperator)

    [NumEx, ~] = size(setData);
    
    setValuePath = {};
    
    nodeRoot = DecisionTree.nodeRoot;
    
    counterTotal = NumEx;
    counterHit = 0;
    
    for idxEx = 1:NumEx
        dataExample = setData(idxEx,:);
        labelTruth = dataExample(1);
        example = dataExample(2:end);
        [labelRtn, pathValue] = KB_Nils_DT_Query(nodeRoot, example);
        
        setValuePath{idxEx} = pathValue + varSeperator;
        
        
        if labelRtn == labelTruth
            counterHit = counterHit + 1;
        end
        
    end
    
    accuracyDT = counterHit/counterTotal;
    
    
end