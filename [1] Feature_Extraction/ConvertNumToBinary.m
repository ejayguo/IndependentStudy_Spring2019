function vectorDigits = ConvertNumToBinary(num, NUM_ROOT, LEVEL)

    vectorDigits = [];
    
    
    numComparsion = NUM_ROOT;
    deltaComparsion = NUM_ROOT/2;
    
    for lvl = 1:LEVEL
        
        digit = -1;
        
        if num <= numComparsion
            digit = 0;
            numComparsion = numComparsion - deltaComparsion;
        else
            digit = 1;
            numComparsion = numComparsion + deltaComparsion;
        end
        
        deltaComparsion = deltaComparsion/2;
        vectorDigits = [vectorDigits, digit];
        
        
        
        
        
    end

end