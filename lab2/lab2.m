%% Prep
cameraman = imread('cameraman.tif');
mandrill = imread('mandrill.png');
mkdir('img');
cur_dir = pwd;

%% Section 2: Noise Generation
out_dir = 'img/sec2';
mkdir(out_dir)
cd(out_dir)
toy_im = [0.3*ones(200,100) 0.7*ones(200,100)];
imwrite(toy_im, 'toy_orig.tif');

figure, imhist(toy_im);
title('Original Image');
ylim([0 21000])
saveas(gcf, 'toy_orig_hist.png');

% Additive zero-mean Gaussian (var = 0.01)
toy_gauss = imnoise(toy_im, 'gaussian', 0, 0.01);

% Salt and pepper (noise density of 0.05)
toy_saltpepper = imnoise(toy_im, 'salt & pepper', 0.05); 

% Multiplicative speckle noise (var = 0.04)
toy_speckle = imnoise(toy_im, 'speckle', 0.04);

% Plot images and histograms
% SAVE PROGRAMMATICALLY
figure, imshow(toy_gauss);
title('Zero-Mean Gaussian Noise (Variance = 0.01)');
saveas(gcf, 'toy_gauss.png');

figure, imhist(toy_gauss);
title('Zero-Mean Gaussian Noise (Variance = 0.01)');
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'toy_gauss_hist.png');

figure, imshow(toy_saltpepper);
title('Salt & Pepper Noise (Density = 0.05)');
saveas(gcf, 'toy_saltpepper.png');

figure, imhist(toy_saltpepper);
title('Salt & Pepper Noise (Density = 0.05)');
saveas(gcf, 'toy_saltpepper_hist.png');
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
ylim([0 20000]);
saveas(gcf, 'toy_saltpepper_hist.png');

figure, imshow(toy_speckle);
title('Speckle Noise (Variance = 0.04)');
saveas(gcf, 'toy_speckle.png');

figure, imhist(toy_speckle);
title('Speckle Noise (Variance = 0.04)');
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'toy_speckle_hist.png');

cd(cur_dir)

%% Section 3:
out_dir = 'img/sec3';
mkdir(out_dir)
cd(out_dir)

mandrill = imread('mandrill.png'); 
mandrill_bw = rgb2gray(mandrill); 
mandrill = im2double(mandrill_bw);

figure, imshow(mandrill); 
title('Original Mandrill'); 
saveas(gcf, 'org_mandrill.png'); 
noisy_mandrill = imnoise(mandrill, 'gaussian', 0.002); 
figure, imshow(noisy_mandrill); 
title('Noisy Mandrill')
saveas(gcf, 'noisy_mandrill.png'); 

figure, imhist(mandrill); 
title('Mandrill Original'); 
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'mandrill_org_hist.png'); 

psnr_mandrill = psnr(mandrill, noisy_mandrill); 
figure, imhist(noisy_mandrill); 
title_name = strcat('Noisy Mandrill PSNR = ', num2str(psnr_mandrill)); 
title(title_name); 
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'noisy_mandrill_hist.png');

% ==================== 3x3 Averaging Mask ==================== 
avg_mask = fspecial('average',3);

figure
imagesc(avg_mask)
colormap(gray)
title('Averaging Filter Kernel'); 
saveas(gcf, 'avg_filt_kernel.png'); 

avg_mandrill = imfilter(noisy_mandrill, avg_mask); 
figure, imshow(avg_mandrill); 
title('Denoised Mandrill'); 
saveas(gcf, 'denoised_mandrill.png'); 

figure, imhist(avg_mandrill); 
psnr_denoised_man = psnr(avg_mandrill, mandrill); 
title_name = strcat('Denoised Mandrill using Small Avg Mask PSNR = ', num2str(psnr_denoised_man)); 
title(title_name); 
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'denoised_mandrill_hist.png'); 

% ==================== 7x7 Averaging Mask ====================
avg_mask_lg = fspecial('average', 7); 
avg_mandrill_lg = imfilter(noisy_mandrill, avg_mask_lg); 
figure, imshow(avg_mandrill_lg); 
title('Denoised Mandrill using Large Mask'); 
saveas(gcf, 'denoised_mandrill_large.png');

figure, imhist(avg_mandrill_lg); 
psnr_denoised_man_lg = psnr(avg_mandrill_lg, mandrill); 
title_name = strcat('Denoised Mandrill using Large Mask PSNR = ', num2str(psnr_denoised_man_lg)); 
title(title_name);
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'denoised_mandrill_large_hist.png');

% ==================== 7x7 Gaussian Mask ====================
gauss_mask = fspecial('gaussian',7,1);
figure
imagesc(gauss_mask)
colormap(gray)
title('Gaussian Filter Kernel'); 
saveas(gcf, 'gauss_filt_kernel.png')

