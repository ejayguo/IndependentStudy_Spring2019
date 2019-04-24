function NDA_Tester()
    
    x = [1:200];
    
    meanTest01 = 50;
    stdTest01 = 20;
    y01 = 1000*normpdf(x,meanTest01,stdTest01);

    meanTest02 = 100;
    stdTest02 = 30;
    y02 = 1000*normpdf(x,meanTest02,stdTest02);
    
    meanTest03 = 150;
    stdTest03 = 25;
    y03 = 1000*normpdf(x,meanTest03,stdTest03);
    
    meanTest04 = 200;
    stdTest04 = 15;
    y04 = 1000*normpdf(x,meanTest04,stdTest04);
    
    figure(1322);
    plot(x,y01,'r',x,y02,'g',x,y03,'b',x,y04,'m');
    
    setData01 = [1*ones(200,1), y01'];
    setData02 = [2*ones(200,1), y02'];
    setData03 = [3*ones(200,1), y03'];
    setData04 = [4*ones(200,1), y04'];
    
    setData_Raw = [ setData01; setData02; setData03; setData04];
    
    setAll_Converted = NDA_Data_Converter(setData_Raw);
    

end