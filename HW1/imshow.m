%自製秀圖程式
% img   輸入影像陣列
% 語法:
% imshow(img) 顯示影像
% imshow(img, [ ]) 顯示影像, 根據影像的最大值/最小值, 作為階調黑/白的範圍
% imshow(img, [Lo High]) 顯示影像, 根據Lo/High, 作為階調黑/白的範圍

function imshow(img, LoHigh)

nd = ndims(img); %讀取矩陣維度


if nd > 1 & nd < 4
    
    if nd==2
            img = cat(3, img, img, img); %2維轉3維
    end
    ClassName = class(img); %讀出檔案型態
    img = single(img);

    if nargin ==1 %當輸入引數只有一個
        if strcmp(ClassName, 'uint8') 
            img = img/255; %使範圍落在[0 1]之間
        elseif strcmp(ClassName, 'uint16')   
            img = img/65535; %使範圍落在[0 1]之間
        end
        
    else % nargin == 2
        if isempty(LoHigh) %當第二個引數輸入[ ], 以資料的[min max]作為黑白範圍
            for ch=1:3
                a = img(:,:,ch);
                max_a = max(a(:));
                min_a = min(a(:));
                img(:,:,ch) = (a - min_a)/(max_a - min_a);
            end
        else %根據第二個引數輸入值LoHigh, 以資料的[Lo High], 也就是LoHigh(1)與LoHigh(2)作為黑白範圍
           for ch=1:3
                img(:,:,ch) = (img(:,:,ch) - LoHigh(1))/(LoHigh(2) - LoHigh(1));
           end 
        end
    end

    image(img)
    axis image %使影像長寬比正確
    axis off   %隱藏尺度軸
    
else
     errordlg('input array must have 2 or 3 dimension')
end
