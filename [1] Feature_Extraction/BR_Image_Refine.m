function object = BR_Image_Refine(imRGB_Ref, imRGB, object)

    [M_Full,N_Full,~] = size(imRGB_Ref);

    bbox = object.boundingbox;
    
    mStart = bbox.mStart;
    mEnd = mStart+bbox.mSize;
    
    nStart = bbox.nStart;
    nEnd = nStart+bbox.nSize;
    
    mEnd = min(mEnd,M_Full);
    nEnd = min(nEnd,N_Full);
    
    image_Cut = imRGB(mStart:mEnd,nStart:nEnd,:);
    imObj_BW_Cut = object.imageBW(mStart:mEnd,nStart:nEnd,:);
    
    Im_Dummy = imgaussfilt(imObj_BW_Cut,1);
    Im_Dummy = double(Im_Dummy>0);

    Im_Dummy = imfill(Im_Dummy,'holes');
    Im_Dummy = bwmorph(Im_Dummy,'bridge',10);
    imObject_Refined_BW = imfill(Im_Dummy,'holes');
    
    [M,N] = size(imObject_Refined_BW);
    
    imageBW_Refined_Padding = zeros(M+2,N+2);
    
    imageBW_Refined_Padding(2:end-1, 2:end-1) = imObject_Refined_BW(1:end, 1:end);
    
    [MP,NP] = size(imageBW_Refined_Padding);
    
    imObject_Refined_Padding = zeros(MP, NP, 3,'uint8');
    
    for m = 1:M
        for n = 1:N
            if imObject_Refined_BW(m,n) > 0
                imObject_Refined_Padding(m+1,n+1,:) = image_Cut(m,n,:);
            end
        end
    end
    
    
%     imageBW_Refined_Padding = imObject_Refined_Padding~=0;
    
    
    object.image_Refined = imObject_Refined_Padding;
    object.imageBW_Refined = imageBW_Refined_Padding;
end

function Old_Func(imRGB_Ref, imRGB, object)
    [M_Full,N_Full,~] = size(imRGB_Ref);

    bbox = object.boundingbox;
    
    mStart = bbox.mStart;
    mEnd = mStart+bbox.mSize;
    
    nStart = bbox.nStart;
    nEnd = nStart+bbox.nSize;
    
    mEnd = min(mEnd,M_Full);
    nEnd = min(nEnd,N_Full);
    
    imRef_bb = imRGB_Ref(mStart:mEnd,nStart:nEnd,:);
    im_bb = imRGB(mStart:mEnd,nStart:nEnd,:);
    
    imRef_Gray =  double(rgb2gray(imRef_bb));
    im_Gray = double(rgb2gray(im_bb));
    
    imDiff_Gray= abs(imRef_Gray-im_Gray);
    
    imChecked = zeros(size(im_bb),'uint8');
    
    for m = 1:object.boundingbox.mSize
        for n = 1:object.boundingbox.nSize
            
            if imDiff_Gray(m,n) > 0.1
                imChecked(m,n,:) = object.image(mStart+m-1,nStart+n-1,:);
            end
            
        end
    end
    
%     figure(2031);
%     imshow(imChecked);
    
    imChecked_Gray = rgb2gray(imChecked);
        
    imBinary = imbinarize(imChecked_Gray,'adaptive','ForegroundPolarity','dark','Sensitivity',0.4);
    
    imBin_Filled = imfill(imBinary,'holes');
    
    imBin_Filled = bwmorph(imBin_Filled,'bridge',10);
    
    imBin_Filled = imfill(imBin_Filled,'holes');
            
    im_Refined = zeros(size(im_bb),'uint8');
    im_Refined_BW = zeros(size(im_Gray));
    

        
        
    listColorPixels = [];
    listColorPixels_HSV = [];
    for m = 1:bbox.mSize
        for n = 1:bbox.nSize
            
            if imBin_Filled(m,n) == 1
                
                im_Refined(m,n,:) = im_bb(m,n,:);
                
                im_Refined_BW(m,n) = 1;

            end
            
        end
    end

%     imshow(im_Refined);
    
    object.image_Refined = im_Refined;
    object.imageBW_Refined = im_Refined_BW;

end

