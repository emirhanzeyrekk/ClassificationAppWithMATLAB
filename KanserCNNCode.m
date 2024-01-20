[fileName, filePath] = uigetfile({'*.png;*.jpg;*.jpeg;*.gif', 'Desteklenen Dosya Türleri'; '*.*', 'Tüm Dosyalar'}, 'Resim Dosyasını Seç');

if isequal(fileName, 0)
    disp('İşlem iptal edildi.');
    return;
end

imagePath = fullfile(filePath, fileName);
a = imread(imagePath);
a = imresize(a, [227 227]);

[out, score] = classify(net, a);

figure;
imshow(a);
title(string(out));
