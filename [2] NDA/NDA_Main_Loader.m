function NDA_Main_Loader()

    load dataMatrix.mat;
    
    listDataNames = ["NP", "CV-1", "CV-2", "CV-3", "CV-4", "CV-5", "CM-R", "CM-G", "CM-B", "CS-R", "CS-G", "CS-B"];
    
    setData_Raw = dataMatrix.setData;
    setData_Raw_Train = dataMatrix.setDataTrain;
    setData_Raw_Dev = dataMatrix.setDataDev;
    setData_Raw_Test = dataMatrix.setDataTest;
    
%     listIdxChosenData = [1, 7, 8, 9, 10, 11, 12];
%     listIdxChosenData = [2, 3, 4, 5, 6];

    listIdxChosenData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

    [~, DEPTH_MAX] = size(listIdxChosenData);
    
    listIdxChosenDataTemp = listIdxChosenData + 1;
    
    [setAll_Converted_Train, setAll_Converted_Dev, setAll_Converted_Test, listRangeIntData]  = NDA_Data_Converter(setData_Raw_Train, setData_Raw_Dev, setData_Raw_Test, listDataNames, 3, listIdxChosenDataTemp);
    
    dataMatrix_Converted.setDataTrain = setAll_Converted_Train;
    dataMatrix_Converted.setDataDev = setAll_Converted_Dev;
    dataMatrix_Converted.setDataTest = setAll_Converted_Test;
    
    dataMatrix_Converted.listRangeIntData = listRangeIntData;
    
    [~, NumIdxChosenData] = size(listIdxChosenData);
    listDataNamesChosen = [];
    
    for idxDataChosen = 1:NumIdxChosenData
        
        idxChosen = listIdxChosenData(idxDataChosen);
        
        listDataNamesChosen = [listDataNamesChosen, listDataNames(idxChosen)];
    end
    
    dataMatrix_Converted.listDataNames = listDataNamesChosen;
    dataMatrix_Converted.DEPTH_MAX = DEPTH_MAX;
    
    save('dataMatrix_Converted','dataMatrix_Converted', '-v7.3');
    
end

