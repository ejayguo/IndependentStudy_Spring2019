function labelMax = DT_Find_Most_Common_Label(listLabel)

    listProbLabel = DT_Calculate_Probabilities(listLabel);
    
    [NumLabel,~] = size(listProbLabel);
    
    labelMax = "";
    probMax = -1;
    
    for idxLabel = 1:NumLabel
        probLabel = listProbLabel(idxLabel);
        
        
        if probLabel.prob > probMax
            probMax = probLabel.prob;
            labelMax = probLabel.type;
        end
        
    end
    
end

