function matrixData = BR_Matrix_Generator(listFrames)

    [NumFrames,~] = size(listFrames);
    
    listFrames_Featured = [];
    
    matrixOneEx = [];
    matrixOneEx_Bin = [];
    matrixTwoEx = [];
    matrixTwoEx_Bin = [];
    
    
    
    for idxFrames = 1:NumFrames
        
        frame = listFrames(idxFrames);
        
        label = 0;
        
        if frame.isEmpty == 1
            label = 0;
        else
            label = frame.frame.label;
        end
        
        vecFOne = frame.vectorFeatureOne;
        matrixOneEx = [matrixOneEx; label, vecFOne];
        
        vecFOne_Bin = frame.vectorFeatureOne_Bin;
        matrixOneEx_Bin = [matrixOneEx_Bin; label, vecFOne_Bin];
        
        vecFTwo = frame.vectorFeatureTwo;
        matrixTwoEx = [matrixTwoEx; label, vecFTwo];
        
        vecFTwo_Bin = frame.vectorFeatureTwo_Bin;
        matrixTwoEx_Bin = [matrixTwoEx_Bin; label, vecFTwo_Bin];
        
    end
    
    matrixData.matrixOneEx = matrixOneEx;
    matrixData.matrixOneEx_Bin = matrixOneEx_Bin;
    matrixData.matrixTwoEx = matrixTwoEx;
    matrixData.matrixTwoEx_Bin = matrixTwoEx_Bin;


end