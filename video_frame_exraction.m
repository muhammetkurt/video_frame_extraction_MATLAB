%% Programmed By Muhammet Kurt
%130207043


%% Giris
clc;close all;clear all;
%gerekli parametreler tanimlandi


%% UYARI - Kullanimi istege baglidir
%burada frameler video icerisinden alindiginda cok daha kaliteli sonuc
%alinmaktadir


%source='video.mp4';
%vidobj=VideoReader(source);
%frames=vidobj.Numberofframes;
%curPic=rgb2gray(read(vidobj,4));
%refPic=rgb2gray(read(vidobj,5));

%%





k = 1;    l = 1;    tempPic = {}; count = 1;
curPic = rgb2gray(imread('poke2.JPG')); [w1, h1] = size(curPic);

%% Ana kod
%burada imge parcalanarak ek bir matris matrisine aktariliyor.
for a = 1:8:w1
    for b = 1:8:h1
        for i = 1:8
            for j = 1:8
                tempPic{k,l}(i,j) = curPic(a+i-1,b+j-1);
            end
        end
        l = l+1;
    end
    l = 1;
    k = k+1;
end



%% Gerekli parametreler yeniden tanimlandi
[w2, h2]=size(tempPic);

refPic = rgb2gray(imread('poke1.JPG'));
reconstPic = refPic;
const=inf; result_all={}; coords={}; flag=0;

p=1;r=1;k=1;l=1;


%% Ana Kod
% forlar icerisinde imge parcaciklari ref ile taranarak fark?n mse degeri
% bulundu ve burada uyumluluk icin en kucuk mse degeri kullaniliyor.
for i = 1:w2-1
   for j = 1:h2-1
                
       % parcacigin eksi sekiz ile arti sekiz araligi tarandi
       for a = -8:8
           for b = -8:8
               %gerekli atamalar matematiksel olarak bulunup tanimladi
                start_i = (((i-1)*8)+1)+a;
                start_j = (((j-1)*8)+1)+b;

                %kose degerlerini de onceki kodda oldugu gibi es gecilmedi
                %yeniden kullanildi
                if start_i < 1  
                    start_i=1;
                end
                if start_j < 1
                    start_j=1;
                end
                if start_i+7 >= w1
                    start_i=w1-7;
                end
                if start_j >= h1
                    start_j=h1-7;
                end
                
                %uyumluluk icin en kucuk mse degeri kullanildi
                mse = refPic(start_i:start_i+7, start_j:start_j+7) - tempPic{i,j};
                result=sum(sum(mse));
                
                %burada sonradan kullanilmak icin gerekli atama ve
                %tanimlamalar yapildi
                if result<const
                    if(result==0)
                        const=result;
                        coords{i,j}(1,3)=0;
                        flag=1;
                        break;  
                    else
                        const=result;
                        coords{i,j}(1,1)=start_i;
                        coords{i,j}(1,2)=start_j;
                        coords{i,j}(1,3)=result;
                        coords{i,j}(1,4)=(1+(i-1)*8);
                        coords{i,j}(1,5)=(1+(j-1)*8);  
                    end
                end
                const=inf;
           end
           if flag==1
               flag=0;
            break;
           end
      
       end

   end

    const=inf;
end

%% Imge atamasi olusturuldu
%onceki part ta olusturulan coords kullanilarak imge olusuturulmasi
%tamamlandi
for i=1:w2-1
    for j=1:h2-1
        if ~(coords{i,j}(1,3)==0)
            f=coords{i,j}(1,4);
            d=coords{i,j}(1,5);
            x=coords{i,j}(1,1);
            y=coords{i,j}(1,2);
            reconstPic(f:f+7,d:d+7)= refPic(x:x+7, y:y+7);
        else
            continue;
        end
    end
end
difPic=reconstPic-curPic;

%% Gosterim
figure,
imshow(reconstPic);

figure,
imshow(difPic);

figure,
imshow(refPic);

figure,
imshow(curPic);



