function [setDataTrain, setDataDev, setDataTest] = BR_Data_Matrix_Seperate_To_Training_Developing_Testing(setDataAll, sizeTrain, sizeDev, sizeTest)

%     random_x = x(randperm(size(x, 1)), :)
    
    setDataTrain = [];
    setDataDev = [];
    setDataTest = [];
    
    setDataTemp = setDataAll;
    
    for idxTest = 1:sizeTest
        
        [NumExTemp , ~] = size(setDataTemp);
        
        listRandomIndex = randperm(NumExTemp);
        
        setDataRand = setDataTemp(listRandomIndex, :);
        
        exampleRand = setDataRand(1,:);
        
        setDataTest = [setDataTest; exampleRand];
        
        setDataRand(1,:) = [];
        
        setDataTemp = setDataRand;
        
    end
    
    for idxDev = 1:sizeDev
        
        [NumExTemp , ~] = size(setDataTemp);
        
        listRandomIndex = randperm(NumExTemp);
        
        setDataRand = setDataTemp(listRandomIndex, :);
        
        exampleRand = setDataRand(1,:);
        
        setDataDev = [setDataDev; exampleRand];
        
        setDataRand(1,:) = [];
        
        setDataTemp = setDataRand;
        
    end
    
    setDataTrain = setDataTemp;


end