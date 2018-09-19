% Inputs:
%   f: reference image
%   g: test image

% Output:
%   PSNR_out: PSNR value

function PSNR_out = PSNR(f, g)
    class_name = class(f); 
    max_f = double(intmax(class_name)); 
    
    PSNR_out = 10*log10(double((max_f^2)/MSE(f,g)));
end

function MSE_out = MSE(f, g)
    f = double(f);
    g = double(g);
    diff = f-g;
    diff_square = diff.^2;
    sum_diffs = sum(sum(diff_square));
    num_elem = size(f, 1) * size(f, 2);
    
    MSE_out = sum_diffs/num_elem;
end