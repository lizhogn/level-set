%   Matlad code implementing Chunming-Li model in the paper 
%   'Level Set Evolution Without Re-initialization: A New Variational Formulation'

% author: lizhogn
% date: 2020/12/10

clc;clear;
close all

%% load the image
Img = imread('vessel.bmp');
% get the first channel if Image is RGB
I = double(Img(:,:,1));

%% Initialize the phi function
% get the image size
[nrow, ncol] = size(I);

% initialize the Signed distance function \phi
ic = nrow/2;
jc = ncol/2;
r = 20;
% phi_0 = sdf2circle(nrow, ncol, ic, jc, r);

%initialize LSF as binary step function
c0=2;
initialLSF=c0*ones(size(I));
initialLSF(5:nrow-5, 5:ncol-5)=-c0;  
phi_0=initialLSF;

%% Set paramaters
% update frequency
delta_t = 5; 
% lambda > 0 and nu are constants
% mu is the penalizes term
mu = 0.2/delta_t; lambda = 5; nu = 1.5;
epsilon = 1.5;

%% Iteration initialize
phi = phi_0;
figure(2);
subplot(1,2,1); mesh(phi);
subplot(1,2,2); imagesc(uint8(I)); colormap(gray);
hold on;
plotLevelSet(phi, 0, 'r');
sigma=1.5;
g=edge_detector(I, sigma);% edge indicator function
[gx,gy]=gradient(g); % will be used in the div(gV)

%% Starting initialize
numIter = 5;
for k = 1:200
    phi = drlse_edge(phi, g, lambda, mu, nu, epsilon, delta_t, numIter, 'double-well');
%     phi = evolution_li(phi, mu, lambda, nu, g, gx, gy, delta_t, epsilon, numIter)
    % visualization
    if mod(k,4)==0
        pause(.05);
        fig = figure(2); clc; axis equal; 
        fig.Position = [461 519 961 331];
        title(sprintf('Itertion times: %d', k));
        subplot(1,2,1); mesh(phi);colormap(jet);
        subplot(1,2,2); imagesc(uint8(I)); colormap(gray);
        hold on; plotLevelSet(phi,0,'r');
    end    
end





