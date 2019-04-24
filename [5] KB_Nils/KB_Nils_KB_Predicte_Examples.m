function [setData_DT_KB, accuracyAbs, accuracy, counterError] = KB_Nils_KB_Predicte_Examples(KB, setData_DT_KB_NotPredicted, NumVariables, listAtomVariables)

    TOLERANCE = 0.001;
    
    setData_DT_KB = setData_DT_KB_NotPredicted;

    [~, NumEx] = size(setData_DT_KB_NotPredicted);
    
        
    listRandomIndex = randperm(NumEx);

    setDataRand = setData_DT_KB_NotPredicted(listRandomIndex);
        
    counterTotal = NumEx;
    counterAbsPos = 0;
    counterPos = 0;
    counterError = 0;
    
    for idxEx = 1:NumEx
        
        labelTruth = setDataRand(idxEx).LABEL;
        
        example_KBinfo = setDataRand(idxEx).KB;
        
        [listKBResults, error] = KB_Nils_KB_Query(KB, example_KBinfo, NumVariables, listAtomVariables, TOLERANCE);
        
        setData_DT_KB(idxEx).KB.listLabelPredicted = listKBResults;
        setData_DT_KB(idxEx).KB.error = error;
        
        
        
        if error > TOLERANCE
            counterError = counterError + 1;
        end
        
        [~, NumResults] = size(listKBResults);

        if NumResults == 1

            labelPredicted = listKBResults(1).atom;

            if (labelPredicted == labelTruth)
                counterPos = counterPos + 1;
                counterAbsPos = counterAbsPos + 1;
            end

        else

            listlabelsPredicted = [];

            for idxResult = 1:NumResults
                listlabelsPredicted =  [listlabelsPredicted, listKBResults(idxResult).atom];
            end

            isPos = sum(listlabelsPredicted == labelTruth) > 0;

            if isPos
                counterPos = counterPos + 1;
            end

        end
        
        idxEx
        counterPos
        
    end
    
    accuracyAbs = counterAbsPos / counterTotal;
    accuracy = counterPos / counterTotal;
    


end