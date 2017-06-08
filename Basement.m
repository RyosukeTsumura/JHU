function varargout = Basement(varargin)
% BASEMENT MATLAB code for Basement.fig
%      BASEMENT, by itself, creates a new BASEMENT or raises the existing
%      singleton*.
%
%      H = BASEMENT returns the handle to a new BASEMENT or the handle to
%      the existing singleton*.
%
%      BASEMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASEMENT.M with the given input arguments.
%
%      BASEMENT('Property','Value',...) creates a new BASEMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Basement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Basement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Basement

% Last Modified by GUIDE v2.5 08-Jun-2017 10:11:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Basement_OpeningFcn, ...
                   'gui_OutputFcn',  @Basement_OutputFcn, ...
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


% --- Executes just before Basement is made visible.
function Basement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Basement (see VARARGIN)

% Choose default command line output for Basement
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Basement wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function PosDataUpdate(hObject,eventdata,handles)
%handles=guidata(handles);

global LinearValue;
global UpDownValue;
global LateralValue;


Pos_UpDown = handles.g.command('TPC');
UpDownValue = -str2double(Pos_UpDown)/2000;
set(handles.edit_CurPosUD,'string',num2str(UpDownValue));
Pos_Lateral = handles.g.command('TPB');
LateralValue = -str2double(Pos_Lateral)/2000;
set(handles.edit_CurPosLR,'string',num2str(LateralValue));
Pos_Linear = handles.g.command('TPA');
LinearValue = str2double(Pos_Linear)/2000;
set(handles.edit_CurPosFB,'string',num2str(LinearValue));

% --- Outputs from this function are returned to the command line.
function varargout = Basement_OutputFcn(hObject, eventdata, handles) 
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
handles.g.programDownloadFile('BasementConfig.dmc');
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



function edit_RelPosUD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RelPosUD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RelPosUD as text
%        str2double(get(hObject,'String')) returns contents of edit_RelPosUD as a double


% --- Executes during object creation, after setting all properties.
function edit_RelPosUD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RelPosUD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_RelPosUD.
function pushbutton_RelPosUD_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RelPosUD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Input_RelPos=str2double(get(handles.edit_RelPosUD,'String'));
Input_RelPos=round(-Input_RelPos*2000);
give_pos=strcat('PR ,,',num2str(Input_RelPos),',');
handles.g.command(give_pos);
handles.g.command('BG C');


function edit_RelPosLR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_RelPosLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_RelPosLR as text
%        str2double(get(hObject,'String')) returns contents of edit_RelPosLR as a double


% --- Executes during object creation, after setting all properties.
function edit_RelPosLR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_RelPosLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_RelPosLR.
function pushbutton_RelPosLR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_RelPosLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Input_RelPos=str2double(get(handles.edit_RelPosLR,'String'));
Input_RelPos=round(-Input_RelPos*2000);
give_pos=strcat('PR ,',num2str(Input_RelPos),',,');
handles.g.command(give_pos);
handles.g.command('BG B');


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
Input_RelPos=round(Input_RelPos*2000);
give_pos=strcat('PR ',num2str(Input_RelPos),',,,');
handles.g.command(give_pos);
handles.g.command('BG A');


function edit_CurPosUD_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CurPosUD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CurPosUD as text
%        str2double(get(hObject,'String')) returns contents of edit_CurPosUD as a double


% --- Executes during object creation, after setting all properties.
function edit_CurPosUD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CurPosUD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_CurPosLR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_CurPosLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_CurPosLR as text
%        str2double(get(hObject,'String')) returns contents of edit_CurPosLR as a double


% --- Executes during object creation, after setting all properties.
function edit_CurPosLR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_CurPosLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in pushbutton_FinePosPlusUD.
function pushbutton_FinePosPlusUD_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FinePosPlusUD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('PR ,,-400,');
handles.g.command('BG C');


% --- Executes on button press in pushbutton_FinePosMinusUD.
function pushbutton_FinePosMinusUD_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FinePosMinusUD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('PR ,,400,');
handles.g.command('BG C');


% --- Executes on button press in pushbutton_FinePosPlusLR.
function pushbutton_FinePosPlusLR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FinePosPlusLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('PR ,-400,,');
handles.g.command('BG B');




% --- Executes on button press in pushbutton_FinePosMinusLR.
function pushbutton_FinePosMinusLR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FinePosMinusLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('PR ,400,,');
handles.g.command('BG B');



% --- Executes on button press in pushbutton_FinePosPlusFB.
function pushbutton_FinePosPlusFB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FinePosPlusFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('PR 400,,,');
handles.g.command('BG A');


% --- Executes on button press in pushbutton_FinePosMinusFB.
function pushbutton_FinePosMinusFB_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FinePosMinusFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.g.command('PR -400,,,');
handles.g.command('BG A');

