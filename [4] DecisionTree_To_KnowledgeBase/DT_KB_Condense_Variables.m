function [KB_Condensed, listVariableMapping_DT2KB] = DT_KB_Condense_Variables(KB, listVariableUsed_DT)

    [~, NumVariables] = size(listVariableUsed_DT);
    
    IndexMax = max(listVariableUsed_DT);
    
    listVariableMapping_DT2KB = ones(1, IndexMax) * -1;
    
    for idxVar = 1:NumVariables
        
        variable = listVariableUsed_DT(idxVar);
        
        listVariableMapping_DT2KB(variable) = idxVar;
        
    end
    
    KB_Condensed = [];
    
    [~, NumClauses] = size(KB);
    
    for idxClause = 1:NumClauses
        clauses = KB(idxClause).clauses;
        prob = KB(idxClause).prob;
        
        [~, NumVarClause] = size(clauses);
        
        clauses_Condensed = [];
        
        for idxVarClause = 1:NumVarClause
            
            varClause = clauses(idxVarClause);
            
            absVarClause = abs(varClause);
            
            signVar = absVarClause/varClause;
            
            varClause_NoSign = listVariableMapping_DT2KB(absVarClause);
            
            if varClause_NoSign == -1
                asdf = 0;
            end
            
            varClause_Condensed = varClause_NoSign * signVar;
            
            clauses_Condensed = [clauses_Condensed, varClause_Condensed];
            
        end
        
        KB_Condensed(idxClause).clauses = clauses_Condensed;
        KB_Condensed(idxClause).prob = prob;
    end
    
    


end