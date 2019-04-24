function [setData_Shuffled, setLabel_Shuffled] = Random_Shuffle_Data_Label(setData, setLabel, NUM_SHUFFLE)
    [NumEx,~] = size(setLabel);
    
    setData_Shuffled = setData;
    setLabel_Shuffled = setLabel;
    
    for idxShuffle = 1:NUM_SHUFFLE
    
        listIdxRand = randperm(NumEx)';
        setData_Shuffled = setData_Shuffled(listIdxRand, :);
        setLabel_Shuffled = setLabel_Shuffled(listIdxRand, :);
        
    end
    
end