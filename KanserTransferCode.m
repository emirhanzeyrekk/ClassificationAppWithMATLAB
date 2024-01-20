clear
clc

fpath = '/Users/emirhanzeyrek/Documents/MATLAB/LessonTrain';
data = fullfile(fpath, 'veriSeti');
tdata = imageDatastore(data, 'IncludeSubfolders', true, 'LabelSource', 'foldername');

tdata = shuffle(tdata);

[trainRatio, valRatio, testRatio] = deal(0.7, 0.15, 0.15);
[trainingData, validationData, testData] = splitEachLabel(tdata, trainRatio, valRatio, testRatio, 'randomized');

net=alexnet;
layers=[
    imageInputLayer([227 227])
    net(2:end-3)
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer()
    ];

options=trainingOptions( ...
    'sgdm', ...
    'MiniBatchSize', 32, ...
    'MaxEpochs',30, ...
    'InitialLearnRate',0.0001, ...
    'ValidationFrequency', 50, ...
    'Plots', ... 
    'training-progress' ... 
    );

net = trainNetwork(trainingData,layers,options);
[Ypred,scores] = classify(net,testData);
accuracy = mean(Ypred == testData.Labels);
confusionchart(Ypred,testData.Labels);
save egitimli_agKanserTransfer