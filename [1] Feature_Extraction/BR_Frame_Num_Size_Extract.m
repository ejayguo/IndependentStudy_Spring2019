function [frame] = BR_Frame_Num_Size_Extract(frame)
    
    if frame.isEmpty == 0
        
        imObject = zeros(size(im_RGB), 'uint8');

        [M, N,~] = size(im_RGB);

        listPts = [];

        for m = 1:M
            for n = 1:N

                if imDiff_BW(m,n) > 0

                    listPts = [listPts; m,n];
                    imObject(m,n,:) = im_RGB(m,n,:);

                end

            end
        end


        [NumPts, ~] = size(listPts);

        if NumPts > 2

            center = mean(listPts);

            if (center(1) > minM && center(1) < maxM) && (center(2) > minN && center(2) < maxN)

                frame.isEmpty = 0;
                frame.data.image = imObject;
                frame.data.imageBW = imDiff_BW;
                frame.data.NumPixels.num = NumPts;
                frame.data.NumPixels.listPts = listPts;
                frame.data.center = mean(listPts);

            end





        end
        
    end

    
      

    
end

