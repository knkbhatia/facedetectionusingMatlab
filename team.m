function varargout = team(varargin)
% TEAM MATLAB code for team.fig
%      TEAM, by itself, creates a new TEAM or raises the existing
%      singleton*.
%
%      H = TEAM returns the handle to a new TEAM or the handle to
%      the existing singleton*.
%
%      TEAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEAM.M with the given input arguments.
%
%      TEAM('Property','Value',...) creates a new TEAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before team_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to team_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help team

% Last Modified by GUIDE v2.5 23-Apr-2014 11:56:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @team_OpeningFcn, ...
                   'gui_OutputFcn',  @team_OutputFcn, ...
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


% --- Executes just before team is made visible.
function team_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to team (see VARARGIN)

% Choose default command line output for team
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes team wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = team_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputImage3 = imread('C:\Program Files\MATLAB\R2012a\bin\image3.jpg');
axes(handles.axes3);
imshow(InputImage3);
title('Deepanker Saxena (Student - VIT University)');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputImage2 = imread('C:\Program Files\MATLAB\R2012a\bin\image2.jpg');
axes(handles.axes3);
imshow(InputImage2);
title('Kanika Bhatia (Student - VIT University)');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputImage1 = imread('C:\Program Files\MATLAB\R2012a\bin\image1.jpg');
axes(handles.axes3);
imshow(InputImage1);
title('Vaibhav Tuteja(Student - VIT University)');

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
InputImage4 = imread('C:\Program Files\MATLAB\R2012a\bin\image4.jpg');
axes(handles.axes3);
imshow(InputImage4);
title('Prof.Gunasekaran G (Asst.Professor(Senior))');
