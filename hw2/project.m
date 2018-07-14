function [x] = project(X,cam);

% function [x] = project(X,cam)
%
% Carry out projection of 3D points into 2D given the camera parameters
% We assume that the camera with the given intrinsic parameters produces
% images by projecting onto a focal plane at distance cam.f along the 
% z-axis of the camera coordinate system.
%
% Our convention is that the camera starts out the origin (in world
% coordinates), pointing along the z-axis.  It is first rotated by 
% some matrix cam.R and then translated by the vector cam.t.
%
%
% Input:
%
%  X : a 3xN matrix containing the point coordinates in 3D world coordinates (meters)
%
%  intrinsic parameters:
%
%  cam.f : focal length (scalar)
%  cam.c : image center (principal point) [in pixels]  (2x1 vector)
%
%  extrinsic parameters:
%
%  cam.R : camera rotation matrix (3x3 matrix)
%  cam.t : camera translation matrix (3x1 vector)
%
%
% Output:
%
%  x : a 2xN matrix containing the point coordinates in the 2D image (pixels)
%

if nargin ~= 2
    error('Must have two arguments');
end

if isempty(X)
    error('Input X is empty');
end

if size(X,1) ~= 3
    error('X must be a 3xN array');
end

if ~isstruct(cam)
    error('cam must be a struct');
end



% 1. transform the points in the world to the camera coordinate frame

x = cam.R \ (X - repmat(cam.t,1,size(X,2)));


% 2. check to see which points are in front of the camera and print
% a message to the console indicating how many points are in front 
% of the camera... this can be useful for debugging later on.

front = length(find(x(3,:)>0));
disp(['There are ', num2str(front), ' points in front of the camera']);


% 3. project the points down onto the image plane and scale by focal length
% 4. add in camera principal point offset to get pixel coordinates

x = [cam.f 0 cam.c(1); 0 cam.f cam.c(2); 0 0 1] * x;
x = x(1:2,:) ./ x(3,:);


