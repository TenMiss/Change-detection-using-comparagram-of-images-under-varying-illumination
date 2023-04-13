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

function chblk = constmod(xx, yy)
% Author: Srinivas Andra
% INPUT/OUTPUT ARGUMENTS
% xx:       block of pixel values from image 1
% yy:       corresponding block of pixel values from image 2
% chblk:    is the change intensity value. This value is thresholded 
% to get the binary change mask

% Description:  implements Hsu's polynomial fitting, constant model.
% This program is called from 'main_function.m', see there for more
% details

    [m,n] = size(xx);

    tempxx = xx';
    A = tempxx(:); % block is converted into a vector
    
    tempyy = yy';
    B = tempyy(:); % block is converted into a vector
    
    % formulae directly from the Hsu's paper
    
    var1 = var(A);
    var2 = var(B);
    var0 = ((var1 + var2)/2) + ((mean(A) - mean(B))/2)^2;
       
   % likelihood ratio "yratio"        
   yratio = var0^2/(var1 * var2);
   % likelihood ratio is returned to the main function 
   chblk = yratio;
