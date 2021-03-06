%% Lab5 Prep

lena = imread('lena.tiff'); 
[peppers, map] = imread('peppers.png'); 
cur_dir = pwd; 

mkdir('images/part2'); 
mkdir('images/part3'); 
mkdir('images/part4'); 
mkdir('images/part5'); 

%% Part 2
cd('images/part2'); 
peppers_ycbcr = rgb2ycbcr(peppers); 
channels = ["Y", "Cb", "Cr"]; 

for i = 1:size(peppers_ycbcr, 3)
    figure, 
    imshow(peppers_ycbcr(:,:,i)); 
    title(strcat(channels(i), ' Channel of Peppers')); 
    saveas(gcf, strcat(channels(i), '_Channel_Peppers_YCrCb.png')); 
end

peppers_Y_small = imresize(peppers_ycbcr(:,:,1), 0.5); 
peppers_Cb_small = imresize(peppers_ycbcr(:,:,2), 0.5); 
peppers_Cr_small = imresize(peppers_ycbcr(:,:,3), 0.5); 

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

%Unscaled Y channel
peppers_combined = zeros(size(peppers_Y,1),size(peppers_Y,2), 3, 'uint8'); 
peppers_combined(:,:,1) = peppers_ycbcr(:,:,1);
peppers_combined(:,:,2) = peppers_Cb; 
peppers_combined(:,:,3) = peppers_Cr; 
figure, 
imshow(ycbcr2rgb(peppers_combined)); 
title('Recombined Resized Peppers'); 
saveas(gcf, 'Recombined_Peppers_Unscaled.png'); 

peppers_combined = zeros(size(peppers_Y,1),size(peppers_Y,2), 3, 'uint8'); 
peppers_combined(:,:,1) = peppers_Y;
peppers_combined(:,:,2) = peppers_Cb; 
peppers_combined(:,:,3) = peppers_Cr; 

figure, 
imshow(ycbcr2rgb(peppers_combined)); 
title('Recombined All Channels Resized Peppers'); 
saveas(gcf, 'Recombined_Peppers_Scaled.png'); 

cd(cur_dir)

%% Part 3
cd('images/part3'); 
c = makecform('srgb2lab');
peppers_lab = applycform(peppers, c);

for K = [2,4]
    if (K == 2)
        row = [55 200];
        col = [155 400];
    elseif (K == 4)
        row = [55 130 200 280];
        col = [155 110 400 470];
    end
        
    % Convert (r,c) indexing to 1D linear indexing.
    idx = sub2ind([size(peppers,1) size(peppers,2)], row, col);

    % Reshape the a* and b* channels
    ab = double(peppers_lab(:,:,2:3));
    m = size(ab,1);
    n = size(ab,2);
    ab = reshape(ab,m*n,2);
    mu = zeros(K, 2);

    % Vectorize starting coordinates
    for k = 1:K
        mu(k,:) = ab(idx(k),:);
    end

    cluster_idx = kmeans(ab, K, 'Start', mu);

    % Label each pixel according to k-means
    pixel_labels = reshape(cluster_idx, m, n);
    figure
    h = imshow(pixel_labels, []);
    title(['Peppers Segmented With K-Means and K = ', num2str(K)]);
    colormap('jet')
    saveas(gcf, ['peppers_k_means_', num2str(K),'.png']);

    % Output each cluster using original colours of the image.
    peppers_rep = repmat(peppers, 1, K);
    pixel_labels_rep = [];

    for k = 1:K
        test = pixel_labels;
        test(test~=k) = 0;
        test(test==k) = 1;
        pixel_labels_rep = [pixel_labels_rep test];
    end

    pixel_labels_rep = uint8(repmat(pixel_labels_rep, 1, 1, 3));

    peppers_segmented = peppers_rep.*pixel_labels_rep;
    figure
    imshow(peppers_segmented);
    title(['Peppers Segmented With K-Means and K = ', num2str(K)]);
    saveas(gcf, ['peppers_original_k_means_', num2str(K), '.png']);
end


cd(cur_dir)

%% Section 4
cd('images/part4')
N = 8; 
T = dctmtx(N); 
f = rgb2gray(lena); 

figure,imshow(T,'InitialMagnification','fit'); 
title('DCT Matrix'); 
saveas(gcf, 'DCT_Matrix.png'); 

figure, hold on
for i=1:size(T,1)
   plot(T(i,:), 'DisplayName', ['Row ', num2str(i)]);
   legend('-DynamicLegend'); 
end
title('Rows of the DCT Matrix'); 
legend('show');
saveas(gcf, 'DCT_Matrix_Rows.png'); 
% fun =  @(x) T*x.data*T'; 
f= double(f); 
F_trans = floor(blockproc(f-128, [N N], @(x) T*x.data*T'));


figure, imshow(F_trans(297:297+N-1, 81:81+N-1), [], 'InitialMagnification','fit'); 
title('DCT of High Freq Sub Image'); 
saveas(gcf, 'DCT_SubImage_297_81.png'); 

figure, imshow(F_trans(1:N, 1:N), [],'InitialMagnification','fit'); 
title('DCT of Low Freq Sub Image'); 
saveas(gcf, 'DCT_SubImage_1_1.png'); 

mask = [1 1 1 0 0 0 0 0;
1 1 0 0 0 0 0 0;
1 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0;
0 0 0 0 0 0 0 0];
F_thresh = blockproc(F_trans, [N N], @(x) mask.*x.data);
f_thresh = floor(blockproc(F_thresh, [N N], @(x) T'*x.data*T)) + 128;

figure, imshow(f_thresh, [])
psnr_thresh = psnr( uint8(f_thresh), uint8(f)); 
title(['Discarded DCT Coeffs Reconstruction PSNR: ', num2str(psnr_thresh)]); 
saveas(gcf, 'DCT_Discarded_Reconstructed.png'); 

cd(cur_dir)

%% Part 5
cd('images/part5')
f = rgb2gray(lena);
imwrite(f, 'lena_gray.png');

N = 8; 
T = dctmtx(N); 

figure,imshow(T,'InitialMagnification','fit'); 
title('DCT Matrix'); 
saveas(gcf, 'DCT_Matrix.png'); 

Z = [16 11 10 16 24 40 51 61;
12 12 14 19 26 58 60 55;
14 13 16 24 40 57 69 56;
14 17 22 29 51 87 80 62;
18 22 37 56 68 109 103 77;
24 35 55 64 81 104 113 92;
49 64 78 87 103 121 120 101;
72 92 95 98 112 100 103 99];

% Perform 8x8 DCT Transform
f = double(f); 
F_trans = blockproc(f-128, [N N], @(x) T*x.data*T');

% Quantization to different degrees by adjusting Z quantization matrix
for num_Z = [1, 3, 5, 10]
    % Perform quantization
    F_quantized = round(blockproc(F_trans, [N N], @(x) x.data./(num_Z.*Z)));
    
    % Re-construct image
    F_reconstructed = blockproc(F_quantized, [N N], @(x) x.data.*(num_Z.*Z));
    f_reconstructed = round(blockproc(F_reconstructed, [N N], @(x) T'*x.data*T)) + 128;
    
    figure, imshow(f_reconstructed, [])
    psnr_reconstructed = psnr(uint8(f_reconstructed), uint8(f)); 
    title(['Lena Reconstructed After DCT and Quantization Using ', num2str(num_Z),'Z PSNR: ', num2str(psnr_reconstructed)]); 
    saveas(gcf, ['lena_reconstructed_', num2str(num_Z),'Z.png']); 
end

cd(cur_dir)

