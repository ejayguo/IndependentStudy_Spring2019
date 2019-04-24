function [setData01, setData02, setData03] = BR_Data_Matrix_Seperate_By_Label(setDataAll)


    setData01 = setDataAll(setDataAll(:,1) == 1);
    setData02 = setDataAll(setDataAll(:,1) == 2);
    setData03 = setDataAll(setDataAll(:,1) == 3);
    
    
    

end