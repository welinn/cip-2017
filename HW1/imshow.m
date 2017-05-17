%�ۻs�q�ϵ{��
% img   ��J�v���}�C
% �y�k:
% imshow(img) ��ܼv��
% imshow(img, [ ]) ��ܼv��, �ھڼv�����̤j��/�̤p��, �@�����ն�/�ժ��d��
% imshow(img, [Lo High]) ��ܼv��, �ھ�Lo/High, �@�����ն�/�ժ��d��

function imshow(img, LoHigh)

nd = ndims(img); %Ū���x�}����


if nd > 1 & nd < 4
    
    if nd==2
            img = cat(3, img, img, img); %2����3��
    end
    ClassName = class(img); %Ū�X�ɮ׫��A
    img = single(img);

    if nargin ==1 %���J�޼ƥu���@��
        if strcmp(ClassName, 'uint8') 
            img = img/255; %�Ͻd�򸨦b[0 1]����
        elseif strcmp(ClassName, 'uint16')   
            img = img/65535; %�Ͻd�򸨦b[0 1]����
        end
        
    else % nargin == 2
        if isempty(LoHigh) %��ĤG�Ӥ޼ƿ�J[ ], �H��ƪ�[min max]�@���¥սd��
            for ch=1:3
                a = img(:,:,ch);
                max_a = max(a(:));
                min_a = min(a(:));
                img(:,:,ch) = (a - min_a)/(max_a - min_a);
            end
        else %�ھڲĤG�Ӥ޼ƿ�J��LoHigh, �H��ƪ�[Lo High], �]�N�OLoHigh(1)�PLoHigh(2)�@���¥սd��
           for ch=1:3
                img(:,:,ch) = (img(:,:,ch) - LoHigh(1))/(LoHigh(2) - LoHigh(1));
           end 
        end
    end

    image(img)
    axis image %�ϼv�����e�񥿽T
    axis off   %���äث׶b
    
else
     errordlg('input array must have 2 or 3 dimension')
end
