function [C,goodpixels] = decode(imageprefix,start,stop,threshold)

% function [C,goodpixels] = decode(imageprefix,start,stop,threshold)
%
%
% Input:
%
% imageprefix : a string which is the prefix common to all the images.
%
%                  for example, pass in the prefix '/home/fowlkes/left/left_'  
%                  to load the image sequence   '/home/fowlkes/left/left_01.jpg' 
%                                               '/home/fowlkes/left/left_02.jpg'
%                                                          etc.
%
%  start : the first image # to load
%  stop  : the last image # to load
% 
%  threshold : the pixel brightness should vary more than this threshold between the positive
%             and negative images.  if the absolute difference doesn't exceed this value, the 
%             pixel is marked as undecodeable.
%
% Output:
%
%  C : an array containing the decoded values (0..1023) 
%
%  goodpixels : a binary image in which pixels that were decodedable across all images are marked with a 1.

if nargin ~= 4
   error('Must have 4 arguments');
end

if ~ischar(imageprefix)
    error('imageprefix is the wrong type');
end

if ~isscalar(start)
    error('start must be a scalar');
end

if ~isscalar(stop)
    error('stop must be a scalar');
end

if ~isscalar(threshold)
    error('threshold must be a scalar');
end

if ((start ~= 01) || (stop ~=20)) && ((start ~= 21) || (stop ~=40))
   error('Incorrect start and stop interval'); 
end



offset = 0;
if start == 21 && stop == 40
    offset = 20;
end


% load in images
images = cell(1,20);
for i = start:stop
    images{i-offset} = rgb2gray(im2double(imread(sprintf('%s%02d.jpg',imageprefix,i))));
end


% get individual bits of gray code and good pixels for each frame
bit = zeros(size(images{1},1),size(images{1},2),10);
goodpixels = zeros(size(images{1},1),size(images{1},2),10);
for i = start-offset:2:stop-offset
   index = (i+1)/2;
   bit(:,:,index) = images{i} > images{i+1}; 
   goodpixels(:,:,index) = abs(images{i} - images{i+1}) > threshold;
end


% convert gray codes bits to binary code bits
for i = 2:10
    bit(:,:,i) = xor(bit(:,:,i),bit(:,:,i-1));
    goodpixels(:,:,1) = goodpixels(:,:,1) & goodpixels(:,:,i);
end
goodpixels = goodpixels(:,:,1);


% convert from binary to decimal
num = 512;
C = zeros(size(bit,1), size(bit,2));
for i = 1:10
   C = C + bit(:,:,i) * num;
   num = num / 2;
end



end