I = rgb2gray(im2double(imread('crooked_horizon.jpg')));
figure,imshow(I),title('Original Image');

I2 = rotate_image(I,45);
figure,imshow(I2),title('Rotated Image CCW');