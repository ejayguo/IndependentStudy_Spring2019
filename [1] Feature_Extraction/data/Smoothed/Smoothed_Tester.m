function Smoothed_Tester()

    load frameCar.mat
    
    frameCar = frame;
    
    load frameBus.mat
    
    frameBus = frame;
    
    load frameTruck.mat
    
    frameTruck = frame;
    
    figure(332);
    
    
%     [hCar] = histogram(frameCar.data.listCurvature,'Normalization','probability');
    [hCar,edgesCar] = histcounts(frameCar.data.listCurvature, 'Normalization', 'probability');
    
    
%     hold on
%     hBus = histogram(frameBus.data.listCurvature,'Normalization','probability');
    [hBus,edgesBus] = histcounts(frameBus.data.listCurvature, 'Normalization', 'probability');
%     bar(hBus);
%     hold on
%     hTruck = histogram(frameTruck.data.listCurvature,'Normalization','probability');
    [hTruck,edgesTruck] = histcounts(frameTruck.data.listCurvature, 'Normalization', 'probability');
%     bar(hTruck);

    listDegrees = edgesTruck(1:end-1);   % Create Centres
    bar(listDegrees, [hCar; hBus; hTruck]');
%     hold off

end