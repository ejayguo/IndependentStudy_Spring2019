function listProb = DT_Calculate_Probabilities(listAttributeValue)
    
    listProb = [];
    
    [NumValue, ~] = size(listAttributeValue);
    
    listTypeValue = unique(listAttributeValue);
    
    [NumType,~] = size(listTypeValue);
    
    
    if NumType == 1
        
        probVal.type = listTypeValue(1);
        probVal.prob = 1;
        probVal.countType = NumValue;
        probVal.countTotal = NumValue;
        
        listProb = [listProb; probVal];
    else
        
        for idxType = 1:NumType
            
            type = listTypeValue(idxType);
            
            counterValue = sum(listAttributeValue == type);
            
            probVal.type = type;
            probVal.prob = counterValue/NumValue;
            probVal.countType = counterValue;
            probVal.countTotal = NumValue;
            
            listProb = [listProb; probVal];
            
        end
        
    end


end