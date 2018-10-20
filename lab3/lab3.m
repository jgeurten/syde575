%%Prep
mandrill = imread('mandrill.png'); 
mandrill = rgb2gray(mandrill); 
cameraman = imread('cameraman.tif'); 
freq = imread('frequnoisy.tif'); 

%% Part 2
cur_dir = pwd;
out_dir = 'img\sec2';
mkdir(out_dir)
cd(out_dir)

f = zeros(256,256); 
f(:,108:148) = 1; 

figure,
imshow(f)
title('Test Image'); 
saveas(gcf, 'test_image.png'); 


f_fft = fft2(f); 
f_fft_shift = fftshift(f_fft); 
f_fft_abs = abs(f_fft_shift); 
figure, 
imshow(f_fft_abs, [])
title('Test Image FFT'); 
saveas(gcf, 'test_image_fft.png'); 


%Rotate image by 45 deg
f_rotated = imrotate(f, 45); 
figure, 
imshow(f_rotated);
title('Test Image Rotated 45 Degrees'); 
saveas(gcf, 'test_image_rotate.png'); 


f_fft = fft2(f_rotated); 
f_fft_shift = fftshift(f_fft); 
f_fft_abs = abs(f_fft_shift); 
figure, 
imshow(f_fft_abs, [])
title('Test Image Rotated 45 Degrees FFT');
saveas(gcf, 'test_image_fft_rotate.png'); 

mandrill_fft = fft2(mandrill); 
mandrill_shift = fftshift(mandrill_fft); 
mandrill_mag = abs(mandrill_shift); 
mandrill_phase = mandrill_shift./mandrill_mag; 

mandrill_inv_mag = ifft2(mandrill_mag); 
mandrill_inv_phase = ifft2(mandrill_phase);

mandrill_inv_mag = ifft2(ifftshift(mandrill_mag)); 
mandrill_inv_phase = ifft2(ifftshift(mandrill_phase));

figure, 
imshow(mandrill)
title('Original Mandrill Image'); 
saveas(gcf, 'original_mandrill.png'); 


figure, 
imshow(mandrill_inv_mag, [])
title('Reconstructed Mandrill Image with Mag'); 
saveas(gcf, 'reconstructed_mandrill_mag.png'); 

figure, 
imshow(mandrill_inv_phase, [])
title('Reconstructed Mandrill Image with Phase');
saveas(gcf, 'reconstructed_mandrill_phase.png'); 

cd(cur_dir); 
%% Part 3
cur_dir = pwd;
out_dir = 'img\sec3';
mkdir(out_dir)
cd(out_dir)

mandrill_gray = im2double(mandrill);
mandrill_gauss = imnoise(mandrill_gray, 'gaussian', 0, 0.005);

mandrill_gray_fft = fft2(mandrill_gray);
mandrill_gray_shift = fftshift(mandrill_gray_fft);
mandrill_gray_log = log(abs(mandrill_gray_shift));

mandrill_gauss_fft = fft2(mandrill_gauss);
mandrill_gauss_shift = fftshift(mandrill_gauss_fft);
mandrill_gauss_log = log(abs(mandrill_gauss_shift));

figure,
imshow(mandrill_gray, [])
title('Original Mandrill Image');
saveas(gcf, 'mandrill_original.png'); 

figure,
imshow(mandrill_gauss, [])
title('Mandrill Image with Additive Gaussian Noise');
saveas(gcf, 'mandrill_gauss.png'); 

figure,
imshow(mandrill_gray_log, [])
title('Log Fourier Spectra of Original Mandrill Image');
saveas(gcf, 'mandrill_log_fourier.png'); 

figure,
imshow(mandrill_gauss_log, [])
title('Log Fourier Spectra of Mandrill Image with Additive Gaussian Noise')
saveas(gcf, 'mandrill_gauss_log_fourier.png'); 

for r = [60, 20]
    % Ideal LPF (white disk with radius r)
    h = fspecial('disk',r); h(h > 0)=1;

    % Black image (energy-less Fourier spectra)
    [height, width] = size(mandrill_gray);

    h_freq = zeros(height, width);
    h_freq([(height/2)-r:(height/2)+r], [(width/2)-r:(width/2)+r])=h;
    
