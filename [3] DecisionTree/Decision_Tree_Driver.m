function Decision_Tree_Driver()

    fprintf("\n==================================Decision Tree==================================\n");
   

    Decision_Tree_One_Driver();
    
%     Decision_Tree_Two_Driver();
    
end

function Decision_Tree_One_Driver()
    dataAllTrain = csvread("MatrixOne_Bin_Train.csv");
    
    setLabelTrain_Ori = dataAllTrain(:,1);
    setDataTrain_Unshuffled = dataAllTrain(:,2:end);
    setLabelTrain_Unshuffled = Convert_Label(setLabelTrain_Ori);
    [setDataTrain_Shuffled, setLabelTrain_Shuffled] = Random_Shuffle_Data_Label(setDataTrain_Unshuffled, setLabelTrain_Unshuffled, 100);
    setDataTrain = [setLabelTrain_Shuffled, setDataTrain_Shuffled];
    
    listCV = Generate_CV_Data_Label_Set(setDataTrain_Shuffled, setLabelTrain_Shuffled, 6);
    
    [NumEx, NumCol] = size(setDataTrain);
    listColName = Generate_Dummy_Column_Name(NumCol);
    
%     [avgMaxAccuracy, depthMaxAccuracy] = Decision_Tree_CV(listCV, listColName);

    [nodeRoot, DEPTH_MAX] = DT_ID3(setDataTrain, listColName, depthMaxAccuracy);
        
%     dataAllTest = csvread("MatrixOne_Bin_Test.csv");
%     
%     setLabelTest_Ori = dataAllTest(:,1);
%     
%     setLabelTest_Conv = Convert_Label(setLabelTest_Ori);
%     
%     setDataTest = [setLabelTest_Conv, dataAllTest(:,2:end)];
%     
%     accuracyTest = DT_Identify_Error(nodeRoot, setDataTest);
    

    

end

function listColName = Generate_Dummy_Column_Name(NUM_COL)

    listColName{1} = 'label';
    
    for idx = 2:NUM_COL
        strName = sprintf("feature%d", idx);
        
        listColName{idx} = char(strName);
    end
end
