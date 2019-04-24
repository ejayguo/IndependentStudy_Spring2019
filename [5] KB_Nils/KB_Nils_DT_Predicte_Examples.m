function [setData_DT_Predicted, accuracyDT] = KB_Nils_DT_Predicte_Examples(DecisionTree, setData)

    [NumEx, ~] = size(setData);
    
    setData_DT_Predicted = [];
    
    nodeRoot = DecisionTree.nodeRoot;
    
    counterTotal = NumEx;
    counterHit = 0;
    
    for idxEx = 1:NumEx
        dataExample = setData(idxEx,:);
        labelTruth = dataExample(1);
        example = dataExample(2:end);
        [labelRtn, pathValue] = KB_Nils_DT_Query(nodeRoot, example);
        
        
        setData_DT_Predicted(idxEx).DT.label_Predicted = labelRtn;
        setData_DT_Predicted(idxEx).DT.pathValue_Predicted = pathValue;
        setData_DT_Predicted(idxEx).LABEL = labelTruth;
        
        if labelRtn == labelTruth
            counterHit = counterHit + 1;
        end
        
    end
    
    accuracyDT = counterHit/counterTotal;

end