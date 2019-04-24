function KnowledgeBase_Merged = KB_Nils_Merge_KB(KnowledgeBase01, KnowledgeBase02, listVariables)

    [~, NumAtoms] = size(listVariables);
    
    listVarUsed01_DT = KnowledgeBase01.DecisionTree.listVariableUsed_DT;
    varSeperator = max(listVarUsed01_DT);
    
    KB01 = KnowledgeBase01.KB;

    KB02 = KnowledgeBase02.KB;
    
    KB02_New = [];
    
    [~, NumClauses02] = size(KB02);
    
    for idxClause = 1:NumClauses02
        
        clause = KB02(idxClause).clauses;
        prob = KB02(idxClause).prob;
        
        [~, NumVarClause] = size(clause);
        
        clauseNew = [];
        
        for idxVarClause = 1:NumVarClause
            
            varClause = clause(idxVarClause);
            
            isAtom = sum(listVariables == varClause);
            
            if isAtom == 1
                
                clauseNew = [clauseNew, varClause];
                
            else
                
                
                absVarClause = abs(varClause);
                
                
            
                signVarClause = absVarClause/varClause;
                
                absVarClauseNew = absVarClause + varSeperator;
                
                varClauseNew = signVarClause*absVarClauseNew;
                
                clauseNew = [clauseNew, varClauseNew];
                
            end
            

            
            
            
        end
        
        
        KB02_New(idxClause).clauses = clauseNew;
        KB02_New(idxClause).prob = prob;
        
    end
    
    
    
    KB_New = [KB01, KB02_New];
    
    
    
    listVarUsed02_DT = KnowledgeBase02.DecisionTree.listVariableUsed_DT;
    
    listVarused02_DT_New = listVarUsed02_DT(NumAtoms+1:end) + varSeperator;
    
    KnowledgeBase_Merged.KB = KB_New;
    
    listVariableUsed_DT_New = [listVarUsed01_DT, listVarused02_DT_New];
    
    [KB_Condensed_New, listVariableMapping_DT2KB_New] = KB_Nils_Merge_Condense_Variables(KB_New, listVariableUsed_DT_New);
    
    
    KnowledgeBase_Merged.KB_Condensed = KB_Condensed_New;
    KnowledgeBase_Merged.listVariableMapping_DT2KB = listVariableMapping_DT2KB_New;
    KnowledgeBase_Merged.varSeperator = varSeperator;
    KnowledgeBase_Merged.DecisionTree01 = KnowledgeBase01.DecisionTree;
    KnowledgeBase_Merged.DecisionTree02 = KnowledgeBase02.DecisionTree;
    


end