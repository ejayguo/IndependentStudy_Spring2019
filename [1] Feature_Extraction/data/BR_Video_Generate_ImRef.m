function imRef = BR_Video_Generate_ImRef(video)

%     imRef = Average_Ref(video);
    
    listImages = Seperate_Video(video);
    
    imRef = Median_Ref(listImages);
    
end

function listImages = Seperate_Video(video)

    listImages = {};
    
    n = 1;
    
    while hasFrame(video)
        
        im_RGB = readFrame(video);
        
        listImages{n} = im_RGB;
                
        n = n + 1;
        
    end
    
    
    
end

function imRef = Median_Ref(listImages)

    imRef_Median = zeros(size(listImages{1}));

    [~,NumImages] = size(listImages);
    
    [M,N,~] = size(listImages{1});
    
    
        
        
        
    for m = [1:M]
        for n = [1:N]
            
            listPixels_R = [];
            listPixels_G = [];
            listPixels_B = [];
            
            for idxImage = [1:NumImages]
                
                image = listImages{idxImage};
                
                pixel_R = image(m,n,1);
                listPixels_R = [listPixels_R, pixel_R];
                        
                pixel_G = image(m,n,2);
                listPixels_G = [listPixels_G, pixel_G];
                
                pixel_B = image(m,n,3);
                listPixels_B = [listPixels_B, pixel_B];
            
            end
            
            medianR = median(listPixels_R);
            medianG = median(listPixels_G);
            medianB = median(listPixels_B);
            
            imRef_Median(m,n,1) = medianR;
            imRef_Median(m,n,2) = medianG;
            imRef_Median(m,n,3) = medianB;

        end
    end
    
                
                
    imRef = uint8(imRef_Median);


    
    
    
end

function imRef = Average_Ref(video)
    imRef = readFrame(video);

    n = 1;
    
    while hasFrame(video)
        
        im_RGB = readFrame(video);
        
        imRef = imRef + im_RGB;
        
        n = n + 1;
        
    end
    
    
    imRef = imRef ./ n;
end