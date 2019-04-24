function imDiff_BW = BR_Image_Identify_Difference(imRef_RGB, im_RGB, THRESHOLD_DIFF)


    h = fspecial('gaussian',5,1);
    
    imRef_Smooth = imfilter(double(imRef_RGB), h);
    im_Smooth = imfilter(double(im_RGB), h);
    
    imRef_Gray = double(rgb2gray(imRef_Smooth));
    im_Gray = double(rgb2gray(im_Smooth));
    
    [M,N,~] = size(imRef_RGB);
    
    imDiff_Gray = zeros(M,N);
    
    for m = 1:M
        for n = 1:N
            
            distR = (imRef_Smooth(m,n,1) - im_Smooth(m,n,1))^2;
            distG = (imRef_Smooth(m,n,2) - im_Smooth(m,n,2))^2;
            distB = (imRef_Smooth(m,n,3) - im_Smooth(m,n,3))^2;
%             vIm = im_Smooth(m,n,:);
            
            distAll = sqrt(distR + distG + distB);
            
            if distAll > (THRESHOLD_DIFF*255)
                imDiff_Gray(m,n) = 1;
            end
            
            
            
        end
    end
    
    imDiff_BW = imDiff_Gray;
    

end

