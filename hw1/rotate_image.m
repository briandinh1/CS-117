function Irot = rotate_image(I,angle)
 % 
 %   This function takes an image I and creates a new version of the image
 %   which is rotated by amount angle
 %
 % arguments:
 %
 %   I - the original grayscale image, stored as a matrix
 %   angle - the amount by which to rotate the image
 %
 % return value:
 %   
 %   Irot - an image which containing the rotated original
 %

if nargin ~= 2
    error('Must have two arguments');
end

if isempty(I)
    error('Image matrix is empty');
end

if size(I,3) == 3
    error('Image I must be a grayscale image');
end

if ~isscalar(angle)
    error('Angle must be scalar value');
end

[h,w] = size(I);

if mod(h,2) == 0
    if mod(w,2) == 0
        [xcoord,ycoord] = meshgrid(-(w/2):(w/2)-1, -(h/2):(h/2)-1);
    else
        [xcoord,ycoord] = meshgrid(-((w-1)/2):((w-1)/2), -(h/2):(h/2)-1);
    end
else
    if mod(w,2) == 0
        [xcoord,ycoord] = meshgrid(-(w/2):(w/2)-1, -((h-1)/2):((h-1)/2));
    else
        [xcoord,ycoord] = meshgrid(-((w-1)/2):((w-1)/2), -((h-1)/2):((h-1)/2));
    end
end

X = [xcoord(:) ycoord(:)]';
Ivector = I(:)';

Xrot = rotate(X,-angle);
xmin = round(min(Xrot(1,:)));
xmax = round(max(Xrot(1,:)));
ymin = round(min(Xrot(2,:)));
ymax = round(max(Xrot(2,:)));

[newxcoord,newycoord] = meshgrid(xmin:xmax,ymin:ymax);

Irot = griddata(Xrot(1,:),Xrot(2,:),Ivector,newxcoord(:),newycoord(:));
Irot = reshape(Irot,size(newxcoord)); 

end