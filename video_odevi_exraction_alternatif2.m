%%Programmed By Muhammet Kurt
%130207043

%% Baslangic
%Imgeler okunup gray scale edildikten sonra gerekli parametreler tanimlandi
curPic = rgb2gray(imread('poke2.JPG')); [w1, h1] = size(curPic);
refPic = rgb2gray(imread('poke1.JPG')); result = refPic; buf = zeros(1,81);


%% Ana kod
%Burada olusturulacak cur imgesi icin kose kenarlarindaki alanlar ihmal
%edildi aksi taktirde kodda karmasikligi arttiracakti ki ikinci kod
%dosyasinda ihmal edilmedi
for a=8:8:w1-8
    for b=8:8:h1-8
        %sekize sekizlik alanlar ile tarandigi icin ilk forlar oyle
        %duzenlendi
        
       temp = curPic(a:a+7, b:b+7);
       %aranacak cur imge parcacigi temp degiskeni ile tutuldu
       for i=a-8:a
           for j=b-8:b
               %ref ile cur arasindaki uyumluluk degerlerini tutabilmek
               %icin her karsilastirmada 81 deger cikacak bunun tutulmasi
               %gerekli her defasinda if kosulu kullanarak kodu
               %hantallastirmaktan kacinilmasi icin bir 1x81 lik vektrorde
               %tutuluyor.
               %Vektorun indeks parametreleri karmasikligi gidermek icin
               %onceki paramaetreler kullanilarak olusturuldu
                buf((i-a+8)*9+(j-b+8)+1) = sum(sum(refPic(i+1:i+8, j+1:j+8) - temp));
           end
       end
       %en dusuk olan index degerleri tutuldu 
       index = find(buf == min(buf));
       
       %indexin bir dusuk degeri 45ten kucukse islem yapt?rd?k cunku bu
       %uyumluluk degerinin cok yuksek olmasi durumunda imgede islenerek
       %gosterilmesi cok mantiksiz olur.
       if index(1) < 45
           %eslesen uyumluluktaki parcanin koordinatlarini bulmak icin yine
           %onceki parametreleri kullanrak fazladan parametre
           %kullanilmayarak kod rahatlatildi.
           x_start = a - 8 + uint32(index(1) / 9) + 1;
           y_start = b - 8 + mod(index(1), 9) + ~mod(index(1), 9);
           %eslesen imge aktrami uygun koordinalara aktarimi yapildi
           result(a:a+7, b:b+7) = refPic(x_start:x_start+7, y_start:y_start+7);
       end
    end
end

difPic=result-curPic;

%% Gosterim
figure,
imshow(result);

figure,
imshow(difPic);

figure,
imshow(curPic);
figure,
imshow(refPic);