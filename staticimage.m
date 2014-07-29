close all;
clear all;
clc;
[FileName,PathName] = uigetfile;
finalpath = strcat(PathName,'\',FileName);
rgbInputImage = imread(finalpath);
%rgbInputImage=getsnapshot(rgbInputImage);
labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
figure, imshow(rgbInputImage);
figure, imshow(rgbOutputImage);
img=rgbOutputImage;
final_image = zeros(size(img,1), size(img,2));

if(size(img,3) >1)
for i = 1:size(img,1)
for j = 1:size(img,2)
R = img(i,j,1);
G = img(i,j,2);
B = img(i,j,3);
if(R > 92 && G > 40 && B > 20)
v = [R,G,B];
if((max(v) - min(v)) > 15)
if(abs(R-G) > 15 && R > G && R > B)
%it is a skin
final_image(i,j) = 1;
end
end
end
end
end

%Grayscale To Binary.
binaryImage=im2bw(final_image,0.6);
figure, imshow(binaryImage);

%Filling The Holes.
binaryImage = imfill(binaryImage, 'holes');
figure, imshow(binaryImage);

binaryImage = bwareaopen(binaryImage,1890);   
figure,imshow(binaryImage);
labeledImage = bwlabel(binaryImage, 8);
blobMeasurements = regionprops(labeledImage, final_image, 'all');
numberOfPeople = size(blobMeasurements, 1)
imagesc(rgbInputImage); title('Outlines, from bwboundaries()'); 
%axis square;
hold on;
boundaries = bwboundaries(binaryImage);
for k = 1 : numberOfPeople
thisBoundary = boundaries{k};
plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
% hold off;


imagesc(rgbInputImage);
hold on;
title('Original with bounding boxes');
%fprintf(1,'Blob # x1 x2 y1 y2\n');
for k = 1 : numberOfPeople % Loop through all blobs.
% Find the mean of each blob. (R2008a has a better way where you can pass the original image
% directly into regionprops. The way below works for all versionsincluding earlier versions.)
thisBlobsBox = blobMeasurements(k).BoundingBox; % Get list of pixels in current blob.
x1 = thisBlobsBox(1);
y1 = thisBlobsBox(2);
x2 = x1 + thisBlobsBox(3);
y2 = y1 + thisBlobsBox(4);


   % fprintf(1,'#%d %.1f %.1f %.1f %.1f\n', k, x1, x2, y1, y2);
x = [x1 x2 x2 x1 x1];
y = [y1 y1 y2 y2 y1];
%subplot(3,4,2);
plot(x, y, 'LineWidth', 2);
end


%figure, imshow(labeledImage);
%B = bwboundaries(binaryImage);
%imshow(B);
%text(10,10,strcat('\color{green}Objects Found:',num2str(length(B))))
%hold on
%for k = 1:length(B)
%boundary = B{k};
%plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 0.2)
%end
end

%clear all
clc
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
I = imread(finalpath);

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

figure,
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;
