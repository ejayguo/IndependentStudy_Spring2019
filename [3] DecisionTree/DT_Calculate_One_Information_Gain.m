function infoGain = DT_Calculate_One_Information_Gain(listLabel, listAttributeValue)

    entropyLabel = DT_Calculate_Entropy(listLabel);
    
    [NumValue, ~] = size(listAttributeValue);
    
    listTypeValue = unique(listAttributeValue);
    [NumType,~] = size(listTypeValue);
    
    listEntropyType = [];
    
    for idxType = 1:NumType
        type = listTypeValue(idxType);
        
        listLabelType = listLabel(listAttributeValue == type);
        entropyType = DT_Calculate_Entropy(listLabelType);
        
        counterValue = sum(listAttributeValue == type);
        
        entropyType = entropyType * counterValue / NumValue;
        
        listEntropyType = [listEntropyType; entropyType];
        
        
        
    end
    
    infoGain = entropyLabel - sum(listEntropyType);

end

