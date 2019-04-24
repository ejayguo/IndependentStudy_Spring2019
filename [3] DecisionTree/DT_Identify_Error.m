function accuracy = DT_Identify_Error(nodeRoot, listData)

    listLabel = listData(:,1);
    listExamples = listData(:,2:end);
    
    [NumExample,~] = size(listLabel);
    
    counterHit = 0;
    
    for idx = 1:NumExample
        
        labelCurrent = listLabel(idx);
        exampleCurrent = listExamples(idx,:);
                
        labelEx = DT_Query(nodeRoot, exampleCurrent);
        isHit = (labelCurrent == labelEx);
        
        
        counterHit = counterHit + isHit;
        
    end
    

    accuracy = counterHit/NumExample;

end




