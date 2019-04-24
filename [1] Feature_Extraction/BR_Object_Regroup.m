function listObjects = BR_Object_Regroup(imRef_RGB, im_RGB, listObjectsAll)
    listObjects = listObjectsAll;
    
    [~,NumObjects] = size(listObjects);
    [hasOverlapping, idxObj01, idxObj02] = CheckAnyOverlapping(listObjects);
    
    while hasOverlapping
        listObjectsNew = {};
        IDX_COUNTER = 1;
        
        object01 = listObjects{idxObj01};
        object02 = listObjects{idxObj02};
        
        objectNew = CombineTwoObjects(imRef_RGB, im_RGB, object01, object02);
        
        listObjectsNew{IDX_COUNTER} = objectNew;
        IDX_COUNTER = IDX_COUNTER+1;
        
        for idx = 1:NumObjects
            if idx ~= idxObj01 && idx ~= idxObj02
                
                objectCurrent = listObjects{idx};
                
                listObjectsNew{IDX_COUNTER} = objectCurrent;
                IDX_COUNTER = IDX_COUNTER+1;
            end
            
        end
        
        
        listObjects = listObjectsNew;
        [~,NumObjects] = size(listObjects);
        [hasOverlapping, idxObj01, idxObj02] = CheckAnyOverlapping(listObjects);
        
    end



end

function [hasOverlapping, idxObj01, idxObj02] = CheckAnyOverlapping(listObjects)
    hasOverlapping = 0;
    idxObj01 = -1;
    idxObj02 = -1;
    
    [~,NumObjects] = size(listObjects);
    
    for idx01 = 1:NumObjects
        object01 = listObjects{idx01};
        
        for idx02 = idx01+1:NumObjects
            
            object02 = listObjects{idx02};
            
            
            isOverlapping = CheckOverlapping(object01, object02);
            
            if isOverlapping == 1
                hasOverlapping = 1;
                idxObj01 = idx01;
                idxObj02 = idx02;
                return;
            end
            
            
        end
    end

end

function isOverlapping = CheckOverlapping(object01, object02)
    isOverlapping = 0;

    [mStart01,mEnd01,nStart01,nEnd01] = CalculateMandN(object01);
    xVec01 = [nStart01,nEnd01,nEnd01,nStart01];
    yVec01 = [mStart01, mStart01, mEnd01, mEnd01];
    pgon01 = polyshape(xVec01,yVec01);
    
    [mStart02,mEnd02,nStart02,nEnd02] = CalculateMandN(object02);
    xVec02 = [nStart02,nEnd02,nEnd02,nStart02];
    yVec02 = [mStart02, mStart02, mEnd02, mEnd02];
    pgon02 = polyshape(xVec02,yVec02);
    
    vecPoly = [pgon01, pgon02];
        
    TF = overlaps(vecPoly);
    
    if sum(TF) > 1
        isOverlapping = 1;
    end
    

end

function [mStart,mEnd,nStart,nEnd] = CalculateMandN(object)
    M = object.sizeFrame.M;
    N = object.sizeFrame.N;
    
    bbox = object.boundingbox;
    mStart = bbox.mStart;
    mEnd = mStart + bbox.mSize;
    mEnd = min(M,mEnd);

    nStart = bbox.nStart;
    nEnd = nStart + bbox.nSize;
    nEnd = min(N,nEnd);
end

function objectNew = CombineTwoObjects(imRef_RGB, im_RGB, object01, object02)
    
    [mStart01,mEnd01,nStart01,nEnd01] = CalculateMandN(object01);
    [mStart02,mEnd02,nStart02,nEnd02] = CalculateMandN(object02);
    
    mStartNew = min(mStart01,mStart02);
    mEndNew = max(mEnd01,mEnd02);
    
    nStartNew = min(nStart01,nStart02);
    nEndNew = max(nEnd01,nEnd02);
    
    bboxNew.mStart = mStartNew;
    bboxNew.mSize = mEndNew - mStartNew;
    bboxNew.nStart = nStartNew;
    bboxNew.nSize = nEndNew - nStartNew;
    
    [M,N,~] = size(im_RGB);
    objectNew.image = im_RGB(mStartNew:mEndNew, nStartNew:nEndNew, :);
    objectNew.sizeFrame.M = M;
    objectNew.sizeFrame.N = N;
    objectNew.boundingbox = bboxNew;
    
    objectRefined = BR_Image_Refine(imRef_RGB,objectNew);

    objectNew = BR_Image_Calculate_CenterOfMass(imRef_RGB, objectRefined);
    

end

