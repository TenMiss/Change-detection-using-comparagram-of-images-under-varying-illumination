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


function chmask = stat_gaussian(file1, file2, output, blksize, th);

% Author: Omar Al-Kofahi
% INPUT ARGUMENTS,
% file1:    first image
% file2:    second image
% output:   output binary change mask file name
% blksize:  size of the block (2-vector), for e.g., enter as [20, 20]
% th:       threshold
% Note that the input/output file names should be provided without the
% extension, see how images are read below. tiff input/output images are
% assumed

% Description:  Statistical change detection, using Gaussian model for the
% noise. Under the null hypothesis, unchanged regions in the difference
% image are modeled as zero mean Gaussian, the variance is estimated from
% the images, see below.

% reading the two images
im1 = imread([file1,'.tif']);
im2 = imread([file2,'.tif']);

im1 = double(im1);
im2 = double(im2);

%note: both images are assumed to be of the same size
[m,n] = size(im1); 

% Estimate the noise variance from the difference image..
[sigma0, sigma1] = calculate_sigmas(im1-im2, blksize(1,1));
if (sigma0 < 1) sigma0 = 1; end;    % to avoid devision by zero

% im1pad and im2pad are images padded with '0's - for edge/corner pixels to 
% allow block-based processing
im1pad = zeros(size(im1)+blksize-1);
im2pad = im1pad;

im1pad(floor((blksize(1)-1)/2)+[1:m], floor((blksize(2)-1)/2)+[1:n]) = im1; 
im2pad(floor((blksize(1)-1)/2)+[1:m], floor((blksize(2)-1)/2)+[1:n]) = im2; 

rows = [0:blksize(1)-1]; cols = [0:blksize(2)-1];

chmask = zeros(size(im1));

% x, y are the corresponding blocks of the two images

N = blksize(1)*blksize(2);          % number of pixels in the block
for i=1:m,
  for j=1:n,
    x = im1pad(i+rows,j+cols); %+1;
    y = im2pad(i+rows,j+cols); %+1;
    
    d = abs(x-y);
    d = d(:);
    s = (d' * d)/N;
    s = (d' * d);
    chmask(i,j) = s/sigma0^2;
  end
end

% Scale the chmask down..
chmask = mat2gray(chmask);

% threshold,
chmask = im2bw(chmask, th);

% write it to a file,
imwrite(chmask, [output, 'tif'], 'tiff');
