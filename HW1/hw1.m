function varargout = hw1(varargin)
% HW1 MATLAB code for hw1.fig
%      HW1, by itself, creates a new HW1 or raises the existing
%      singleton*.
%
%      H = HW1 returns the handle to a new HW1 or the handle to
%      the existing singleton*.
%
%      HW1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HW1.M with the given input arguments.
%
%      HW1('Property','Value',...) creates a new HW1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hw1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hw1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hw1

% Last Modified by GUIDE v2.5 13-Apr-2017 11:21:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hw1_OpeningFcn, ...
                   'gui_OutputFcn',  @hw1_OutputFcn, ...
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


% --- Executes just before hw1 is made visible.
function hw1_OpeningFcn(hObject, eventdata, handles, varargin)

global roomTime
global x
global y
global inL
global inD
global outL
global outD

roomTime = 1.0;
x = 1;
y = 1;
inL = imread('in.jpg');
outL = imread('out.jpg');
inD = inL - 64;
outD = outL - 64;
set(handles.button_room_in,'CData',inL)
set(handles.button_room_out,'CData',outL)

set([handles.button_room_in handles.button_room_out handles.sliderX handles.sliderY...
    handles.button_save handles.mSave], 'enable','off')
% Choose default command line output for hw1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hw1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hw1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sliderY_Callback(hObject, eventdata, handles)

showImg(handles, 0);

% --- Executes during object creation, after setting all properties.
function sliderY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderX_Callback(hObject, eventdata, handles)

showImg(handles, 0);

% --- Executes during object creation, after setting all properties.
function sliderX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in button_Load.
function button_Load_Callback(hObject, eventdata, handles)
global im1
global im2
global xMax
global yMax
global lineW

[filename pathname] = uigetfile({'*.jpg'; '*.png'}, 'Select an image.');
im1 = imread([pathname filename]);
im2 = im1;

[h w ch] = size(im1);
xMax = h;
yMax = w;
if h > w
    lineW = w;
else
    lineW = h;
end
lineW = round(lineW .* 0.025) - 1;
box(handles);

axes(handles.axes2)
imshow(im2)
set([handles.button_room_in handles.button_room_out handles.sliderX handles.sliderY...
    handles.button_save handles.mSave], 'enable','on')


% --- Executes on button press in button_room_in.
function button_room_in_Callback(hObject, eventdata, handles)

global roomTime
global inL
global inD

set(handles.button_room_in,'CData',inD);
pause(0.1);
set(handles.button_room_in,'CData',inL);

roomTime = roomTime - 0.1;
if roomTime < 0.1
    roomTime = 0.1;
end
showImg(handles, 0);


% --- Executes on button press in button_room_out.
function button_room_out_Callback(hObject, eventdata, handles)

global roomTime
global outL
global outD

set(handles.button_room_out,'CData',outD)
pause(0.1);
set(handles.button_room_out,'CData',outL)

roomTime = roomTime + 0.1;
if roomTime > 1
    roomTime = 1;
end
showImg(handles, 1);


function showImg(handles, status)
global roomTime
global im1
global im2
global x
global y
global xMax
global yMax

[h w ch] = size(im1);
xMax = round(h .* roomTime);
yMax = round(w .* roomTime);
x = round((h - xMax) .* (1 - get(handles.sliderX, 'value')) + 1);
y = round((w - yMax) .* get(handles.sliderY, 'value') + 1);
xMax = xMax + x-1;
yMax = yMax + y-1;

if status == 1
    if xMax > h
        sub = xMax - h;
        xMax = xMax - sub;
        x = x - sub;
    end
    if yMax > w
        sub = yMax - w;
        yMax = yMax - sub;
        y = y - sub;
    end
end
im2 = im1(x : xMax, y: yMax, :);
axes(handles.axes2);
imshow(im2);
box(handles);

function box(handles)
global lineW
global im1
global im3
global x
global y
global xMax
global yMax

im3 = im1;
xLen = xMax - x + 1;
yLen = yMax - y + 1;
R1 = ones(lineW + 1, yLen);
R2 = ones(xLen, lineW + 1);
GB1 = zeros(lineW + 1, yLen);
GB2 = zeros(xLen, lineW + 1);

R1 = R1 * 255;
R2 = R2 * 255;
im3(x : x + lineW, y : yMax, 1) = R1;
im3(x : x + lineW, y : yMax, 2) = GB1;
im3(x : x + lineW, y : yMax, 3) = GB1;
im3(xMax - lineW : xMax, y : yMax, 1) = R1;
im3(xMax - lineW : xMax, y : yMax, 2) = GB1;
im3(xMax - lineW : xMax, y : yMax, 3) = GB1;
im3(x : xMax, y : y + lineW, 1) = R2;
im3(x : xMax, y : y + lineW, 2) = GB2;
im3(x : xMax, y : y + lineW, 3) = GB2;
im3(x : xMax, yMax - lineW : yMax, 1) = R2;
im3(x : xMax, yMax - lineW : yMax, 2) = GB2;
im3(x : xMax, yMax - lineW : yMax, 3) = GB2;
axes(handles.axes1)
imshow(im3)

% --------------------------------------------------------------------
function mFile_Callback(hObject, eventdata, handles)
% hObject    handle to mFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mLoad_Callback(hObject, eventdata, handles)
button_Load_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function mExit_Callback(hObject, eventdata, handles)
close


% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
global im2
[filename pathname] = uiputfile({'*.jpg'; '*.png'}, 'Save image');
imwrite(im2, [pathname filename])

% --------------------------------------------------------------------
function mSave_Callback(hObject, eventdata, handles)
button_save_Callback(hObject, eventdata, handles)
