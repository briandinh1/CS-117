function Xrot = rotate(X,angle)
 % 
 %   This function takes a set of points stored in X and
 %   applies a rotation specified by angle.
 %   
 % arguments: 
 %
 %   X :  a 2xN matrix of points where the first row gives the x coordinate
 %        of each point and the second row gives the y coordinate of each point
 %
 %   angle : the amount to rotate counter-clockwise, in degrees
 %
 %
 % return value:
 %  
 %  Xrot : a 2xN matrix containing the rotated points.
 %   

if nargin ~= 2
    error('Must have two arguments');
end

if isempty(X)
    error('Input X is empty');
end

if size(X,1) ~= 2
    error('X must be a 2xN array');
end

if ~isscalar(angle)
    error('Angle must be scalar value');
end

Xrot = [cosd(angle) -sind(angle); sind(angle) cosd(angle)] * X;
 
end