avg_mandrill_gauss = imfilter(noisy_mandrill, gauss_mask); 
figure, imshow(avg_mandrill_gauss); 
title('Denoised Mandrill using Gaussian Mask'); 
saveas(gcf, 'denoised_mandrill_gauss.png'); 

figure, imhist(avg_mandrill_gauss); 
psnr_denoised_man_gauss = psnr(avg_mandrill_gauss, mandrill); 
title_name = strcat('Denoised Mandrill using Gaussian Mask PSNR = ', num2str(psnr_denoised_man_gauss)); 
title(title_name);
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'denoised_mandrill_gauss_hist.png'); 

% ==================== Salt and Pepper ==================== 
noisy_mandrill_sp = imnoise(mandrill, 'salt & pepper'); 
figure, imshow(noisy_mandrill_sp); 
title('Salt and Pepper Noisy Mandrill')
saveas(gcf, 'noisy_mandrill_salt_pepper.png'); 

figure, imhist(noisy_mandrill_sp); 
title('Salt and Pepper Noisy Mandrill')
saveas(gcf, 'noisy_mandrill_salt_pepper_hist.png');

%S&P with large averaging filter
avg_mandrill_lg_sp = imfilter(noisy_mandrill_sp, avg_mask_lg); 
figure, imshow(avg_mandrill_lg_sp); 
title('Denoised Salt and Pepper Mandrill using Large Mask'); 
saveas(gcf, 'denoised_mandrill_saltandpepper_large.png');

figure, imhist(avg_mandrill_lg_sp); 
psnr_denoised_saltpepper_man_lg = psnr(avg_mandrill_lg_sp, mandrill); 
title_name = strcat('Denoised Mandrill using Large Mask PSNR = ', num2str(psnr_denoised_saltpepper_man_lg)); 
title(title_name); 
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'denoised_salt_mandrill_large_hist.png');

%S&P with gaussian filter
avg_mandrill_gauss_sp = imfilter(noisy_mandrill_sp, gauss_mask); 
figure, imshow(avg_mandrill_gauss_sp); 
title('Denoised Salt and Pepper Mandrill using Gaussian Mask'); 
saveas(gcf, 'denoised_mandrill_saltandpepper_gauss.png');

figure, imhist(avg_mandrill_gauss_sp); 
psnr_denoised_saltpepper_man_gauss = psnr(avg_mandrill_gauss_sp, mandrill); 
title_name = strcat('Denoised Mandrill using Gaussian Mask PSNR = ', num2str(psnr_denoised_saltpepper_man_gauss)); 
title(title_name); 
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'denoised_salt_mandrill_gauss_hist.png');

%S&P with median filter
avg_mandrill_median_sp = medfilt2(noisy_mandrill_sp); 
figure, imshow(avg_mandrill_median_sp); 
title('Denoised Salt and Pepper Mandrill using Median Filter'); 
saveas(gcf, 'denoised_mandrill_saltandpepper_median.png');

figure, imhist(avg_mandrill_median_sp); 
psnr_denoised_saltpepper_man_median = psnr(avg_mandrill_median_sp, mandrill); 
title_name = strcat('Denoised Mandrill using Median Filter PSNR = ', num2str(psnr_denoised_saltpepper_man_median)); 
title(title_name); 
xlabel('Pixel Intensity'); 
ylabel('Pixel Count'); 
saveas(gcf, 'denoised_salt_mandrill_median_hist.png');

cd(cur_dir)

%% Section 4: Sharpening in the Spatial Domain
out_dir = 'img\sec4';
mkdir(out_dir)
cd(out_dir)

cameraman = imread('cameraman.tif');
cameraman_db = im2double(cameraman);

gauss_mask = fspecial('gaussian',7,1);
cameraman_gauss = imfilter(cameraman_db, gauss_mask);

cameraman_subtract = cameraman_db - cameraman_gauss;

figure, imshow(cameraman_gauss);
title('Cameraman Using 7x7 Gaussian Filter');
saveas(gcf, 'cameraman_gauss.png');

figure, imshow(cameraman_subtract);
title('Cameraman Subtracting 7x7 Gaussian Filtered Image');
saveas(gcf, 'cameraman_subtract.png');

cameraman_add = cameraman_db + cameraman_subtract;

figure, imshow(cameraman_add);
title('Cameraman Adding Subtracted Image');
saveas(gcf, 'cameraman_add.png');

cameraman_add_half = cameraman_db + 0.5*cameraman_subtract;

figure, imshow(cameraman_add_half);
title('Cameraman Adding 0.5 Times Subtracted Image');
saveas(gcf, 'cameraman_add_half.png');

cd(cur_dir)

function psnr_out = psnr(f,g)
    psnr_out = 10*log10(1/mean2((f-g).^2));
end

