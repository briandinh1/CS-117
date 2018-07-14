function X = triangulate(xL,xR,camL,camR)

%
%  function X = triangulate(xL,xR,camL,camR)
%
%  INPUT:
%   
%   xL,xR : points in left and right images  (2xN arrays)
%   camL,camR : left and right camera parameters
%
%
%  OUTPUT:
%
%    X : 3D coordinate of points in world coordinates (3xN array)
%
%

if nargin ~= 4
    error('Must have four arguments');
end

if isempty(xL)
    error('Input xL is empty');
end

if isempty(xR)
    error('Input xL is empty');
end

if size (xL,1) ~= 2
    error('xL must be a 2xN array');
end

if size (xR,1) ~= 2
    error('xR must be a 2xN array');
end

if ~isstruct(camL)
    error('camL must be a struct');
end

if ~isstruct(camR)
    error('camR must be a struct');
end



% 1. convert xL and xR from pixel coordinates back into meters with unit focal 
% length by subtracting off principal point and dividing through by 
% focal length...  call the results qR and qL.

qR = (xR-camR.c) / camR.f;
qR = [qR; ones(1,size(qR,2))];

qL = (xL-camL.c) / camL.f;
qL = [qL; ones(1,size(qL,2))];


% 2. make the right camera the origin of the world coordinate system by 
% transforming both cameras appropriately in order to find the rotation
% and translation (R,t) relating the two cameras

R = camR.R \ camL.R;
t = camR.R \ (camL.t-camR.t);


% 3. Loop over each pair of corresponding points qL,qR and 
% solve the equation:  
%
%   Z_R * qR = Z_L * R * qL + t
%
% for the depth values Z_R and Z_L using least squares.
%

u = zeros(2,size(qR,2));
for i = 1:size(qR,2)
    u(:,i) = [qR(:,i) -R*qL(:,i)] \ t;
end


% 4. use Z_R to compute the 3D coordinates XR = (X_R,Y_R,Z_R) in right camera
% reference frame

XR = qR .* u(1,:);


% 5. since the right camera wasn't at the origin, map XR back to world coordinates 
% X using the right camera transformation parameters.

X = (camR.R*XR) + camR.t;



