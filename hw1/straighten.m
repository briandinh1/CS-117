I = rgb2gray(im2double(imread('crooked_horizon.jpg')));
figure,imshow(I),title('Original Image');

[x,y] = ginput(2);
hold on;
plot(x,y,'r');

angle = atan2d(y(2)-y(1), x(2)-x(1));
Irot = rotate_image(I,angle);
figure,imshow(Irot),title('Rotated Image CCW');