function varargout = Final(varargin)
% FINAL MATLAB code for Final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Final

% Last Modified by GUIDE v2.5 23-Apr-2014 12:21:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Final_OpeningFcn, ...
                   'gui_OutputFcn',  @Final_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Final is made visible.
function Final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Final (see VARARGIN)

% Choose default command line output for Final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close all;
%clear all;
%clc;
[FileName,PathName] = uigetfile;
finalpath = strcat(PathName,'\',FileName);
rgbInputImage = imread(finalpath);
%rgbInputImage=getsnapshot(rgbInputImage);
labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
axes(handles.axes1);
imshow(rgbInputImage);
axes(handles.axes4);
imshow(rgbOutputImage);
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
axes(handles.axes5);
imshow(binaryImage);

%Filling The Holes.
binaryImage = imfill(binaryImage, 'holes');
axes(handles.axes6);
imshow(binaryImage);

binaryImage = bwareaopen(binaryImage,1890);   
axes(handles.axes7);
imshow(binaryImage);
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
%clc
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
I = imread(finalpath);

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

axes(handles.axes8);
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;


% --- Executes on button press in button2.
function button2_Callback(hObject, eventdata, handles)
% hObject    handle to button2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close all;
%clear all;
%clc;
%[FileName,PathName] = uigetfile;
%finalpath = strcat(PathName,'\',FileName);
v=videoinput('winvideo', 1);
im=getsnapshot(v);
imwrite(im,'g:\image.jpg');
rgbInputImage = imread('g:\image.jpg');
%rgbInputImage=getsnapshot(rgbInputImage);
labInputImage = applycform(rgbInputImage,makecform('srgb2lab'));
Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
rgbOutputImage = applycform(labOutputImage,makecform('lab2srgb'));
axes(handles.axes1);
imshow(rgbInputImage);
axes(handles.axes4);
imshow(rgbOutputImage);
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
axes(handles.axes5);
imshow(binaryImage);

%Filling The Holes.
binaryImage = imfill(binaryImage, 'holes');
axes(handles.axes6);
imshow(binaryImage);

binaryImage = bwareaopen(binaryImage,1890);   
axes(handles.axes7);
imshow(binaryImage);
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
%clc
%Detect objects using Viola-Jones Algorithm

%To detect Face
FDetect = vision.CascadeObjectDetector;

%Read the input image
I = imread('g:\image.jpg');

%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);

axes(handles.axes8);
imshow(I); hold on
for i = 1:size(BB,1)
    rectangle('Position',BB(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','r');
end
title('Face Detection');
hold off;


% --- Executes on button press in button3.
function button3_Callback(hObject, eventdata, handles)
% hObject    handle to button3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Realtimeface;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
team;
