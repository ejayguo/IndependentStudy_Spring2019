function [frame] = BR_Frame_Shape_Curvature_Extract(frame, SizeKernel)

    if frame.isEmpty == 0

        imObject_BW = frame.data.imageBW;
        
        imObject_BW_Refined = BR_Refine_Contour(imObject_BW);
        
        imObject_BW = imObject_BW_Refined;

        imObject_Edge = edge(imObject_BW,'Canny');

        [imGMag, imGDir] = imgradient(imObject_Edge,'prewitt');

        [M, N] = size(imObject_Edge);

        imCurvature = ones(M,N) * Inf;

        listCurvature = [];

        for m = 1:M
            for n = 1:N

                listGDir = [];

                for idxMKernel = -SizeKernel : SizeKernel

                    idxM = m + idxMKernel;

                    for idxNKernel = -SizeKernel : SizeKernel

                        idxN = n + idxNKernel;

                        if (idxM > 0 && idxM <= M) && (idxN > 0 && idxN <= N) 

                            gra = imGDir(idxM,idxN);

                            listGDir = [listGDir; gra];

                        end
                    end

                end

                gMin = min(listGDir);
                gMax = max(listGDir);

                deltaG = gMax - gMin;

                if (deltaG > 180)
                    deltaG = 2*180 - deltaG;
                end
                
                imCurvature(m,n) = deltaG;
                
                if sum(listGDir>0) > 0

                    listCurvature = [listCurvature; deltaG];
                
                end
                
                

            end
        end

        frame.data.imCurvature = imCurvature;
        frame.data.listCurvature = listCurvature;
        frame.data.imageBW = imObject_BW;
        
        
        figure(111);
        hist(frame.data.listCurvature);

    end
end

function imObject_BW_Refined = BR_Refine_Contour(imObject_BW)

    Im_Dummy = imgaussfilt(imObject_BW,1);
    Im_Dummy = double(Im_Dummy>0);

    Im_Dummy = imfill(Im_Dummy,'holes');
    Im_Dummy = bwmorph(Im_Dummy,'bridge',10);
    imObject_BW_Refined = imfill(Im_Dummy,'holes');
end

