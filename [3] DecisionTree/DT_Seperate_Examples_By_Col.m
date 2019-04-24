function listSet = DT_Seperate_Examples_By_Col(listLabel, listExamples, idxCol)
    
%     listSet = {};
    
    listAttributeValue = listExamples(:,idxCol);
    
    [NumValue, ~] = size(listAttributeValue);
    
    listTypeValue = unique(listAttributeValue);
    
    [NumType,~] = size(listTypeValue);
    
    listSet = cell(NumType,1);
    
    for idxType = 1:NumType
        
        type = listTypeValue(idxType);
        
        if type == -1
            asdf = 0;
        end
        
        idxCurrent = find(listAttributeValue == type);
        
        listLabelCurrent = listLabel(idxCurrent);
        listExamplesCurrent = listExamples(idxCurrent,:);
        
        listSet{idxType}.idxCol = idxCol;
        listSet{idxType}.type = type;
        listSet{idxType}.listLabel = listLabelCurrent;
        listSet{idxType}.listExamples = listExamplesCurrent;
    end


end

