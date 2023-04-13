function LRT(file1, file2, output, blksize);
% Author: Omar Al-Kofahi
% INPUT ARGUMENTS
% file1:    first image
% file2:    second image
% output:   output binary change mask file name
% blksize:  block size
% displayed
% Note that the input/output file names should be provided without the
% extension, see how images are read below.

% Description:  Given the two images, decide whether or not change occured
% at every pixel by looking at the neighborhood, and estimating the
% likelihood ratio test.

% reading the two images
im1 = imread([file1,'.tif']);
im2 = imread([file2,'.tif']);

im1 = double(im1);
im2 = double(im2);

[m,n] = size(im1);

% Estimate the noise variance..
[sigma0, sigma1] = calculate_sigmas(im1-im2, blksize(1,1));


% Now, assuming equal costs in wrong decision, and zero costs in right
% decision, and that p(H0) = p(H1), we get t in (3) equal to 1. thus, the
% threshold for equation 15 is 1, if you take the log on both sides, and
% reorder, you get the sum of square differences on the LHS, and the rest
% on the RHS;
% To calculate the threshold:
N = blksize(1)*blksize(2);
th = (log((sigma0^N)/(sigma1^N)))/(1/(2*sigma1^2) - 1/(2*sigma0^2))

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
N = blksize(1)*blksize(2);
for i=1:m,
  for j=1:n,
    x = im1pad(i+rows,j+cols); %+1;
    y = im2pad(i+rows,j+cols); %+1;
    
    d = abs(x-y);
    d = d(:);
    s = (d' * d);

    chmask(i,j) = s;
  end
end

% Scale the chmask down..
th = th/max(max(chmask));
chmask = chmask/max(max(chmask));


% Find the binary mask for the given threshold
mask = im2bw(chmask, th);
% write it to a file,
imwrite(mask, [output, 'tif'], 'tiff');