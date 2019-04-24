function [nodeRoot, DEPTH_MAX] = DT_ID3(listData, listColumnName, listDataRange, DEPTH_LIMIT)

    
    listLabel = listData(:,1);
    listExamples = listData(:,2:end);
  
    
%     nodeRoot = DT_ID3_Recursion(listLabel, listExamples, []);
    [nodeRoot, ID_COUNTER_NODE, DEPTH_MAX] = DT_ID3_Recursion(listLabel, listExamples, [], 0, DEPTH_LIMIT, 1, listColumnName, listDataRange);

end

function [node, ID_COUNTER_NODE, DEPTH_MAX] = DT_ID3_Recursion(listLabel, listExamples, listIdxColUsed, depth, DEPTH_LIMIT, ID_COUNTER_NODE, listColumnName, listDataRange)
    

    node.index = ID_COUNTER_NODE;
    ID_COUNTER_NODE = ID_COUNTER_NODE + 1;
    
    labelMax = DT_Find_Most_Common_Label(listLabel);
    
    node.parent = [];
    node.children = [];
    node.value = "";
    node.label = -1;
    node.indexCol = -1;
    node.nameCol = "";
    node.rangeData = [];
    node.depth = depth;
    node.labelMax = labelMax;
    DEPTH_MAX = depth;
    
    [NumExamples, NumCol] = size(listExamples);
    
    listLabelType = unique(listLabel);
    
    [NumLabels,~] = size(listLabelType);
    
    if NumLabels == 1
        node.label = listLabelType(1);
    elseif depth >= DEPTH_LIMIT
        node.label = labelMax;
    else
        
        [listInfoGain, idxCol_Max, infoGain_Max] = DT_Calculate_Information_Gain(listLabel, listExamples, listIdxColUsed);
        
        listSet = DT_Seperate_Examples_By_Col(listLabel, listExamples, idxCol_Max);
        
        listIdxColUsed = [listIdxColUsed; idxCol_Max];
        
        [NumSet,~] = size(listSet);
        
        
        
               
        for idxSet = 1:NumSet
            depthNext = depth + 1;
            set = listSet{idxSet,1};
            listLabel_Current = set.listLabel;
            listExamples_Current = set.listExamples;
            [nodeCurrent, ID_COUNTER_NODE_New, depthBrench] = DT_ID3_Recursion(listLabel_Current, listExamples_Current, listIdxColUsed, depthNext, DEPTH_LIMIT, ID_COUNTER_NODE, listColumnName, listDataRange);
            
            nodeCurrent.parent = node;
            nodeCurrent.value = set.type;
            
            if set.type == -1
                asdf = 0;
            end
            
            node.children = [node.children; nodeCurrent];
            
            ID_COUNTER_NODE = ID_COUNTER_NODE_New;
            
            if depthBrench > DEPTH_MAX
                DEPTH_MAX = depthBrench;
            end
                
            
        end
        
        node.indexCol = idxCol_Max;
        node.nameCol = listColumnName{1,idxCol_Max};
        node.rangeData = listDataRange(idxCol_Max).rangeIntData;
        
    end

end