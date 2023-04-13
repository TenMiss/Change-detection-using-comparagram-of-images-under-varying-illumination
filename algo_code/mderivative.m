
function chblk = mderivative(xx, yy)
% Author: Srinivas Andra
% INPUT/OUTPUT ARGUMENTS
% xx:       block of pixel values from image 1
% yy:       corresponding block of pixel values from image 2
% chblk:    is the change intensity value. This value is thresholded 
% to get the binary change mask

% Description:  Derivative model
% This program is called from 'block_slidingmain.m', see there for more
% details

[m,n] = size(xx);

% Construction of the co-ordinate matrix C for the quadratic model

for i = 1:m
    for j = 1:n   
        C(n*(i-1)+j, :) = [1, i, j, i*i, j*j, i*j];
    end
end

% Function value matrix A
tempxx = xx';
A = tempxx(:); % block is converted into a vector
paramxx = C\A; % least-squares solution
% paramxx is a vector containing the quadratic model parameters for block
% xx
tempyy = yy';
B = tempyy(:); % block is converted into a vector
paramyy = C\B; % least-squares solution
                   % paramyy is a vector containing the quadratic model parameters for block yy
    
    % evaluating the derivatives of the quadratic models at each pixel in the block
for i = 1:m
    for j = 1:n   
        f1x((n*(i-1))+j) = paramxx(2) + 2 * paramxx(4) * i + paramxx(6) * j;   
        f1y((n*(i-1))+j) = paramxx(3) + 2 * paramxx(5) * j + paramxx(6) * i;   
        f2x((n*(i-1))+j) = paramyy(2) + 2 * paramyy(4) * i + paramyy(6) * j;   
        f2y((n*(i-1))+j) = paramyy(3) + 2 * paramyy(5) * j + paramyy(6) * i;      
    end
end
diff = mean(abs(f1x - f2x) + abs(f1y - f2y));
chblk = diff;
