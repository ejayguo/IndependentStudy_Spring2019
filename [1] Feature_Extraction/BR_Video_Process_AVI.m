function listFrames = BR_Video_Process_AVI(video, imRef_RGB)
    
    if ~hasFrame(video)
        return;
    end
    
    n = 0;
    
    SizeKernel = 2;
    
    listFrames= [];
    
    mStart = 1;
    mEnd = 400;
    
    nStart = 1;
    nEnd = 450;
    
    imRef_RGB = BR_Image_Cut(imRef_RGB, mStart, mEnd, nStart, nEnd);
    
    [M, N, ~] = size(imRef_RGB);
    
%     im_Cut = im_RGB(200:400, 1:450, :);
    
    while hasFrame(video)
        
        n = n + 1;
        
        im_RGB = readFrame(video);
        
        if n < 10 
            continue;
        end
        
        im_RGB = BR_Image_Cut(im_RGB, mStart, mEnd, nStart, nEnd);
                
        imDiff_BW = BR_Image_Identify_Difference(imRef_RGB, im_RGB, 0.1);

        imDiff_NoiseRemoved_BW = BR_Image_Remove_Noise(imDiff_BW);
        
        [frame] = BR_Image_Extract_Objects(imRef_RGB, im_RGB, imDiff_NoiseRemoved_BW, 100, 0);
        
%         [frame] = BR_Frame_Num_Size_Extract(frame);

        
%         if frame.isEmpty == 0
%             figure(2031);
%             imshow(frame.object.image_Refined);
%         end

        
%         [frame] = BR_Frame_Shape_Curvature_Extract(frame, SizeKernel);
        
        
        
        if frame.isEmpty == 0
%             figure(201);
%             imshowpair(frame.object.image_Refined, frame.object.imageBW_Refined, 'montage');
            
            listFrames = [listFrames; frame];
        end
        
        if n >= 117
            bkpts = 0;
        end
        
        
        
    end
    
%     [listFrames_Featured] = BR_Feature_Generation(listFrames);
    
    
end
