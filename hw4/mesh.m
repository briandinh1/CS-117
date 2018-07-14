load reconstruct_data.mat;


% 1. PRUNE POINTS OUTSIDE OF BOUNDING BOX
xL(:,X(2,:)<0) = []; % remove all negative Y points
X(:,X(2,:)<0) = [];

xL(:,X(3,:)<0) = []; % remove all negative Z points
X(:,X(3,:)<0) = [];

xL(:,X(1,:)>14) = []; % remove all X points that are > 14
X(:,X(1,:)>14) = [];

xL(:,X(1,:)<-0.15) = []; % remove all X points that are < -0.15
X(:,X(1,:)<-0.15) = [];


% 2. REMOVE TRIANGLES WITH LONG EDGES
tri = delaunay(xL(1,:),xL(2,:));

p1 = X(:,tri(:,1));
p2 = X(:,tri(:,2));
p3 = X(:,tri(:,3));

d12 = sum((p1-p2).^2,1).^0.5; 
d13 = sum((p1-p3).^2,1).^0.5; 
d23 = sum((p2-p3).^2,1).^0.5; 

% since a majority of the edges are small, only remove edges with lengths
% in the top percentiles because they tend to be outliers
threshold = mean([prctile(d12,99.95); prctile(d23,99.95); prctile(d13,99.95)]);
tri(d12>threshold | d13>threshold | d23>threshold,:) = [];


% plot the mesh
figure; clf;
h = trisurf(tri,X(1,:),X(2,:),X(3,:));
set(h,'edgecolor','none')
set(gca,'projection','perspective')
set(gcf,'renderer','opengl')
axis image; axis vis3d;
camorbit(120,0); camlight left;
camorbit(120,0); camlight left;
lighting phong;
material dull;

