function R = build_rotation(thx,thy,thz)

if nargin ~= 3
    error('Must have 3 arguments');
end

if ~isscalar(thx)
    error('thx must be a scalar');
end

if ~isscalar(thy)
    error('thy must be a scalar');
end

if ~isscalar(thz)
    error('thz must be a scalar');
end


Rx = [1 0 0; 0 cos(thx) -sin(thx);0 sin(thx) cos(thx)];
Ry = [cos(thy) 0 -sin(thy); 0 1 0; sin(thy) 0 cos(thy)];
Rz = [cos(thz) -sin(thz) 0; sin(thz) cos(thz) 0; 0 0 1];
R = Rx*Ry*Rz;
    
end