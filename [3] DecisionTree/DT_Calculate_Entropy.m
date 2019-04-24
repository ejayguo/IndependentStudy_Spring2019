function entropyRtn = DT_Calculate_Entropy(listAttributeValue)

    entropyRtn = 0;
    
    listProb = DT_Calculate_Probabilities(listAttributeValue);
    
    [NumType,~] = size(listProb);
    
    listEntropies = [];
    
    for idxType = 1:NumType
        
        probVal = listProb(idxType);
        prob = probVal.prob;
        entropyCurrent = -prob*log2(prob);
        
        listEntropies = [listEntropies; entropyCurrent];
        
        
    end

    entropyRtn = sum(listEntropies);

end
