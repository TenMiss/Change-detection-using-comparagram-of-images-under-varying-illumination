function chblk = lineardep(xx, yy)

% Author: Srinivas Andra
% INPUT/OUTPUT ARGUMENTS
% xx:       block of pixel values from image 1
% yy:       corresponding block of pixel values from image 2
% chblk:    is the change intensity value. This value is thresholded 
% to get the binary change mask
% Description:  Linear Dependence detector.
% This program is called from 'block_slidingmain.m', see there for more
% details
        
        t = size(xx);
        tempxx = xx';
        xxvect = tempxx(:); % block is converted into a vector
        
        tempyy = yy';
        yyvect = tempyy(:); % block is converted into a vector
        
% to avoid division by zero, we add 1 to both numerator and denominator
         quo = (xxvect + 1) ./ (yyvect + 1);
% testing the variance of the quotient as given in Skifstad and Jain
        test = var(quo);
        chblk = test;
