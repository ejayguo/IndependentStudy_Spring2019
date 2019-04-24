function [listKBResults, error] = KB_Nils_KB_Merged_Query(KB_Merged, example_KBinfo, NumVariables, listAtomVariables, VAR_SEPERATOR, TOLERANCE)
    
    KBtemp = KB;
    
    listKBResults = [];
    
    pathValue = example_KBinfo.pathValue;

    [~, NumValues] = size(pathValue);

    for idxValue = 1:NumValues

        value = pathValue(idxValue);

        KBtemp(end+1).clauses = [value];
        KBtemp(end).prob = 1;

    end

    ARRAY_INITIAL = 0.5*ones(NumVariables,1);

    charArrayNameKB_ErrorFuncs = char("KB_Temp_Error_Func" );

    BR_KB2F_ind(KBtemp,charArrayNameKB_ErrorFuncs);

    [listProbAtoms, error, iterProbAtom, iterError] = BR_KB_Jacobian(KBtemp,charArrayNameKB_ErrorFuncs,0.001,TOLERANCE,10000,ARRAY_INITIAL);
    
    

    [~, NumAtoms] = size(listAtomVariables);
    
    probMax = -9999;
    
    for idxAtom = 1:NumAtoms
        
        atom = listAtomVariables(idxAtom);
        
        probAtom = listProbAtoms(atom);
        
        if (probAtom >= probMax)
            probMax = probAtom;
        end
        
    end
    
    for idxAtom = 1:NumAtoms
        
        atom = listAtomVariables(idxAtom);
        
        probAtom = listProbAtoms(atom);
        
        if (probAtom == probMax)
            
            atomResult.atom = atom;
            atomResult.prob = probMax;
            
            listKBResults = [listKBResults, atomResult];
        end
        
    end
    
    

end