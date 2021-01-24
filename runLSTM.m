txt='StrickyRice.jpg';
.../  180 168 156 144 132 120 109 97//+1
.../  49  37  25  13   1
be=180; ... 168 start year rice /// 180 start normal rice 
numTimeStepsTrain=168; ... 156 start year rice /// 168 start normal rice 
fr=156;

HiddenLayer = 250;
Epochs = 300;
BatchSize = 50000;

round=1;
for n=1:round
    data = readtable('C:\Users\User\Documents\MATLAB\demo\เอาจริง\Final\ราคา\Rice.csv');

    Price = data.Price;
    Price = Price';
  
    dataTrain = Price(408:432);
    dataTest = Price(421-1:432);
    dataTrain;
    input = Price(410-1:420);
  ...  input = Price(fr:numTimeStepsTrain);
    
    mu = mean(dataTrain);
    sig = std(dataTrain);

    dataTrainStandardized = (dataTrain - mu) / sig;

    XTrain = dataTrainStandardized(1:end-1);
    YTrain = dataTrainStandardized(2:end);

    numFeatures = 1;
    numResponses = 1;
    numHiddenUnits = HiddenLayer;

    layers = [ ...
        sequenceInputLayer(numFeatures)
        lstmLayer(numHiddenUnits,'OutputMode','sequence') 
        fullyConnectedLayer(numResponses)
        regressionLayer];

    ... adam  sgdm  rmsprop
    options = trainingOptions('adam', ...
        'MiniBatchSize',BatchSize, ...
        'MaxEpochs',Epochs, ...
        'InitialLearnRate',0.005, ...
        'LearnRateSchedule','piecewise', ...
        'LearnRateDropPeriod',125, ...
        'LearnRateDropFactor',0.2, ...
        'SequenceLength','longest',...
        'Verbose',true, ...
        'Plots','training-progress', ...
        'ExecutionEnvironment', 'gpu');
    
    net = trainNetwork(XTrain,YTrain,layers,options);
    
    data = readtable('C:\Users\User\Documents\MATLAB\demo\เอาจริง\Final\ราคา\Data\อัตราแลกเปลี่ยน.csv');
    
    Exchange = data.Exchange;
    Exchange = Exchange';
    
    XTest = Exchange(50:62);
  ...  XTest = Temp(fr:numTimeStepsTrain);
 ...   YTest = Exchange(numTimeStepsTrain+1:be);
    
    dataTestStandardized = (dataTrain - mu) / sig;
    XTest = dataTestStandardized(1:end-1);
    
    net = resetState(net);
    YPred = predict(net,XTest);   
    YPred = sig*YPred + mu;
    
    .../////////////////////////...
   ... net = trainNetwork(XTrain,YTrain,layers,options);
    
    data = readtable('C:\Users\User\Documents\MATLAB\demo\เอาจริง\Final\ราคา\Data\อัตราดอกเบี้ยเงิน.csv');

   ... Temp = data.Temp;
   ... Temp = Temp';
    Interest = data.Interest;
    Interest = Interest';
    
    XTest = Interest(50:62);
...    XTest = Interest(fr:numTimeStepsTrain);
...    YTest = Interest(numTimeStepsTrain+1:be);

    dataTestStandardized = (dataTrain - mu) / sig;
    XTest = dataTestStandardized(1:end-1);
    
    net = resetState(net);
    YPred = predict(net,XTest);   
    YPred = sig*YPred + mu;
    
    .../////////////////////////...
   ... net = trainNetwork(XTrain,YTrain,layers,options);
    
    data = readtable('C:\Users\User\Documents\MATLAB\demo\เอาจริง\Final\ราคา\Data\ปริมาณเงินหมุนเวียน.csv');
    
   ... Temp = data.Temp;
   ... Temp = Temp';
    Money = data.Money;
    Money = Money';
    
    XTest = Money(50:62);
...    YTest = Money(numTimeStepsTrain+1:be);

    dataTestStandardized = (dataTrain - mu) / sig;
    XTest = dataTestStandardized(1:end-1);
    
    net = resetState(net);
    YPred = predict(net,XTest);   
    YPred = sig*YPred + mu;

    .../////////////////////////...
...    endS = numTimeStepsTrain-fr
...    startS = (endS+1)-12 ... 2y = (endS+1)/2 //3-5y = (endS+1)-12
    
...    testPlot = input(startS:endS);
    y1 = ((input(1:end, 1:end)));  %have to transpose as plot plots columns
    one = plot(y1);
    hold on
...    testPred = YPred(startS:endS);
    y2 = ((YPred(1:end, 1:end))');
    two = plot(y2);
    xlabel("Year-(Month)")
    ylabel("Yield")
    title("Forecast")
    legend(["Observed" "Forecast"])

    graphW = {'G2.jpg','G2.jpg','G3.jpg','G4.jpg','G5.jpg'};
    figW = {'figure_2.fig','figure_2.fig','figure_3.fig','figure_4.fig','figure_5.fig'};
    
    graph = string(graphW(n));
    saveas(one,graph);
    
    figure = string(figW(n));
    saveas(one,figure);
    .../////////////////////////...
        
    fileID = fopen('testest.txt','w');
    fprintf(fileID,'/////////////////////\n');
    fprintf(fileID,'1,%f\n',input);
    fprintf(fileID,'2,%f\n',YPred);

    .../////////////////////////...

    [is] = rmseTest('testest.txt');
    if is==2
        is=1;
    end
    
    ... close all
    ... delete(findall(0));
end