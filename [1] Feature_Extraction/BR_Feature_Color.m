function frame = BR_Feature_Color(frame)

    image = frame.object.image_Refined;
    
    listPts = frame.object.NumPixels.listPts;
    
    listR = [];
    listG = [];
    listB = [];
    
    [NumPts, ~] = size(listPts);
    
    [M, N, ~] = size(image);
    
    for m = 1:M
        
        for n = 1:N
            
            rColor = image(m,n,1);
            gColor = image(m,n,2);
            bColor = image(m,n,3);
            
            if rColor ~= 0 && gColor ~= 0 && bColor ~= 0
                
                listR = [listR; rColor];
                listG = [listG; gColor];
                listB = [listB; bColor];
                
            end
            
            
            
            
        end
    end
        
    frame.object.Color.listR = listR;
    frame.object.Color.listG = listG;
    frame.object.Color.listB = listB;
    frame.object.Color.meanR = mean(double(listR));
    frame.object.Color.meanG = mean(double(listG));
    frame.object.Color.meanB = mean(double(listB));
    frame.object.Color.stdR = std(double(listR));
    frame.object.Color.stdG = std(double(listG));
    frame.object.Color.stdB = std(double(listB));
    
           



end