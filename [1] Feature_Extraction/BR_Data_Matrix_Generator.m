function [setData, listDataNames] = BR_Data_Matrix_Generator(listFrames)

    setData = [];
    listDataNames = ["NumPts", "Curvature[01]", "Curvature[02]", "Curvature[03]", "Curvature[04]", "Curvature[05]", "ColorMeanR", "ColorMeanG", "ColorMeanB", "ColorStdR", "ColorStdG", "ColorStdB"];
    
    [NumFrames, ~] = size(listFrames);
    
    for idxFrame = 1:NumFrames
        
        frame = listFrames(idxFrame);
        
        frame_Colored = BR_Feature_Color(frame);
        
        frame = frame_Colored;
        
        data = [frame.label, frame.object.NumPixels.num, frame.object.Curvature.fourierCoefficients(1), frame.object.Curvature.fourierCoefficients(2), frame.object.Curvature.fourierCoefficients(3), frame.object.Curvature.fourierCoefficients(4), frame.object.Curvature.fourierCoefficients(5)];
        
        data = [data, frame.object.Color.meanR, frame.object.Color.meanG, frame.object.Color.meanB, frame.object.Color.stdR, frame.object.Color.stdG, frame.object.Color.stdB];
        
        setData = [setData; data];
        
        
        
        
    end


end