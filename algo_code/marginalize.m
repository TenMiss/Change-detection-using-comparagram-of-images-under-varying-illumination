%% Taken from Corey Manders
% Generates a comparagraph from a comparagram
function Cm = marginalize(C)

if nargin ~= 1
    error('Argument: Comparagram matrix to be converted to Comparagraph (preferably with logarithmic scale)');
end

% Normalize comparagram to logarithmic scale (using epsilon)
epsilon = 1e-100;
C = log(C + epsilon) - log(epsilon);

% Get marginals of comparagram (sums of rows & columns)
% sum down colums for hb
hb = sum(C);

% Rotate plot to be more intuitive
for t = 1:size(C,3)
    C(:,:,t) = rot90(C(:,:,t));
end

% Sum down columns again for ha (or rows, now that C is rotated)
ha = sum(C);

% Plot given comparagram of data
% figure(2);
% imagesc(C/max(max(max(C))));
% title('Input Comparagram (A,B), rotated for origin at bottom left (B,A)');

% If more than one color plane available, reshape ha and hb to 2D
if size(C,3) > 1
    ha2(1:size(C,1),1:size(C,3),1) = ha(1,1:size(C,1),1:size(C,3));
    ha = ha2;
    hb2(1:size(C,2),1:size(C,3),1) = hb(1,1:size(C,2),1:size(C,3));
    hb = hb2;
else % Otherwise, just make sure that ha and hb are column vectors
    ha = ha';
    hb = hb';
end

%%Plot histographs (histograms modified by a logarithmic scaling
figure(3);
subplot(2,2,1);
plot(ha);
title('Histograph for A');
subplot(2,2,2);
plot(hb);
title('Histograph for B');

% Get cumulative sums of ha and hb
Ha = cumsum(ha);
Hb = cumsum(hb);

subplot(2,2,3);
plot(Ha,1:length(Ha),Hb,1:length(Hb));
title('Cumulagraph of Ha and Hb (Cumulative sums of ha and hb)');

% Create comparagraph equivalent of comparagram
% In the rotated comparagram, A is across columns, and B is across rows,
% hence, row values are from Ha, and column values are from Hb.
% Numerically, we are plotting the values of Ha through the inverse of Hb
Cm = zeros(length(Ha),length(Hb),size(C,3));
for z = 1:size(C,3)
	x = 1:length(Ha);
	for t=1:length(Ha)
		if isempty(min(find(Hb(:,z) >= Ha(t,z))))
            y(t) = max(find(Hb(:,z) <= Ha(t,z)));
        else
        	y(t) = min(find(Hb(:,z) >= Ha(t,z)));
        end
        Cm(y(t),t,z) = 1;
	end
end

% Display resulting Comparagraph (flipped top to bottom, so origin is at bottom left)
subplot(2,2,4);
imagesc(1:1:size(Cm,2),size(Cm,1):-1:1,Cm)
title('Monotonic Comparagraph (B,A) in matrix format (with origin at lower left)');

