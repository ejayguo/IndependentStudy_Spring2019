function [listInfoGain, idxCol_Max, infoGain_Max]  = DT_Calculate_Information_Gain(listLabel, listExamples, listIdxColUsed)
    [NumEx, NumCol] = size(listExamples);
    
    entropyLabel =  DT_Calculate_Entropy(listLabel);
    
    listInfoGain = [];
    infoGain_Max = -9999;
    idxCol_Max = 0;
    
    
    for idxCol = 1:NumCol
        
        if sum(listIdxColUsed == idxCol) == 0
            
            listAttributeValue = listExamples(:,idxCol);
            
            infoGain = DT_Calculate_One_Information_Gain(listLabel, listAttributeValue);
            
            infoCol.gain = infoGain;
            infoCol.idx = idxCol;
            
            if infoGain >= infoGain_Max
                infoGain_Max = infoGain;
                idxCol_Max = idxCol;
            end
            
            listInfoGain = [listInfoGain; infoCol];
            
        end
        
    end
    
    

end

