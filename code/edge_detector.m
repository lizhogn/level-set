function g=edge_detector(I,sigma)
% Image Edge Indicator function:
% g = 1/(1+laplas(G_delta(x,y))*I)
% input:
%       I: input image
%       sigma: Gaussian Filter kernel
% I = BoundMirrorExpand(I);
G=fspecial('gaussian',15,sigma);
Img_smooth=conv2(I,G,'same');  % smooth image by Gaussiin convolution
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % edge indicator function.