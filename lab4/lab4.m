%% Prep
cameraman = imread('cameraman.tif');
degraded = imread('degraded.tif');

%% Section 2
cur_dir = pwd; 
cd('img')
mkdir('sec2')
cd('sec2')

cameraman_db = im2double(cameraman);

% Disk blur function of radius 4
h = fspecial('disk', 4);
f = cameraman_db;
h_freq = fft2(h, size(f,1), size(f,2)); %pad h
f_blur = real(ifft2(h_freq.*fft2(f)));

% Plot blurred image
figure, imshow(f_blur);
psnr_f_blur = psnr(f_blur, f); 
title_name = strcat('Blurred Cameraman Using Disk Blur with Radius 4, PSNR = ', num2str(psnr_f_blur)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'blurred_cameraman.png'); 

%Apply inverse filter
inverse_filt_f = real(ifft2(fft2(f_blur)./h_freq));
%inverse_filt_f = f./h_freq; % this is probably wrong

figure, imshow(inverse_filt_f);
psnr_inverse_filt_f = psnr(inverse_filt_f, f); 
title_name = strcat('Restored Blurred Cameraman Using Inverse Filtering, PSNR = ', num2str(psnr_inverse_filt_f)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_inverse.png');

% Gaussian Noise
f_blur_gauss = imnoise(f_blur, 'gaussian', 0, 0.002);

% Plot blurred image
figure, imshow(f_blur_gauss);
psnr_f_blur_gauss = psnr(f_blur_gauss, f); 
title_name = strcat('Blurred Cameraman Using Disk Blur with Additive Gaussian Noise, PSNR = ', num2str(psnr_f_blur_gauss)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'blurred_gauss_cameraman.png'); 

%Apply inverse filter
inverse_filt_f_gauss = real(ifft2(fft2(f_blur_gauss)./h_freq));

figure, imshow(inverse_filt_f_gauss);
psnr_inverse_filt_f_gauss = psnr(inverse_filt_f_gauss, f); 
title_name = strcat('Restored Blurred Cameraman with Additive Gaussian Noise Using Inverse Filtering, PSNR = ', num2str(psnr_inverse_filt_f_gauss)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_inverse_gauss.png');

% Apply Wiener Filter
approx_nsr = 0.002/var(f(:)); %0.002 = var(noise)
wiener_filt_f_gauss = deconvwnr(f_blur_gauss, h, approx_nsr);

figure, imshow(wiener_filt_f_gauss);
psnr_wiener_filt_f_gauss = psnr(wiener_filt_f_gauss, f); 
title_name = strcat('Restored Blurred Cameraman with Additive Gaussian Noise Using Wiener Filtering, PSNR = ', num2str(psnr_wiener_filt_f_gauss)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_wiener_gauss.png');

cd(cur_dir)

%% Section 3- Lee filter (adaptive filtering)
cd(cur_dir); 
cd('img')
mkdir('sec3')
cd('sec3')
degraded_db = im2double(degraded); 
local_mean = colfilt(degraded_db, [5,5], 'sliding', @mean);
local_var = colfilt(degraded_db, [5,5], 'sliding', @var);

flat_img = imcrop(degraded_db, [176     4    76   104]); 
var_noise = var(flat_img(:)); 
noise_mat = ones(size(local_mean)).*var_noise; 

K = (local_var - noise_mat)./local_var; 
f_hat = K.*degraded_db + (1-K).*local_mean; 

figure, imshow(f_hat);
psnr_adaptive_filt_f = psnr(f_hat, cameraman_db); 
title_name = strcat('Restored Blurred Cameraman Using Adaptive Filtering, PSNR = ', num2str(psnr_adaptive_filt_f)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_adaptive_filtering.png');

%Question 1 - Gaussian LPF
degraded_fft = fftshift(fft2(degraded_db));
r = 30;
h_freq = fspecial('gaussian',size(degraded_db,1),r);
h_freq = h_freq/max(h_freq(:)); 

figure, imshow(h_freq, [])
title (['Fourier Spectra of Gaussian Low Pass Filter with Radius ', num2str(r)]);

degraded_denoised_fft = degraded_fft.*h_freq; 
degraded_denoised = real(ifft2(ifftshift(degraded_denoised_fft))); 
figure, imshow(degraded_denoised, []);
psnr_gauss_filt_f = psnr(degraded_denoised, cameraman_db ); 
title_name = ['Restored Blurred Cameraman Using Gaussian Filtering, PSNR = ', num2str(psnr_gauss_filt_f)]; 
title(title_name);
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_gauss_filtering.png');

%Question 2 - Vary estimate for noise var
noise_est = [var_noise/2, var_noise*2]; 
tt = [0.5, 2];
for i=1:2
    K = (local_var - noise_est(i))./local_var; 
    f_hat = K.*degraded_db + (1-K).*local_mean; 
    figure, imshow(f_hat);
    psnr_adaptive_filt_f_noiseVar = psnr(f_hat, cameraman_db); 
    title_name = ['Restored Cameraman Using Adaptive Filtering with ', num2str(tt(i)), 'x Noise Estimate, ' , 'PSNR = ', num2str(psnr_adaptive_filt_f_noiseVar)];    title(title_name); 
    set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
    saveas(gcf, ['restored_cameraman_adaptive_filtering', num2str(tt(i)), 'noise_estimate.png']);
end

%Question 3 - change size of the filtering neighborhood
kernel_size = [3, 7]; 

for i=1:2
    local_mean = colfilt(degraded_db, [kernel_size(i),kernel_size(i)], 'sliding', @mean);
    local_var = colfilt(degraded_db, [kernel_size(i), kernel_size(i)], 'sliding', @var);
    K = (local_var - var_noise)./local_var; 
    f_hat = K.*degraded_db + (1-K).*local_mean; 
    f_hat(isnan(f_hat)) = 0; 
    figure, imshow(f_hat);
    psnr_adaptive_filt_f_neighbor = psnr(f_hat, cameraman_db); 
    title_name = ['Restored Cameraman Using Adaptive Filtering with a neighborhood estimate of ', num2str(kernel_size(i)), ', PSNR = ', num2str(psnr_adaptive_filt_f_neighbor)];    title(title_name); 
    set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
    saveas(gcf, ['restored_cameraman_adaptive_filtering', num2str(kernel_size(i)), 'neighborhood_size.png']);
end

cd(cur_dir); 
%% PSNR
function psnr_out = psnr(f,g)
    psnr_out = 10*log10(1/mean2((f-g).^2));
end
