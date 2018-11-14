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

%Apply inverse filter
inverse_filt_f_gauss = real(ifft2(fft2(f_blur_gauss)./h_freq));

figure, imshow(inverse_filt_f_gauss);
psnr_inverse_filt_f_gauss = psnr(inverse_filt_f_gauss, f); 
title_name = strcat('Restored Blurred Cameraman with Additive Gaussian Noise Using Inverse Filtering, PSNR = ', num2str(psnr_inverse_filt_f_gauss)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_inverse_gauss.png');

% Apply Wiener Filter
approx_nsr = 0.002/var(f_blur_gauss(:)); %0.002 = var(noise)
wiener_filt_f_gauss = deconvwnr(f_blur_gauss, h, approx_nsr);

figure, imshow(wiener_filt_f_gauss);
psnr_wiener_filt_f_gauss = psnr(wiener_filt_f_gauss, f); 
title_name = strcat('Restored Blurred Cameraman with Additive Gaussian Noise Using Wiener Filtering, PSNR = ', num2str(psnr_wiener_filt_f_gauss)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_wiener_gauss.png');

cd(cur_dir)

%% Section 3- Lee filter (adaptive filtering)
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
psnr_adaptive_filt_f = psnr(f_hat, f); 
title_name = strcat('Restored Blurred Cameraman Using Adaptive Filtering, PSNR = ', num2str(psnr_adaptive_filt_f)); 
title(title_name); 
set(gcf, 'Units', 'normalized', 'Position', [0 0 0.5 0.5] );
saveas(gcf, 'restored_cameraman_adaptive_filtering.png');

cd(cur_dir); 
%% PSNR
function psnr_out = psnr(f,g)
    psnr_out = 10*log10(1/mean2((f-g).^2));
end
