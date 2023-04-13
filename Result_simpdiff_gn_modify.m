%function simpdiff_gn(file1, file2, output, blksize, th, fig);
% Author: Srinivas Andra
% INPUT ARGUMENTS: 
% 1. file1: first image
% 2. file2: second image
% 3. output: output binary change mask file name
% 4. blksize: size of the block (2-vector) 
% 5. th: threshold 
% 6. fig: figure window number in which the binary change mask is to be displayed
% Note that the input/output file names should be provided without the
% extension, see how images are read below.

% Description:  Simple differencing change detector, with intensity
% normalization to reduce the illumination effect.

close all
%blksize = [5,5];
blksize = [3,3];
th = 0.1;

im1 = GY{1};
im2 = GY{6};
[m,n] = size(im1); 
% padd the image with the appropriate number of zero-rows and zero-columns 
% such that when blocks are centered at boundary pixels, the whole block 
% is included within the padded image.
mpad = rem(m, blksize(1));
if mpad > 0, mpad = blksize(1) - mpad; 
end

npad = rem(n, blksize(2));
if npad > 0, npad = blksize(2) - npad; 
end

% im1pad and im2pad are images padded with '0's - for edge/corner boxes to
% allow block-based processing
im1pad = zeros(m+mpad, n+npad);
im2pad = zeros(m+mpad, n+npad);

im1pad(1:m, 1:n) = double(im1);
im2pad(1:m, 1:n) = double(im2);

mb = blksize(1);
nb = blksize(2);

rows = 1:mb; cols = 1:nb;

% calcualte the number of blocks
mblocks = (m + mpad) / mb; % number of bloks in i-direction (rows)
nblocks = (n + npad) / nb; % number of bloks in j-direction (cols)


% Now, for each block, normalize the intensities in both images such that
% they have the same mean and variance.
for ii = 0:(mblocks - 1)    % indices in both i- and j-directions 
  for jj = 0:(nblocks - 1)  
      
    xx = im1pad(ii * mb + rows, jj * nb + cols); % corresponding blocks of pixels in
    yy = im2pad(ii * mb + rows, jj * nb + cols); % the two images
    
    if (yy ~= xx) % if the pixel values in the two blocks are not the same
                  % in which case it is not necessary to normalize  
        denom = std2(yy);   % standard deviation
        
        % to avoid division by zero
        if denom == 0 
            denom = denom + 1;
        end;
        
        yy = (std2(xx)/denom)*(yy - mean2(yy)) + mean2(xx); % the pixels in the second block are 
    end;                                                    % normalized to have the same mean and variance as those
                                                            % in the first block    
    
    abs_different(ii * mb + rows, jj * mb + cols) = imabsdiff(xx, yy); % simple differencing is performed between the
                                                                % first image and the normalized second image
   end;  
end;

abs_different = mat2gray(abs_different);  % converting the matrix into a gray-scale image
chmask = im2bw(abs_different, th); % thresholding the gray-scale image to obtain the 
%figure,imshow(chmask)       % binary change mask    
                            
% the change mask with the same size as the original images, no padding,
chmask_no_padding = chmask(1:m, 1:n);

% displaying the binary change mask
% and writing the binary change mask into an 
% output file
                           
%figure(fig); clf;
%figure,imshow(chmask);
%imwrite(chmask_no_padding, [output,'.tif'], 'tiff');
% for i = 1:5
%     chmask = im2bw(abs_different, 0.1*i);
%     figure,imshow(chmask);
% end
chmask = im2bw(abs_different, 0.05);
figure,imshow(chmask);
SE = strel('disk',2);
minArea =100;
chmask = bwareaopen(chmask,minArea);
chmask = ~chmask;
chmask = bwareaopen(chmask,minArea);
chmask = ~chmask;
chmask = imerode(chmask,SE);
figure,imshow(chmask)
chmask = imdilate(chmask,SE);
figure,imshow(chmask)

