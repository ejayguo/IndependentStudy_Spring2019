function listCV = Generate_CV_Data_Label_Set(setDataAll, setLabelAll, NUM_CV)
    [NumEx, ~] = size(setLabelAll);
    
    intervalCV = NumEx / NUM_CV;
    
    listBegin = [];
    listEnd = [];
    
    for idxCV = 1:NUM_CV
        idxBegin = 1 + intervalCV * (idxCV - 1);
        listBegin = [listBegin, idxBegin];
        
        idxEnd = intervalCV * idxCV;
        listEnd = [listEnd, idxEnd];
        
    end
        
    listCV = {};
    
    listDataTrain = [];
    listLabelTrain = [];
    listDataTest = [];
    listLabelTest = [];
    
    for idxTest = 1:5
        idxTestBegin = listBegin(idxTest);
        idxTestEnd = listEnd(idxTest);
        
        setDataTest = setDataAll(idxTestBegin:idxTestEnd,:);
        setLabelTest = setLabelAll(idxTestBegin:idxTestEnd,:);
        
        setDataTrain = [];
        setLabelTrain = [];
        for idxTrain = 1:5
            
            if (idxTrain ~= idxTest)
                idxTrainBegin = listBegin(idxTrain);
                idxTrainEnd = listEnd(idxTrain);
                
                setDataTrain = [setDataTrain; setDataAll(idxTrainBegin:idxTrainEnd,:)];
                setLabelTrain = [setLabelTrain; setLabelAll(idxTrainBegin:idxTrainEnd,:)];
            end
            
            
        end
        
        cv.setDataTrain = setDataTrain;
        cv.setLabelTrain = setLabelTrain;
        cv.setDataTest = setDataTest;
        cv.setLabelTest = setLabelTest;
        
        listCV{idxTest} = cv;
    end
    


end