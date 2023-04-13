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

function MDL_LRT(file1, file2, output, blksize);
% Author: Omar Al-Kofahi
% INPUT ARGUMENTS,
% file1:    first image
% file2:    second image
% output:   output binary change mask file name
% blksize:  size of the block (2-vector), for e.g., enter as [20, 20]
% Note that the input/output file names should be provided without the
% extension, see how images are read below. tiff input/output images are
% assumed.

% Descriptoin:  MDL approach to generate the change mask. if D is the
% difference image, then, the null hypothesis, H0, and the alternative
% hypothesis, H1, are characterized as:
%               H0 is that D~N(u0, s0), and H1 is that D~N(u1,s1), where 
%               s1 > s0. The means can be either assumed zeros, or ML
%               means. Use MDL to select between the two, this would be
%               expected to depend on the Block size.

% reading the two images
im1 = imread([file1,'.tif']);
im2 = imread([file2,'.tif']);

im1 = double(im1);
im2 = double(im2);

[m,n] = size(im1);

% Estimate the noise variance..
L = blksize(1,1);
[sigma0, sigma1] = calculate_sigmas(im1-im2, L);
if (sigma0 < 1) sigma0 = 1; end;    % avoid devision by zero


% Now, use the MDL principle for change detection. The Difference image 
% for each block is assumed to follow a gaussian distribution with
% mu and s, that depend on H0 and H1, you may want to drop the mean and
% assume it is equal to zero.

N = blksize(1)*blksize(2);

% Now, get the change mask;
% im1pad and im2pad are images padded with '0's - for edge/corner pixels to 
% allow block-based processing

im1pad = zeros(size(im1)+blksize-1);
im2pad = im1pad;

im1pad(floor((blksize(1)-1)/2)+[1:m], floor((blksize(2)-1)/2)+[1:n]) = im1; 
im2pad(floor((blksize(1)-1)/2)+[1:m], floor((blksize(2)-1)/2)+[1:n]) = im2; 

rows = [0:blksize(1)-1]; cols = [0:blksize(2)-1];

chmask = zeros(size(im1));

% x, y are the corresponding blocks of the two images
precision = 0.01;   % This precision is used to calculate the number of bits 
                    % needed to store a floating point number.

% number of bits needed to store the two sigmas with the given precision.
log2_s0 = log2(abs(sigma0)/precision + 1);
log2_s1 = log2(abs(sigma1)/precision + 1);

% K1_0 and K1_1 are Gaussian normalizing constants.
K1_0 = (N/2)*log2(2*pi*sigma0^2);
K1_1 = (N/2)*log2(2*pi*sigma1^2);

e = exp(1.0);   % e
% K2_0 and K2_1 are normalizing constants
K2_0 = log2(e)/(2*sigma0^2);
K2_1 = log2(e)/(2*sigma1^2);

for i=1:m,    
  for j=1:n,
    x = im1pad(i+rows,j+cols);
    y = im2pad(i+rows,j+cols);
    
    d = x-y;
    d = d(:);    
    mu = mean(d);
    d_u = d - mu;
    log2_mu = log2(abs(mu)/precision + 1);
        
    % Calculate the Description lengths for H0 and H1
    H0_DL = log2_s0 + log2_mu + K1_0 + K2_0*(d_u'*d_u);    
    H1_DL = log2_s1 + log2_mu + K1_1 + K2_1*(d_u'*d_u);
    
    % Pick the one with the MDL
    if (H1_DL < H0_DL) chmask(i,j) = 1; end;
    
    chmask(i,j) = H0_DL - H1_DL;
        
  end
end

% write the output to a file,
imwrite(chmask, [output, 'tif'], 'tiff');