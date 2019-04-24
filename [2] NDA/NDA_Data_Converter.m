function [setAll_Converted_Train, setAll_Converted_Dev, setAll_Converted_Test, listRangeIntData]  = NDA_Data_Converter(setData_Raw_Train, setData_Raw_Dev, setData_Raw_Test, listDataNames, varAccumulator, listIdxChosenData)

%     setAll = csvread(char(strFileName+".csv"));

    setData_Labeled = Seperate_Data_By_Label(setData_Raw_Train);
% 
%     setAll = setData_Raw;
%     
%     setLabel = setAll(:,1);
%     setData = setAll(:,2:end);
%         
    
    setAll_Converted_Train = [];
    setAll_Converted_Dev = [];
    setAll_Converted_Test = [];
    
    listRangeIntData = [];
    
    
    setLabel_Train = setData_Raw_Train(:,1);
    setLabel_Dev = setData_Raw_Dev(:,1);
    setLabel_Test = setData_Raw_Test(:,1);
    
    [~, NumFeatures] = size(setData_Raw_Train);
    
    [~, NumDataChosen] = size(listIdxChosenData);
    
    idxRangeInt = 1;
    
    for idxDataChosen = 1:NumDataChosen
        
        idxChosen = listIdxChosenData(idxDataChosen);
        
        idxRangeInt = idxRangeInt  + 1;
    
        listThresholds = NDA_One_Attribute(setData_Labeled, idxChosen);
        
        listData_Train = setData_Raw_Train(:,idxChosen);
        listData_Dev = setData_Raw_Dev(:,idxChosen);
        listData_Test = setData_Raw_Test(:,idxChosen);
        
        [NumIntVar,~] = size(listThresholds);
        
        rangeIntData = [1:NumIntVar];
        
        
                
        listData_Converted_Train = NDA_Convert_Real_To_Integer(listData_Train, listThresholds, varAccumulator);
        listData_Converted_Dev = NDA_Convert_Real_To_Integer(listData_Dev, listThresholds, varAccumulator);
        listData_Converted_Test = NDA_Convert_Real_To_Integer(listData_Test, listThresholds, varAccumulator);
        
        
        
        rangeIntData = rangeIntData + varAccumulator;
        
        
        
        varAccumulator = max(rangeIntData);
        
%         varAccumulator = varAccumulator;
        
        
        
        listRangeIntData(idxRangeInt-1).rangeIntData = rangeIntData;
        
        setAll_Converted_Train = [setAll_Converted_Train, listData_Converted_Train];
        setAll_Converted_Dev = [setAll_Converted_Dev, listData_Converted_Dev];
        setAll_Converted_Test = [setAll_Converted_Test, listData_Converted_Test];
        
    end
    
    setAll_Converted_Train = [setLabel_Train, setAll_Converted_Train];
    setAll_Converted_Dev = [setLabel_Dev, setAll_Converted_Dev];
    setAll_Converted_Test = [setLabel_Test, setAll_Converted_Test];
    
end


function setData_Labeled = Seperate_Data_By_Label(setData)

    listLabels = unique(setData(:,1));
    
    [NumLabels] = size(listLabels);
    
    for idxLabel = 1:NumLabels

        label = listLabels(idxLabel);
        
        setDataLabel = setData(setData(:,1) == label, :);
        
        setData_Labeled{label}.label = label;
        
        setData_Labeled{label}.setData = setDataLabel;
        
    end
    
    
end
