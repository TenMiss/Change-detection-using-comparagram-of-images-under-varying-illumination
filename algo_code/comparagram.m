%% Taken from Corey Manders
% Generates a comparagram from two image matrices
function [C,Cl] = comparagram(image1, image2)

if nargin ~= 2
    error('Arguments: (''jpeg-filename1'', ''jpeg-filename2'') OR (matrix1, matrix2)');
end

if ischar(image1) & ischar(image2)
	A = imread(image1,'jpeg');
	B = imread(image2,'jpeg');
	A=double(A);
	B=double(B);
elseif isnumeric(image1) & isnumeric(image2)
    % For matrix input, A and B must be integers!
    image1 = double(image1);
    image2 = double(image2);
    A = round(image1);
    B = round(image2);
else
    error('Both arguments must be either strings or numeric matrices of type ''double''!');
end

% figure(1);
% subplot(2,2,1);
% image(uint8(A));
% title('Image A');
% subplot(2,2,2);
% image(uint8(B));
% title('Image B');

% Find size of comparagram and initialize
dim = max(max(max(max(A),max(B)))) - min(min(min(min(A),min(B)))) + 1;
colors = min(size(A,3),size(B,3));
C = zeros(dim,dim,colors);

% For each pixel, compare value in each image and fill comparagram entries.
% Images with more than one color plane will use all planes added together in C.
% (as a result, using color filters on the camera will skew the comparagram)
% This algorithm will only add up common pixels to both images,
% if the images have different dimensions, non-common pixels will be ignored!
% (note that if you add up all the entries in a comparagram, you get
% the total number of elements in each of the images being compared!)
for plane = 1:min(size(A,3),size(B,3))
	for row = 1:min(size(A,1),size(B,1))
        for col = 1:min(size(A,2),size(B,2))
            a = A(row,col,plane) + 1; % add 1 because matrix indices start at 1!
            b = B(row,col,plane) + 1; % add 1 because matrix indices start at 1!
            C(a,b,plane) = C(a,b,plane) + 1;
        end
	end
end

% plot comparagram of data, using logarithm for smoothing
%subplot(2,2,3);
Cl = log(C+1e-100); % add epsilon=1e-100 to prevent log(0)
Cl(find(Cl < 0)) = 0; % remove effects of epsilon (elements less than 0)
Cl = Cl/max(max(max(Cl))); % scale image data to be between 0-1
% imagesc(Cl);
% title('Logarithmic Comparagram of A vs. B (A,B)');

