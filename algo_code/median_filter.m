% Copyright 2003 Rensselaer Polytechnic Institute. All the worldwide rights reserved. 
% A license to use, copy, modify and distribute this software for non-commercial research
% purposes is hereby granted, provided that this copyright notice and accompanying disclaimer
% is not modified or removed from this software.

% DISCLAIMER: This software is distributed "AS IS" without any express or implied warranty, 
% including but not limited to, any implied warranties of merchantability or fitness for 
% a particular purpose or any warranty of non-infringement of any current or pending patent 
% rights. The authors of the software make no representations about the suitability of this 
% software for any particular purpose. The entire risk as to the quality and performance of 
% the software is with the user. Should the software prove defective, the user assumes the 
% cost of all necessary servicing, repair or correction. In particular, neither Rensselaer 
% Polytechnic Institute, nor the authors of the software are liable for any indirect, special, 
% consequential, or incidental damages related to the software, to the maximum extent the law 
% permits.  


function median_filter(file, output, blk);

% Author: Omar Al-Kofahi
% INPUT/OUTPUT ARGUMENTS: 
% file: is the input image file name, no extension, see below
% output: is the output file fine, no extension, see below
% blk: is the block size, only square blocks are assumed, the square block
% area is (2*blk+1) * (2*blk+1);

% Description: Given an image, return the median filtered image using a
% square block defined by the variable 'blk'

% read the image from file;
I = imread([file,'.tif']);

[m,n] = size(I);

I_median = I;

% no padding is implemented here, the boundary pixels are not filtered.
for i = 1+blk:m-blk,
    for j = 1+blk:n-blk,
        
        tmp = I(i-blk:i+blk, j-blk:j+blk);
        
        I_median(i,j) = median(tmp(:));
        
    end;
end;

imwrite(I_median, [output, 'tiff'], 'tiff');