%% Section 2 - Image Quality Measures
ref_im = imread('cameraman.tif');
test_im = ref_im + uint8(5*ones(size(ref_im)));
test_im = min(test_im, 255);

answer = PSNR(ref_im, test_im);
figure, imshow(ref_im)
figure, imshow(test_im)

%% Section 3 - Digital Zooming - Lena
close all; 
clear all; 
lena_img = imread('lena.tiff');
lena_gray = rgb2gray(lena_img); 
lena_comp = imresize(lena_gray, 0.25, 'bilinear'); 

lena_nn = imresize(lena_comp, 4, 'nearest'); 
lena_bi = imresize(lena_comp, 4, 'bilinear'); 
lena_tri = imresize(lena_comp, 4, 'bicubic');

figure, imshow(lena_gray)
title('Original Img'); 
figure, imshow(lena_nn)
title('Nearest Neighbor'); 
figure, imshow(lena_bi)
title('Bilinear'); 
figure, imshow(lena_tri)
title('Bicubic');

psnr_nn = PSNR(lena_gray, lena_nn); 
psnr_bi = PSNR(lena_gray, lena_bi); 
psnr_tri = PSNR(lena_gray, lena_tri); 
%% Section 3 - Digital Zooming - cameraman
close all; 
clear all; 
cameraman_gray = imread('cameraman.tif');
cameraman_comp = imresize(cameraman_gray, 0.25, 'bilinear'); 

cameraman_nn = imresize(cameraman_comp, 4, 'nearest'); 
cameraman_bi = imresize(cameraman_comp, 4, 'bilinear'); 
cameraman_tri = imresize(cameraman_comp, 4, 'bicubic');

figure, imshow(cameraman_gray)
title('Original Img'); 
figure, imshow(cameraman_nn)
title('Nearest Neighbor'); 
figure, imshow(cameraman_bi)
title('Bilinear'); 
figure, imshow(cameraman_tri)
title('Bicubic');

psnr_nn = PSNR(cameraman_gray, cameraman_nn); 
psnr_bi = PSNR(cameraman_gray, cameraman_bi); 
psnr_tri = PSNR(cameraman_gray, cameraman_tri); 

%% Section 4 - Discrete Convolution for Img Proc
close all; 
clear all; 
lena_img = imread('lena.tiff');
lena_gray = rgb2gray(lena_img); 

lena_gray = double(lena_gray)/255;
imwrite(lena_gray, 'DerivedImgs/lena_gray.tiff', 'tiff');

h1 = (1/6)*ones(1,6);
h2 = h1';
h3 = [-1 1];

lena_h1 = conv2(lena_gray, h1);
lena_h2 = conv2(lena_gray, h2);
lena_h3 = conv2(lena_gray, h3);

figure, montage([lena_gray lena_h1]);
imwrite(lena_h1, 'DerivedImgs/lena_h1.tiff', 'tiff');
title('h1');

figure, imshow(lena_h2);
imwrite(lena_h2, 'DerivedImgs/lena_h2.tiff', 'tiff');
title('h2');

figure, montage([lena_gray lena_h3]);
imwrite(lena_h3, 'DerivedImgs/lena_h3.tiff', 'tiff');
title('h3');

%% Section 5 - Point Operations for Image Enhancement
clear all
close all
tire = imread('tire.tif');
cur_dir = pwd;
out_dir = 'DerivedImgs\Sec5';
cd(out_dir)

figure, imhist(tire)
title('Tire Hist')

class_name = class(tire); 
max_f = double(intmax(class_name)); 

neg_img = uint8(max_f*ones(size(tire))) - tire; 
figure, montage([tire neg_img])
title('Tire and Negative Tire Imgs');
figure, imhist(neg_img)
title('Negative Tire Hist')

tire_db = double(tire)./max_f;

gamma_tire_lo = tire_db.^0.5;
gamma_tire_lo = uint8(gamma_tire_lo*max_f);  

gamma_tire_hi = tire_db.^1.3;
gamma_tire_hi = uint8(gamma_tire_hi*max_f); 

figure, montage([tire gamma_tire_lo gamma_tire_hi]);
title('Original Image, Gamma 0.5 and Gamma 1.3'); 
saveas(gcf, 'Tire_Gamma_Montage.png');

figure, imhist(gamma_tire_lo);
title('Lo Gamma Tire');
saveas(gcf, 'Tire_Lo_Hist.png');

figure, imhist(gamma_tire_hi);
title('Hi Gamma Tire');
saveas(gcf, 'Tire_Hi_Hist.png');

figure, histeq(tire);
title('Eq Tire');

figure, histeq(neg_img);
title('Eq Negative Tire');

figure, histeq(gamma_tire_lo);
title('Lo Gamma Tire');

figure, histeq(gamma_tire_hi);
title('Hi Gamma Tire');

figure, imhist(histeq(gamma_tire_lo));
title('Lo Gamma Eq Tire');

figure, imhist(histeq(gamma_tire_hi));
title('Hi Gamma Eq Tire');



cd(cur_dir)