%     %Probably do not have to convert to the freq domain
%     h_freq_fft = fft2(h_freq);
%     h_freq_shift = fftshift(h_freq_fft);
%     h_freq_abs = abs(h_freq_shift);
%     %end
    
    figure, imshow(h_freq, [])
    title (['Fourier Spectra of Ideal Low Pass Filter with Radius ', num2str(r)]);
    filename = strcat('ideal_lpf_radius', num2str(r),'.png');
    saveas(gcf, filename); 
    
    mandrill_denoised_fft = h_freq.*mandrill_gauss_shift;
    
    figure, imshow(log(abs(mandrill_denoised_fft)), []);
    title('Log Fourier Spectra of Denoised Mandrill Image');
    
    mandrill_denoised = abs(ifft2(mandrill_denoised_fft));
    
    figure, imshow(mandrill_denoised, []);
    title(['Denoised Mandrill Image Using Ideal LPF with Radius ', num2str(r), ' (PSNR=', num2str(PSNR(im2double(mandrill_denoised), mandrill_gray)), ')']);
    filename = strcat('mandrill_denoised_ideal_lpf_radius', num2str(r),'.png');
    saveas(gcf, filename); 
end

% Gaussian LPF
for sd = 60
    h_freq = fspecial('gaussian',size(mandrill_gray,1),sd);
    
    % Normalize h_freq based on highest value in kernel
    h_freq = h_freq./max(max(h_freq));
    
    figure, imshow(h_freq, [])
    title (['Fourier Spectra of Gaussian Low Pass Filter with Std Dev ', num2str(sd)]);
    filename = strcat('gaussian_lpf_stddev', num2str(sd),'.png');
    saveas(gcf, filename); 
    
    mandrill_denoised_fft = h_freq.*mandrill_gauss_shift;
    figure, imshow(log(abs(mandrill_denoised_fft)), []);
    title('Log Fourier Spectra of Denoised Mandrill Image');
    
    mandrill_denoised = abs(ifft2(mandrill_denoised_fft));
    
    
    figure, imshow(mandrill_denoised, []);
    title(['Denoised Mandrill Image Using Gaussian LPF with Std Dev ', num2str(sd), ' (PSNR=', num2str(PSNR(im2double(mandrill_denoised), mandrill_gray)), ')']);
    filename = strcat('mandrill_denoised_gaussian_lpf_stddev', num2str(sd),'.png');
    saveas(gcf, filename); 
end

cd(cur_dir)
%% Section 4
cur_dir = pwd;
out_dir = 'img\sec4';
mkdir(out_dir)
cd(out_dir)

figure, imshow(freq); 
title('Original Frequnoisy'); 
saveas(gcf, 'original_frequnoisy.png');

freq_fft = fft2(freq); 
freq_shift = fftshift(freq_fft); 
freq_mag = abs(freq_shift); 
figure, imshow(log(freq_mag), []); 
title ('Fourier Spectra of Frequnoisy Image'); 
saveas(gcf, 'frequnoisy_fft.png'); 

%Create 2D freq domain filter
h_freq = ones(size(freq)); 
h_freq(65, 65) = 0; 
h_freq(119, 105) = 0; 
h_freq(139, 153) = 0; 
h_freq(193, 193) = 0; 

figure, imshow(h)
denoised_freq = h_freq.*fftshift(freq_fft); 
denoised_img = ifft2(denoised_freq); 
denoised_img = abs(denoised_img); 


freq_fft = fft2(denoised_img); 
freq_shift = fftshift(freq_fft); 
freq_mag = abs(freq_shift); 
figure, imshow(log(freq_fft) ); 
title('FFT Spectra of Denoised Image'); 
saveas(gcf, 'denoised_image_FFT.png');

figure, imshow(denoised_img,[])
title('Denoised Frequnoisy Image'); 
saveas(gcf, 'denoised_image.png');

cd(cur_dir)

function psnr_out = PSNR(f,g)
    psnr_out = 10*log10(1/mean2((f-g).^2));
end

