function varargout = LironGui(varargin)
% LIRONGUI MATLAB code for LironGui.fig
%      LIRONGUI, by itself, creates a new LIRONGUI or raises the existing
%      singleton*.
%
%      H = LIRONGUI returns the handle to a new LIRONGUI or the handle to
%      the existing singleton*.
%
%      LIRONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LIRONGUI.M with the given input arguments.
%
%      LIRONGUI('Property','Value',...) creates a new LIRONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LironGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LironGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LironGui

% Last Modified by GUIDE v2.5 30-Mar-2014 13:40:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LironGui_OpeningFcn, ...
                   'gui_OutputFcn',  @LironGui_OutputFcn, ...
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
 

% --- Executes just before LironGui is made visible.
function LironGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LironGui (see VARARGIN)

% Choose default command line output for LironGui
% load peppers
img=imread('peppers.png');
Intilize_mat=zeros(size(img));
imshow(Intilize_mat,'parent',handles.axes1)
% set(handles.axes1,'WindowButtonMotionFcn',@Choose_ROI_Callback)
colormap('gray')
handles.output = hObject;
handles.img=img;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LironGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LironGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Choose_ROI.
function Choose_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to Choose_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
startdraw
 guidata(hObject, handles);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Choose_ROI.
function Choose_ROI_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Choose_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

