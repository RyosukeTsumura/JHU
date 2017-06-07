function varargout = NeedleDriver(varargin)
% NEEDLEDRIVER MATLAB code for NeedleDriver.fig
%      NEEDLEDRIVER, by itself, creates a new NEEDLEDRIVER or raises the existing
%      singleton*.
%
%      H = NEEDLEDRIVER returns the handle to a new NEEDLEDRIVER or the handle to
%      the existing singleton*.
%
%      NEEDLEDRIVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEEDLEDRIVER.M with the given input arguments.
%
%      NEEDLEDRIVER('Property','Value',...) creates a new NEEDLEDRIVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NeedleDriver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NeedleDriver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NeedleDriver

% Last Modified by GUIDE v2.5 05-Jun-2017 20:50:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NeedleDriver_OpeningFcn, ...
                   'gui_OutputFcn',  @NeedleDriver_OutputFcn, ...
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


% --- Executes just before NeedleDriver is made visible.
function NeedleDriver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NeedleDriver (see VARARGIN)

% Choose default command line output for NeedleDriver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NeedleDriver wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function PosDataUpdate(hObject,eventdata,handles)
%handles=guidata(handles);

global LinearValue;
global RotationValue;


Pos_FB = handles.g.command('TPD');
LinearValue = -str2double(Pos_FB)/512*25; %Encorder->512 palse/rev Insertion->25 mm/rev 
set(handles.edit_CurPosFB,'string',num2str(LinearValue));
Pos_Rotation = handles.g.command('TPC');
RotationValue = -str2double(Pos_Rotation)/256*360;
set(handles.edit_CurPosRot,'string',num2str(RotationValue));


%% Initialization

% --- Outputs from this function are returned to the command line.
function varargout = NeedleDriver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_connect.
function pushbutton_connect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Timer_t1;

g = actxserver('galil');%set the variable g to the GalilTools COM wrapper
response = g.libraryVersion;%Retrieve the GalilTools library versions
disp(response);%display GalilTools library version
g.address = '';%Open connections dialog box
response = g.command(strcat(char(18), char(22)));%Send ^R^V to query controller model number
disp(strcat('Connected to: ', response));%print response
response = g.command('MG_BN');%Send MG_BN command to query controller for serial number
disp(strcat('Serial Number: ', response));%print response
handles.g = g;
guidata(hObject,handles);
Timer_t1=timer('TimerFcn',{@PosDataUpdate,handles},...
    'ExecutionMode','FixedRate','Period',0.5);
%set(handles.figure1,'DeleteFcn',{@figure1_DeleteFcn,handles.t});
start(Timer_t1);

set(handles.text_ConnectStatus,'string','PLS Init');

% --- Executes on button press in pushbutton_init.
function pushbutton_init_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.programDownloadFile('NeedleDriverConfig.dmc');
handles.g.command('XQ');



function edit_connect_Callback(hObject, eventdata, handles)
% hObject    handle to edit_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_connect as text
%        str2double(get(hObject,'String')) returns contents of edit_connect as a double


% --- Executes during object creation, after setting all properties.
function edit_connect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_connect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_init_Callback(hObject, eventdata, handles)
% hObject    handle to edit_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_init as text
%        str2double(get(hObject,'String')) returns contents of edit_init as a double


% --- Executes during object creation, after setting all properties.
function edit_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Forward & back motion

function edit_RelPosFB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RelPosFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RelPosFB as text
%        str2double(get(hObject,'String')) returns contents of edit_RelPosFB as a double



% --- Executes during object creation, after setting all properties.
function edit_RelPosFB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RelPosFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_RelPosFB.
function pushbutton_RelPosFB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RelPosFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Input_RelPos=str2double(get(handles.edit_RelPosFB,'String'));
Input_RelPos=round(-Input_RelPos*512/25);
give_pos=strcat('PR ,,,',num2str(Input_RelPos));
handles.g.command(give_pos);
handles.g.command('BG D');

% --- Executes on button press in pushbutton_JogPlusFB.
function pushbutton_JogPlusFB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_JogPlusFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('JG ,,,-20');
handles.g.command('BG D');


% --- Executes on button press in pushbutton_JogMinusFB.
function pushbutton_JogMinusFB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_JogMinusFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('JG ,,,20');
handles.g.command('BG D');



function edit_CurPosFB_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CurPosFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CurPosFB as text
%        str2double(get(hObject,'String')) returns contents of edit_CurPosFB as a double


% --- Executes during object creation, after setting all properties.
function edit_CurPosFB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CurPosFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_StopFB.
function pushbutton_StopFB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StopFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('ST');
handles.g.command('WT 10');
handles.g.command('SH');



%% Rotation motion
function edit_RelPosRot_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RelPosRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RelPosRot as text
%        str2double(get(hObject,'String')) returns contents of edit_RelPosRot as a double


% --- Executes during object creation, after setting all properties.
function edit_RelPosRot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RelPosRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_RelPosRot.
function pushbutton_RelPosRot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RelPosRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Input_RelPos=str2double(get(handles.edit_RelPosRot,'String'));
Input_RelPos=round(-Input_RelPos*256/360);
give_pos=strcat('PR ,,',num2str(Input_RelPos),',');
handles.g.command(give_pos);
handles.g.command('BG C');


function edit_CurPosRot_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CurPosRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CurPosRot as text
%        str2double(get(hObject,'String')) returns contents of edit_CurPosRot as a double


% --- Executes during object creation, after setting all properties.
function edit_CurPosRot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CurPosRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_JogPlusRot.
function pushbutton_JogPlusRot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_JogPlusRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('JG ,,-256,');
handles.g.command('BG C');


% --- Executes on button press in pushbutton_JogRotMinus.
function pushbutton_JogRotMinus_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_JogRotMinus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('JG ,,256,');
handles.g.command('BG C');


% --- Executes on button press in pushbutton_StopRot.
function pushbutton_StopRot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StopRot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('ST');
handles.g.command('WT 10');
handles.g.command('SH');
