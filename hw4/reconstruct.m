load scan0_calibration.mat;

threshold = 0.02;
[Rh_C, Rh_goodpixels] = decode('right_',01,20,threshold);
[Rv_C, Rv_goodpixels] = decode('right_',21,40,threshold);
[Lh_C, Lh_goodpixels] = decode('left_',01,20,threshold);
[Lv_C, Lv_goodpixels] = decode('left_',21,40,threshold);


R_C = Rh_C + 1024*Rv_C;    %combine the horizontal and vertical coordinates into a single (20 bit) code in [0...1048575]
L_C = Lh_C + 1024*Lv_C;
R_goodpixels = Rh_goodpixels & Rv_goodpixels; %identify pixels that have both good horiztonal and vertical codes
L_goodpixels = Lh_goodpixels & Lv_goodpixels;

R_sub = find(R_goodpixels);     % find the indicies of pixels that were succesfully decoded
L_sub = find(L_goodpixels);
R_C_good = R_C(R_sub);          % pull out the codes for the good pixels
L_C_good = L_C(L_sub);

%intersect the codes of good pixels in the left and right image to find matches
[matched,iR,iL] = intersect(R_C_good,L_C_good); 

R_sub_matched = R_sub(iR);  % get the pixel indicies of the pixels that were matched
L_sub_matched = L_sub(iL);
[xx,yy] = meshgrid(1:size(R_C,2),1:size(R_C,1)); % create arrays containing the pixel coordinates
xR(1,:) = xx(R_sub_matched); % pull out the x,y coordinates of the matched pixels 
xR(2,:) = yy(R_sub_matched); 
xL(1,:) = xx(L_sub_matched); 
xL(2,:) = yy(L_sub_matched);


X = triangulate(xL,xR,camL,camR);
plot3(X(1,:),X(2,:),X(3,:),'.'); axis([-10 50 -10 50 -10 50]);

save reconstruct_data.mat X xL xR L_goodpixels R_goodpixels;
