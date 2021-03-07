function phi = evolution_li(phi0, mu, lambda, nu, g, gx, gy, delta_t, epsilon, numIter)
%   evolution_withoutreinit(I, phi0, mu, nu, lambda_1, lambda_2, delta_t, delta_h, epsilon, numIter);
%   input: 
%       I: input image
%       phi0: level set function to be updated
%       mu: weight for phi blendign enger 
%       lambda: LengthTerm coefficient
%       nu: areaTerm coefficient
%       g: edge indicator
%       gx, gy: gradient of edge indicator g
%       delta_t: time step
%       epsilon: used for the dirac function
%       numIter: number of iterations

%   output: 
%       phi: updated level set function


% I = BoundMirrorExpand(I);
phi = BoundMirrorExpand(phi0);
% edge indicator function g
% div(gV) = V \times grad(g) + g.*div(V)
[phi_x, phi_y] = gradient(phi);
% normalize the function
temp = sqrt(phi_x.^2+phi_y.^2+1e-10);
phi_x = phi_x./temp;
phi_y = phi_y./temp;

for k = 1:numIter
    phi = BoundMirrorEnsure(phi);
    % \Delta_\epsilon term
    delta_h = Delta(phi, epsilon);
    % Surface phi's curvature
    Curv = curvature(phi);

    % div(g*Df/|Df|)
    Curv_g = phi_x.*gx + phi_y.*gy + g.*Curv;
    
    % Each term
    distRictTerm = mu * (del2(phi) - Curv);
    lengthTerm = lambda * delta_h .* Curv_g;
    areaTerm = nu * g .* delta_h;
    
    % updating the phi function
    delta_phi_dt = distRictTerm + lengthTerm + areaTerm;
    phi = phi+delta_t*delta_phi_dt;
end

phi = BoundMirrorShrink(phi); % Remove the edge of the extension
