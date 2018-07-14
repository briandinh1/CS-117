
function err = project_error(params,X,x,cx,cy)


% function [x] = project_error(params,X,x,cx,cy)
%
%
% Input:
%
% params : an 7x1 vector containing the camera parameters which we 
%   will optimize over.  this should include:
% 
%    f - the focal length 
%    thx,thy,thz - camera rotation around the x,y and z axis
%    tx,ty,tz - camera translation vector entries
%   
%    cx,cy - the camera center.  we will just assume this is the 
%      center of the image so we won't optimize over it  (it is not part of params)
%
% X: a 3xN matrix containing the point coordinates in 3D world coordinates (meters)
%
% x: a 2xN matrix containing the point coordinates in the camera image (pixels)
%
% Output:
%
%  err : a 2xN matrix containing the difference between x and project(X,cam)
%
%

if nargin ~= 5
    error('Must have 5 arguments');
end

if isempty(params)
    error('Input params is empty');
end

if isempty(X)
    error('Input X is empty');
end

if isempty(x)
    error('Input x is empty');
end

if size(params,1) ~= 7
    error('params must be 7x1');
end

if size(params,2) ~= 1
    error('params must be 7x1');
end

if size(X,1) ~= 3
    error('X must be 3x1');
end

if size(x,1) ~= 2
    error('x must be 2x1');
end

if ~isscalar(cx)
    error('cx must be a scalar');
end

if ~isscalar(cy)
    error('cy must be a scalar');
end




% unpack parameters and build up cam data structure needed by the project function
% params: 1 = f, 2 = thx, 3 = thy, 4 = thz, 5 = tx, 6 = ty, 7 = tz
cam.f = params(1);
cam.c = [cx;cy];
cam.R = build_rotation(params(2),params(3),params(4));
cam.t = [params(5);params(6);params(7)];


% compute projection
% compute the vector of reprojection errors
err = x -  project(X,cam);

end

