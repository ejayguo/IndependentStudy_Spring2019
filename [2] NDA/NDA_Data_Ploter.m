function NDA_Data_Ploter(setData_Labeled, idxChosen)
    
    [~,NumLabel] = size(setData_Labeled);
    
    listMean = [];
    listStd = [];
    
    for idxLabel = 1:NumLabel
        
        setData = setData_Labeled{idxLabel}.setData;
        
        meanData = mean(setData(:,idxChosen));
        stdData = std(setData(:,idxChosen));
        
        listMean = [listMean; meanData];
        listStd = [listStd; stdData];
        
    end
    
%     x = [:200];
    
    listY = [];
    
    for idxLabel = 1:NumLabel
        meanTest = listMean(idxLabel);
        stdTest = listStd(idxLabel);
        y = 1000*normpdf(x,meanTest,stdTest);
        listY = [listY; y];
    end
        
    figure(1322);
    plot(x,listY(1),'r',x,listY(2),'g',x,listY(3),'b');

end