function listVariableUsedRTN = DT_Find_Variable_Used(nodeRoot, listDataRange)

    node = nodeRoot;
    
    listVariableUsed = DT_Find_Variable_Used_Recursion(node, listDataRange);
    
    listVariableUsedRTN = sort(unique(listVariableUsed));

end

function listVariableUsedRTN = DT_Find_Variable_Used_Recursion(node, listDataRange)

    listVariableUsedRTN = [];
    
    if node.labelMax ~= -1
        listVariableUsedRTN = [listVariableUsedRTN, node.labelMax];
    end
    
    if node.indexCol ~= -1
        listVariableUsedRTN = [listVariableUsedRTN, listDataRange(node.indexCol).rangeIntData];
        
        if ~isempty(node.children)
            [NumChildren, ~] = size(node.children);
            
            listVariableUsed_Merged = listVariableUsedRTN;
            
            for idxChild = 1:NumChildren
                nodeChild = node.children(idxChild);
                listVariableUsedChild = DT_Find_Variable_Used_Recursion(nodeChild, listDataRange);
                
                listVariableUsed_Merged = [listVariableUsed_Merged, listVariableUsedChild];
            end
            
            listVariableUsedRTN = sort(unique(listVariableUsed_Merged));
            
        end
        
    else
        
        if node.label ~= -1
            listVariableUsedRTN = [listVariableUsedRTN, node.label];
            
            listVariableUsedRTN = sort(unique(listVariableUsedRTN));
        end
        
    end

end