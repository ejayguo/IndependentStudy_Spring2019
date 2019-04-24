function listThresholds_Refined = NDA_One_Attribute(setData_Labeled, idxChosen)

    listThresholds = [];
    
    [~, NumLabels] = size(setData_Labeled);
    
%     NDA_Data_Ploter(setData_Labeled, idxChosen);
    
    
    for idxLabelPos = 1:NumLabels-1
        
        setDataPos = setData_Labeled{idxLabelPos}.setData;
        
        setDataNeg = [];
        
        for idxLabelNeg = idxLabelPos+1:NumLabels
            
            setDataNeg = [setDataNeg; setData_Labeled{idxLabelNeg}.setData];
            
        end
        
        listThresholds_Label = Binary_Normal_Distribution_Analysis(setDataPos, setDataNeg, idxChosen);
        
        listThresholds = [listThresholds; listThresholds_Label];
        
    end
    

    listThresholds_Sorted = sort(listThresholds);
    
    listThresholds_Refined = Regroup_Thresholds(listThresholds_Sorted, 5);


    
end

function listThresholds_Sorted = Binary_Normal_Distribution_Analysis(setDataPos, setDataNeg, idxChosen)

    listNumbersPos = setDataPos(:,idxChosen);
    listNumbersNeg = setDataNeg(:,idxChosen);
    
    meanPos = mean(listNumbersPos);
    stdPos = std(listNumbersPos);
    
    meanNeg = mean(listNumbersNeg);
    stdNeg = std(listNumbersNeg);
    
    listPos_Sorted = sort(listNumbersPos);
    listNeg_Sorted = sort(listNumbersNeg);
    
    normPos = normpdf(listPos_Sorted,meanPos,stdPos);
    normNeg = normpdf(listNeg_Sorted,meanNeg,stdNeg);
    
    [intervalMin, intervalMax] = Find_Overlapping_Section(listPos_Sorted, normPos, listNeg_Sorted,normNeg);
    
    [listThresholds,listProbThresholds,iout,jout] = intersections(listPos_Sorted,normPos,listNeg_Sorted,normNeg,1);
    
    listThresholds_Sorted = sort(listThresholds);
    
    if intervalMin.label ~= -999
        listThresholds_Sorted = [intervalMin.range(2); listThresholds_Sorted];
    else
        listThresholds_Sorted = [intervalMin.range(1); listThresholds_Sorted];
    end
    
    if intervalMax.label ~= -999
        listThresholds_Sorted = [listThresholds_Sorted; intervalMax.range(1); intervalMax.range(2)];
    else
        listThresholds_Sorted = [listThresholds_Sorted; intervalMax.range(2)];
    end

end



function [intervalMin, intervalMax] = Find_Overlapping_Section(listPos_Sorted, normPos, listNeg_Sorted,normNeg)
    minPos = min(listPos_Sorted);
    maxPos = max(listPos_Sorted);
    
    minNeg = min(listNeg_Sorted);
    maxNeg = max(listNeg_Sorted);
    
    intervalMin.range = [0,0];
    intervalMin.label = -999;
    
    if minPos < minNeg
        intervalMin.range = [minPos, minNeg];
        intervalMin.label = 1;
    elseif minNeg < minPos
        intervalMin.range = [minNeg, minPos];
        intervalMin.label = 0;
    else
        intervalMin.range = [minPos, minPos];
    end
    
    intervalMax.range = [0,0];
    intervalMax.label = -999;
    
    if maxPos > maxNeg
        intervalMax.range = [maxNeg, maxPos];
        intervalMax.label = 1;
    elseif maxNeg > maxPos
        intervalMax.range = [maxPos, maxNeg];
        intervalMax.label = 0;
    else
        intervalMax.range = [maxPos, maxPos];
    end
    
    
end

function Find_Intersection_Point(listPos_Sorted, normPos, listNeg_Sorted,normNeg, intervalMin, intervalMax)

    intervalStart = intervalMin.range(2);
    intervalEnd= intervalMax.range(1);
    

    [NumPos,~] = size(listPos_Sorted);
    
    [NumNeg,~] = size(listNeg_Sorted);
    
    NumIter = min([NumPos, NumNeg]);
    
    for idxIter = 1:NumIter
        
        probPos = normPos(idxIter);
        
        probNeg = normNeg(idxIter);
        
        
        
    end
    
end

function listThresholds_Refined = Regroup_Thresholds(listThresholds_Sorted, NumClusters)

%     deltaMax = -Inf;
%     
%     [NumThresholds, ~] = size(listThresholds_Sorted);
%     
%     for idxThresholds = 1:NumThresholds-1
%         
%         thresholdsPre = listThresholds_Sorted(idxThresholds);
%         thresholdsNext = listThresholds_Sorted(idxThresholds+1);
%         
%         delta = thresholdsNext - thresholdsPre;
%         
%         if delta > deltaMax
%             deltaMax = delta;
%         end
%         
%     end
    
%     histogram(listThresholds_Sorted);

    [NumThresholds,~] = size(listThresholds_Sorted);
    
    listIdxCluster = kmeans(listThresholds_Sorted, NumClusters);
    
    listCluster = cell(NumClusters);
    
    for idxCluster = 1:NumClusters
        
        cluster.listValue = [];
        
        listCluster{idxCluster} = cluster;
        
    end
    
    
    for idxThreshold = 1:NumThresholds

        thresholds = listThresholds_Sorted(idxThreshold);
        
        idxCluster = listIdxCluster(idxThreshold);
        
        listCluster{idxCluster}.listValue = [listCluster{idxCluster}.listValue; thresholds];

    end
    
    
    listThresholds_Regrouped = [];
    
    for idxCluster = 1:NumClusters
        
%         threshold = median(listCluster{idxCluster}.listValue);
        threshold = max(listCluster{idxCluster}.listValue);
        
        listThresholds_Regrouped = [listThresholds_Regrouped; threshold];
        
    end
    
    listThresholds_Refined = sort(listThresholds_Regrouped);

end

