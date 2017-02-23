%Félix Landry
%Date de création : 5 février 2017
%Date d'édition
%Description du programme: simulateur pour le banc d'essai, version GUI


function varargout = sm_5fig(varargin)
% SM_5FIG MATLAB code for sm_5fig.fig
%      SM_5FIG, by itself, creates a new SM_5FIG or raises the existing
%      singleton*.
%
%      H = SM_5FIG returns the handle to a new SM_5FIG or the handle to
%      the existing singleton*.
%
%      SM_5FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SM_5FIG.M with the given input arguments.
%
%      SM_5FIG('Property','Value',...) creates a new SM_5FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sm_5fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sm_5fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sm_5fig

% Last Modified by GUIDE v2.5 06-Feb-2017 21:22:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sm_5fig_OpeningFcn, ...
                   'gui_OutputFcn',  @sm_5fig_OutputFcn, ...
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

% --- Executes just before sm_5fig is made visible.
function sm_5fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sm_5fig (see VARARGIN)

syms  z(t)
masseS = 8/1000; %masse sphere
masseP = 425/1000;%masse plaque
inertiePx = 1169.1 / (1000^2);%inertie de plaque sur axe x
inertiePy = 1169.1 / (1000^2); %inertie de plaque sur axe y
g = -9.8;
rayonS = 3.9 / 1000;  
R = 95.2/1000;
FA = 1;
FB = 1;
FC = 100;
eqn1 = (FA + FB + FC + masseP*g + masseS*g) /(masseP + masseS) == diff(z,2);
cond = z(0) == 0 ;
Dz = diff(z);
cond1 = Dz(0) == 0;
zSol = dsolve(eqn1,cond, cond1)

fplot(zSol)
% Choose default command line output for sm_5fig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using sm_5fig.
if strcmp(get(hObject,'Visible'),'off')
    fplot(zSol);
end

% UIWAIT makes sm_5fig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sm_5fig_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        syms  z(t)
        masseS = 8/1000; %masse sphere
        masseP = 425/1000;%masse plaque
        inertiePx = 1169.1;%inertie de plaque sur axe x
        inertiePy = 1169.1; %inertie de plaque sur axe y
        g = -9.8;
        rayonS = 3.9 / 1000;  
        R = 95.2/1000;
        FA = 1;
        FB = 1;
        FC = 100;
        eqn1 = (FA + FB + FC + masseP*g + masseS*g) /(masseP + masseS) == diff(z,2);
        cond = z(0) == 0 ;
        Dz = diff(z);
        cond1 = Dz(0) == 0;
        zSol = dsolve(eqn1,cond, cond1)
        fplot(zSol)
        
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
