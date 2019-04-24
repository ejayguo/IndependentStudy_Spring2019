function imDiff_NoiseRemoved_BW = BR_Image_Remove_Noise(imDiff_BW)
    
    imDiff_ST_Filled_BW = imfill(imDiff_BW,'holes');
    
    se = strel('disk',3);
    
    imDiff_STF_Openned_BW = imopen(imDiff_ST_Filled_BW,se);

    imDiff_NoiseRemoved_BW = imDiff_STF_Openned_BW;

end

