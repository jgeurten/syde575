% Inputs:
%   img: reference image
%   factor: scaling factor

% Output:
%   img_out: upsampled image

function img_out = nnInterpolation(factor, img)
   %Perform NN interpolation mapping
   img_out = uint8(zeros(size(img,1)*factor, size(img,2)*factor)); 
   for col = 1:size(img_out,1)
       for row = 1:size(img_out, 2)
           img_out(col, row) = img(ceil(col/factor), ceil(row/factor)); 
       end
   end
end