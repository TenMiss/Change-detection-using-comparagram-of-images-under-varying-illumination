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

function [sigma0, sigma1] = calculate_sigmas(diff, L);

% Author: Omar Al-Kofahi
% INPUT ARGUMENTS
% diff:         difference image,
% L:            block variable, L is the left/right displacement
% from the center pixel to cover the block, see how the area of the square
% block is calculated from L below,

% Description:  Given the difference image, estimate the noise variance
% (the null hypothesis) from regions with no change. Those regions are
% identified by having the lowest variance in the difference image. For the
% alternative hypothesis, the variance is estimated from regions where the
% variance in the differene image is maximum.

L2 = (2*L+1)^2;     % square block area
[m,n] = size(diff);

minSTD = 9999999;  % Large number
maxSTD = -9999999; % Small number
for i = L+1:m-L-1,
    for j = L+1:n-L-1,
        
        tmp = diff(i-L:i+L, j-L:j+L);
        STD = std2(tmp);
        
        if STD < minSTD,
            minSTD = STD;
            min_i = i;
            min_j = j;
        end;
        
        if STD > maxSTD,
            maxSTD = STD;
            max_i = i;
            max_j = j;
        end;
        
    end;
end;

% Once you have these values, estimate sigma0 and sigma1, for unchanged and
% changed regions, respectively.

tmp = diff(min_i-L:min_i+L, min_j-L:min_j+L);
sigma0 = std2(tmp);

tmp = diff(max_i-L:max_i+L, max_j-L:max_j+L);
sigma1 = std2(tmp);
