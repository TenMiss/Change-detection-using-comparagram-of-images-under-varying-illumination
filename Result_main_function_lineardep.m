%function main_function(file1, file2, output, blksize, fun);

% INPUT ARGUMENTS,
% file1:    first image
% file2:    second image
% output:   output binary change mask file name
% blksize:  size of the block (2-vector), for e.g., enter as [20, 20]
% fun:      change detection algorithm
% Note that the input/output file names should be provided without the
% extension, see how images are read below. tiff input/output images are
% assumed

% Description:  Given a pair of images, this function acts as the main
% function; it creats the blocks, and calls the proper routine with the
% proper arguments.
close all
load data3_1.mat
blksize = [2,2];
%th = 0.3;
output = 'H:\Electronics Letters\algo_code\lineardep';
% reading the two images
% file1 = 'H:\ForTest\FirstStillCamMovObj\YC_1_025';
% file2 = 'H:\ForTest\FirstStillCamMovObj\YC_1_040';
% im1 = imread([file1,'.tif']);
% im2 = imread([file2,'.tif']);
im1 = GY{1};
im2 = GY{3};

tic
im1 = double(im1);
im2 = double(im2);

% note: both images are assumed to be of the same size
[m,n] = size(im1); 

% im1pad and im2pad are images padded with '0's - for edge/corner pixels to 
% allow block-based processing
im1pad = zeros(size(im1)+blksize-1);
im2pad = im1pad;

im1pad(floor((blksize(1)-1)/2)+[1:m], floor((blksize(2)-1)/2)+[1:n]) = im1; 
im2pad(floor((blksize(1)-1)/2)+[1:m], floor((blksize(2)-1)/2)+[1:n]) = im2; 

rows = [0:blksize(1)-1]; cols = [0:blksize(2)-1];

chmask = zeros(size(im1));

% x, y are the corresponding blocks of the two images

for i=1:m,
  for j=1:n,
    x = im1pad(i+rows,j+cols);
    y = im2pad(i+rows,j+cols);

    % feval calls the "fun" with the blocks of pixels as the input and 
    % returns the test-statistic evaluated for the function "fun". This
    % value is stored at the centeral pixel.
    chmask(i,j) = feval(@lineardep,x,y); 
    %chmask(i,j) = mderivative(x, y);
  end
end

chmask = chmask/max(max(chmask)); % chmask is the real-valued change mask
time =toc
figure;
imshow(chmask);
title('Change detection by shading model')
%imwrite(chmask, [output,'.tif'], 'tif');