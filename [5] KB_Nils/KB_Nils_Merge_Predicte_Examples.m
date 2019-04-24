function [setData_KB, accuracyAbs, accuracy, counterError] = KB_Nils_Merge_Predicte_Examples(KB_Merged, setData_KB_NotPredicted, NumVariables, listAtomVariables)

    TOLERANCE = 0.001;
    
    setData_KB = [];
    
    setData01 = setData_KB_NotPredicted.setData01;
    setData02 = setData_KB_NotPredicted.setData02;

    [NumEx, ~] = size(setData01);
        
    counterTotal = NumEx;
    counterAbsPos = 0;
    counterPos = 0;
    counterError = 0;
    
    setValuePath01 = setData_KB_NotPredicted.setValuePath01_Condensed;
    setValuePath02 = setData_KB_NotPredicted.setValuePath02_Condensed;
    
    for idxEx = 1:NumEx
        
        labelTruth = setData01(idxEx, 1);
        
        pathValue = [];
        
        pathValue01 = [pathValue, setValuePath01{idxEx}];
        
        pathValue02 = [pathValue, setValuePath02{idxEx}];
        
        example_KBinfo.pathValue = [pathValue01, pathValue02];
        
        [listKBResults, error] = KB_Nils_KB_Query(KB_Merged, example_KBinfo, NumVariables, listAtomVariables, TOLERANCE);
        
        setData_KB(idxEx).listLabelPredicted = listKBResults;
        setData_KB(idxEx).error = error;
        
        
        
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