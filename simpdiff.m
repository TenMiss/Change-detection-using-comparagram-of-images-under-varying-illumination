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

function diff = simpdiff(file1, file2, output, th, fig);
% Author: Srinivas Andra
% INPUT ARGUMENTS: 
% file1: first image
% file2: second image
% output: output binary change mask file name
% th: threshold 
% fig: figure window number in which the binary change mask is to be displayed
% Note that the input/output file names should be provided without the
% extension, see how images are read below.

% Description:  Simple differencing change detector.


% reading both the images
im1 = imread([file1,'.tif']); 
im2 = imread([file2,'.tif']);

% finding the absolute difference 
diff = imabsdiff(im1, im2);

% thresholding to obtain a binary change mask
diff = im2bw(diff, th);

% displaying the binary change mask
% and writing the binary change mask into an 
% output file

figure(fig); clf;
imshow(diff);
imwrite(diff, [output,'.tif'], 'tif');
