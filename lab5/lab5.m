%Lab5 Prep

lena = imread('lena.tiff'); 
peppers = imread('peppers.png'); 
cur_dir = pwd; 

mkdir('images/part2'); 
mkdir('images/part3'); 
mkdir('images/part4'); 
%% Part 2
cd('images/part2'); 
peppers_ycbcr = rgb2ycbcr(peppers); 
channels = ["Y", "Cb", "Cr"]; 

for i = 1:size(peppers_ycbcr, 3)
    figure, 
    imshow(peppers(:,:,i)); 
    title(strcat(channels(i), ' Channel of Peppers')); 
    saveas(gcf, strcat(channels(i), '_Channel_Peppers_YCrCb.png')); 
end

peppers_Y_small = imresize(peppers(:,:,1), 0.5); 
peppers_Cb_small = imresize(peppers(:,:,2), 0.5); 
peppers_Cr_small = imresize(peppers(:,:,3), 0.5); 

peppers_Y = imresize(peppers_Y_small, 2, 'bilinear'); 
peppers_Cb = imresize(peppers_Cb_small, 2, 'bilinear'); 
peppers_Cr = imresize(peppers_Cr_small, 2, 'bilinear'); 

figure, 
imshow(peppers_Y); 
title('Luma Channel of Peppers Resized'); 
saveas(gcf, 'Resized_Y_Peppers.png'); 

figure, 
imshow(peppers_Cb); 
title('Cb Channel of Peppers Resized'); 
saveas(gcf, 'Resized_Cb_Peppers.png'); 

figure, 
imshow(peppers_Cr); 
title('Cr Channel of Peppers Resized'); 
saveas(gcf, 'Resized_Cr_Peppers.png'); 

peppers_combined = zeros(size(peppers_Y,1),size(peppers_Y,2), 3, 'uint8'); 
peppers_combined(:,:,1) = peppers_Y;
peppers_combined(:,:,2) = peppers_Cb; 
peppers_combined(:,:,3) = peppers_Cr; 

figure, 
imshow(ycbcr2rgb(peppers_combined)); 
title('Recombined Resized Peppers'); 
saveas(gcf, 'Recombined_Peppers.png'); 

cd(cur_dir)

%% Part 3
cd('images/part3'); 
