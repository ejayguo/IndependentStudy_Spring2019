function [listFrames_Featured] = BR_Feature_Generation_Old(listFrames)

    [NumFrames,~] = size(listFrames);
    
    listFrames_Featured = [];
    
    for idxFrames = 1:NumFrames
        
        vectorFeature = [];
        
        frame = listFrames(idxFrames);
        
        featureCurrent = frame.featureCurrent;
        
        featurePrevious = frame.featurePrevious;
        
        vectorFeature = [featureCurrent.center.numPts, featureCurrent.center.center, featureCurrent.center.meanDist, featureCurrent.center.stdDist]; 
        vectorFeature = [vectorFeature, featureCurrent.cluster01.numPts, featureCurrent.cluster01.center, featureCurrent.cluster01.meanDist, featureCurrent.cluster01.stdDist, featureCurrent.cluster01.distCenterTriangle];
        vectorFeature = [vectorFeature, featureCurrent.cluster02.numPts, featureCurrent.cluster02.center, featureCurrent.cluster02.meanDist, featureCurrent.cluster02.stdDist, featureCurrent.cluster02.distCenterTriangle];
        vectorFeature = [vectorFeature, featureCurrent.cluster03.numPts, featureCurrent.cluster03.center, featureCurrent.cluster03.meanDist, featureCurrent.cluster03.stdDist, featureCurrent.cluster03.distCenterTriangle];
        
        frame.vectorFeatureOne = vectorFeature;
        
        vectorCurrent_Bin = Helper_Generate_Feature_Binary_Digit(featureCurrent);
        
        frame.vectorFeatureOne_Bin = vectorCurrent_Bin;
        
        vectorFeature = [vectorFeature, featurePrevious.center.numPts, featurePrevious.center.center, featurePrevious.center.meanDist, featurePrevious.center.stdDist]; 
        vectorFeature = [vectorFeature, featurePrevious.cluster01.numPts, featurePrevious.cluster01.center, featurePrevious.cluster01.meanDist, featurePrevious.cluster01.stdDist, featurePrevious.cluster01.distCenterTriangle];
        vectorFeature = [vectorFeature, featurePrevious.cluster02.numPts, featurePrevious.cluster02.center, featurePrevious.cluster02.meanDist, featurePrevious.cluster02.stdDist, featurePrevious.cluster02.distCenterTriangle];
        vectorFeature = [vectorFeature, featurePrevious.cluster03.numPts, featurePrevious.cluster03.center, featurePrevious.cluster03.meanDist, featurePrevious.cluster03.stdDist, featurePrevious.cluster03.distCenterTriangle];
        
        frame.vectorFeatureTwo = vectorFeature;
        
        vectorPrevious_Bin = Helper_Generate_Feature_Binary_Digit(featurePrevious);
        
        vectorFeatureTwo_Bin = [vectorCurrent_Bin, vectorPrevious_Bin];
        
        frame.vectorFeatureTwo_Bin = vectorFeatureTwo_Bin;
        
        frame.isEmpty = listFrames(idxFrames).frame.isEmpty;
        
        listFrames_Featured = [listFrames_Featured; frame];
        
    end

end

function vectorMain = Helper_Generate_Feature_Binary_Digit(feature)

%     vectorDigits = ConvertNumToBinary(num, NUM_ROOT, LEVEL);

        vectorMain = [];

        LEVEL = 3;

        ROOT_CENTER_NUM_PTS = 1000;
        
        ROOT_CENTER_POS_M = 240;
        
        ROOT_CENTER_POS_N = 320;
        
        ROOT_CENTER_MEAN_DIST = 100;
        
        ROOT_CENTER_STD_DIST = ROOT_CENTER_MEAN_DIST/2;
    
        vectorDigits = ConvertNumToBinary(feature.center.numPts, ROOT_CENTER_NUM_PTS, LEVEL);
        
        vectorMain = [vectorMain, vectorDigits];
        
        vectorDigits = ConvertNumToBinary(feature.center.center(1), ROOT_CENTER_POS_M, LEVEL);
        
        vectorMain = [vectorMain, vectorDigits];
        
        vectorDigits = ConvertNumToBinary(feature.center.center(2), ROOT_CENTER_POS_N, LEVEL);
        
        vectorMain = [vectorMain, vectorDigits];
        
        vectorDigits = ConvertNumToBinary(feature.center.meanDist, ROOT_CENTER_MEAN_DIST, LEVEL);
        
        vectorMain = [vectorMain, vectorDigits];
        
        vectorDigits = ConvertNumToBinary(feature.center.stdDist, ROOT_CENTER_STD_DIST, LEVEL);
        
        vectorMain = [vectorMain, vectorDigits];
        
        vectorCluster01 = Helper_Generate_Cluster_Feature_Binary_Digit(feature.cluster01);
        vectorCluster02 = Helper_Generate_Cluster_Feature_Binary_Digit(feature.cluster02);
        vectorCluster03 = Helper_Generate_Cluster_Feature_Binary_Digit(feature.cluster03);
        
        vectorMain = [vectorMain, vectorCluster01, vectorCluster02, vectorCluster03];
        
end

function vectorCluster = Helper_Generate_Cluster_Feature_Binary_Digit(cluster)

    vectorCluster = [];

    LEVEL = 3;

    ROOT_NUM_PTS = 500;

    ROOT_POS_M = 240;

    ROOT_POS_N = 320;

    ROOT_MEAN_DIST = 100;

    ROOT_STD_DIST = ROOT_MEAN_DIST/2;
    
    ROOT_DIST_TO_CENTER = 400;
    
    vectorDigits = ConvertNumToBinary(cluster.numPts, ROOT_NUM_PTS, LEVEL);
        
    vectorCluster = [vectorCluster, vectorDigits];
    
    vectorDigits = ConvertNumToBinary(cluster.center(1), ROOT_POS_M, LEVEL);
        
    vectorCluster = [vectorCluster, vectorDigits];
    
    vectorDigits = ConvertNumToBinary(cluster.center(2), ROOT_POS_N, LEVEL);
        
    vectorCluster = [vectorCluster, vectorDigits];
    
    vectorDigits = ConvertNumToBinary(cluster.meanDist, ROOT_MEAN_DIST, LEVEL);
        
    vectorCluster = [vectorCluster, vectorDigits];
    
    vectorDigits = ConvertNumToBinary(cluster.stdDist, ROOT_STD_DIST, LEVEL);
        
    vectorCluster = [vectorCluster, vectorDigits];
    
    vectorDigits = ConvertNumToBinary(cluster.distCenterTriangle, ROOT_DIST_TO_CENTER, LEVEL);
        
    vectorCluster = [vectorCluster, vectorDigits];
                
end