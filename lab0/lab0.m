filename = 'cameraman.tif'; 
A = imread(filename); 
imshow(A)
imfinfo(filename)

figure
%agray = gray2rgb(A); 
imhist(A)

%P = impixel(A); 
m = mean2(A); 
s = std2(A); 

B = imadjust(A, [],[], 2.4);
B2 = imadjust(A, [],[], 0.7);

imshow(B)
imshow(B2)

B3 =  histeq(A); 
imshow(B3)
imhist(B3)

h = fspecial('average'); 
C = filter2(h, A)./255;

imshow(C)
figure
D = (double(A)./255) - C; 
imshow(D)


E = (double(A)./255) + D;
imshow(E)

h = fspecial('sobel'); 
F =filter2(h,A)./255; 


h = fspecial('sobel')'; 
G =filter2(h,A)./255; 

I = sqrt(F.^2 + G.^2);
imshow(I)
imshow(F)