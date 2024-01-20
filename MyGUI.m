function myGUI

    screenSize = get(0, 'ScreenSize');
    windowWidth = 600;
    windowHeight = 400;
    windowPosition = [(screenSize(3) - windowWidth) / 2, (screenSize(4) - windowHeight) / 2, windowWidth, windowHeight];

    hFig = figure('Position', windowPosition, 'Name', 'Model Seçim ve Sonuç Gösterimi', 'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none', 'Resize', 'off');  

    hButtonGroup = uibuttongroup('Parent', hFig, 'Position', [0.02, 0.1, 0.3, 0.8]);

    hRadiobutton1 = uicontrol(hButtonGroup, 'Style', 'radiobutton', 'String', 'Kanser Tanıma', ...
                              'Position', [10, 200, 150, 30], 'Value', 1);
    
    hRadiobutton2 = uicontrol(hButtonGroup, 'Style', 'radiobutton', 'String', 'Transfer Öğrenme', ...
                              'Position', [10, 170, 150, 30]);

    hButton = uicontrol('Parent', hFig, 'Style', 'pushbutton', 'String', 'Görüntü Seç', ...
                       'Position', [44, 60, 120, 30], 'Callback', @selectImage);
                     
    hAxes = axes('Parent', hFig, 'Position', [0.4, 0.1, 0.55, 0.8]);

    try
        loadedData = load('egitimli_agKanserTanima.mat', 'net'); 
        netTanima = loadedData.net;
        
        loadedData = load('egitimli_agKanserTransfer.mat', 'net'); 
        netTransfer = loadedData.net;
    catch
        error('Eğitilmiş modeller yüklenirken bir hata oluştu.');
    end

    function selectImage(~, ~)
        [fileName, filePath] = uigetfile({'*.png;*.jpg;*.jpeg;*.gif', 'Desteklenen Dosya Türleri'; '*.*', 'Tüm Dosyalar'}, 'Resim Dosyasını Seç');

        if isequal(fileName, 0)
            disp('İşlem iptal edildi.');
            return;
        end
        
        imagePath = fullfile(filePath, fileName);
        img = imread(imagePath);
        img = imresize(img, [227, 227]);

        if get(hRadiobutton1, 'Value') 
            [out, ~] = classify(netTanima, img);
        elseif get(hRadiobutton2, 'Value') 
            [out, ~] = classify(netTransfer, img);
        else
            disp('Geçersiz model seçimi.');
            return;
        end

        imshow(img, 'Parent', hAxes);
        title(hAxes, out);
    end
end