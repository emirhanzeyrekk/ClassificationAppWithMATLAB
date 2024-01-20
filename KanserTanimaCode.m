clear
clc

imds = imageDatastore('veriSeti', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[imdsTrain1, imdsTest] = splitEachLabel(imds, 0.7, 'randomized');
[imdsTrain, imdsValidation] = splitEachLabel(imdsTrain1, 0.5, 'randomized');

layers = [
    imageInputLayer([227 227 1],"Name","imageinput")
    convolution2dLayer([3 3],8,"Name","conv_1","Padding","same")
    maxPooling2dLayer([2 2],"Name","maxpool_1","Stride",[1 1])
    reluLayer("Name","relu_1")
    convolution2dLayer([3 3],16,"Name","conv_2","Padding","same")
    maxPooling2dLayer([2 2],"Name","maxpool_2","Stride",[1 1])
    reluLayer("Name","relu_2")
    convolution2dLayer([3 3],32,"Name","conv_3","Padding","same")
    fullyConnectedLayer(3,"Name","fc")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")
];

options = trainingOptions('adam', ...
    'MiniBatchSize', 32, ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 0.0001, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', imdsValidation, ...
    'ValidationFrequency', 50, ...
    'Verbose', true, ...
    'Plots', 'training-progress');

net = trainNetwork(imdsTrain,layers,options);
[Ypred,scores] = classify(net,imdsTest);
accuracy = mean(Ypred == imdsTest.Labels);
confusionchart(Ypred,imdsTest.Labels);
save egitimli_agKanserTanima