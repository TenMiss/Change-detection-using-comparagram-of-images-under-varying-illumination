clear all
close all
clc
load data3_1.mat
A=GY{1};%figure,imshow(A);title('Image A');
B=GY{3};%figure,imshow(B);title('Image B');
% A = imread('YC_1_010.tif'); A = rgb2gray(A);figure,imshow(A);title('Image A');
% B = imread('YC_1_025.tif'); B = rgb2gray(B);figure,imshow(B);title('Image B');
A=double(A); B=double(B);
[row,col,h]=size(A);
%%%%%%%%%%%%%%%%%%%%%monotonous
Amean = mean(A(:)); Bmean = mean(B(:));
if Amean<Bmean
    DIF = A-B;
else
    DIF = B-A;
end
MONO = DIF>0;
NUM = find(MONO(:)==true);
% Generates a comparagram from two image matrices
% Find size of comparagram and initialize
dim = max(max(max(max(A),max(B)))) - min(min(min(min(A),min(B)))) + 1;
C = zeros(dim,dim);
TT = 1:row*col;
TOT = setdiff(TT',NUM);
PA = A(TOT)+1; 
PB = B(TOT)+1;
for k = 1:length(TOT)
    C(PA(k),PB(k)) =  C(PA(k),PB(k)) + 1;
end

figure,image(C);title('\bf Comparagram of I_1 and I_2');
xlabel('\bf I_1 intensity');ylabel('\bf I_2 intensity')
axis([0  255  0  255])
colormap gray
colorbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure,plot(C(180,:));xlabel('intensity');ylabel('No of pixels');
[vv,num]= max(C,[],2);
LKTable = num';
sigma = zeros(1,dim);
for i = 1:dim
    HG = C(i,:);
    matchPix = LKTable(i);    
    b = 1:dim;
    DS = abs(b - matchPix);
    W = 1-DS/dim;    
    sigma(i) = sqrt(sum(W.*HG.*DS.^2)/sum(W.*HG));     
end
%figure,plot(sigma),title('Sigma');    

[row,col,h]=size(A);
BW = false(row,col);
for i = 1:row*col
    a = A(i)+1;
    matchPix = LKTable(a)-1;
    BW(i)= abs(matchPix-B(i))> 4* ceil(sigma(a));
    
end
figure,imshow(BW);title('Change detection by our method');

%%%% Fix thresholding
BW = false(row,col);
for i = 1:row
    for j = 1:col
        a = A(i,j)+1;
        matchPix = LKTable(a)-1;
        if abs(matchPix-B(i,j))> 35
            BW(i,j)= true;
        end
    end
end
figure,imshow(BW);title('Change detection by comparagram with fixed threshold');


