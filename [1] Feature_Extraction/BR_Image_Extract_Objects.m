function [frame] = BR_Image_Extract_Objects(imRef_RGB, im_RGB, imDiff_NoiseRemoved_BW, MIN_NUM_PIXELS, debug)

    frame.isEmpty = 1;
    frame.label = 0;
    
    [M,N,~] = size(imDiff_NoiseRemoved_BW);
    
    imDiff_Region = regionprops(imDiff_NoiseRemoved_BW, 'centroid');
    
    [labeled, numObjects] = bwlabel(imDiff_NoiseRemoved_BW);
    
    stats = regionprops(labeled, 'Eccentricity', 'Area', 'BoundingBox');
    
    areas = [stats.Area];
    
    eccentricities = [stats.Eccentricity];
    
    idxOfSkittles = find(eccentricities);
    
    statsDefects = stats(idxOfSkittles);
    
    [~,numGroups] = size(idxOfSkittles);
    
%     if debug == 1
%         subplot(3,1,1)
%         imshow(im_RGB);
%         hold on;
%         for idx = 1 : numGroups
%                 h = rectangle('Position',statsDefects(idx).BoundingBox,'LineWidth',2);
%                 set(h,'EdgeColor',[.75 0 0]);
%                 hold on;
%         end
% 
%         hold off;
%     end
    
%     imshow(imDiff_STF_Openned_Gray);
    imObjects = im_RGB;
    
%     listObjects = cell(numGroups,1);
    
    [M,N,~] = size(im_RGB);
    
    numPixelsMax = -Inf;
    objectMax = 0;
    
    for idx = 1:numGroups
        bbox = statsDefects(idx).BoundingBox;
        
        mStart = round(bbox(2));
        mSize = round(bbox(4));
        mEnd = mStart+mSize;
        mStart = ClipNumber(mStart, 1, M);
        mEnd = ClipNumber(mEnd, 1, M);

        
        nStart = round(bbox(1));
        nSize = round(bbox(3));
        nEnd = nStart + nSize;
        nStart = ClipNumber(nStart, 1, N);
        nEnd = ClipNumber(nEnd, 1, N);
        
%         imObj = im_RGB(mStart:mEnd,nStart:nEnd,:);

        listPts = [];

        imObj = zeros(size(im_RGB),'uint8');
        
        imObj_BW = zeros(size(imDiff_NoiseRemoved_BW));

        for m = mStart:mEnd
            for n = nStart:nEnd

                if imDiff_NoiseRemoved_BW(m,n) ~= 0

                    imObj(m,n,:) = im_RGB(m,n,:);
                    
                    imObj_BW(m,n) = imDiff_NoiseRemoved_BW(m,n);
                    
                    listPts = [listPts; m, n];

                end

            end
        end
        
        [numPixels, ~] = size(listPts);
        
        if numPixels > numPixelsMax
            
            if numPixels > MIN_NUM_PIXELS

                object.image = imObj;
                object.imageBW = imObj_BW;
                object.NumPixels.num = numPixels;
                object.NumPixels.listPts = listPts;
                object.NumPixels.center = mean(listPts);
                object.boundingbox.mStart = mStart;
                object.boundingbox.mSize = mSize;
                object.boundingbox.nStart = nStart;
                object.boundingbox.nSize = nSize;

                object = BR_Image_Refine(imRef_RGB, im_RGB, object);

                frame.isEmpty = 0;
                frame.object = object;
                
                numPixelsMax = numPixels;
                
            end
            
        end
        

            
       
        
    end

end

function numUpdated = ClipNumber(number, num_min, num_max)
        numUpdated = number;
        numUpdated = min([num_max,numUpdated]);
        numUpdated = max([num_min,numUpdated]);

end

