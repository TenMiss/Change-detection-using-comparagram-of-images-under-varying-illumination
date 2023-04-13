function chblk = linearmod(xx, yy)

% INPUT/OUTPUT ARGUMENTS
% xx:       block of pixel values from image 1
% yy:       corresponding block of pixel values from image 2
% chblk:    is the change intensity value. This value is thresholded 
% to get the binary change mask

% Description:  implements Hsu's polynomial fitting, linear model.
% This program is called from 'block_slidingmain.m', see there for more
% details

[m,n] = size(xx);

% Construction of the co-ordinate matrix C
for i = 1:m
    for j = 1:n   
        C(n*(i-1)+j, :) = [1, i, j];
    end
end

% Function value matrix A

    tempxx = xx';
    A = tempxx(:); % block is converted into a vector
    paramxx = C\A; %least-squares solution
                   % paramxx is a vector containing the linear model parameters for block xx
    tempyy = yy';
    B = tempyy(:); % block is converted into a vector
    paramyy = C\B; % least-squares solution
                   % paramyy is a vector containing the linear model parameters for block yy

    % finding the error variances with linear model fitting    
    % variance for block xx
    D1 = (A - (C * paramxx)) .* (A - (C * paramxx));    
    var1 = mean(D1);        
    
    % variance for block yy
    D2 = (B - (C * paramyy)) .* (B - (C * paramyy));    
    var2 = mean(D2);       
    
    % fitting the same linear model for both the blocks
    C2 = [C;C];
    E = [A;B]; 
    paramxy = C2\E; %least-squares solution
                    % paramxy is a vector containing the linear model parameters when the same linear model 
                    % is fit to both the blocks

    % error variance from both the blocks when same linear model is fit to both the blocks
    
    D0 = (E - (C2 *paramxy)) .* (E - (C2 * paramxy));    
    var0 = mean(D0);
   
    % likelihood ratio "yratio"    
    yratio = (var0 * var0)/(var1 * var2);
    % likelihood ratio is returned to the main function
    chblk = yratio;
