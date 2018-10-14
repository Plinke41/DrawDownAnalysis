function varargout = GUI(varargin)
%GUI MATLAB code file for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('Property','Value',...) creates a new GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI('CALLBACK') and GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 12-Oct-2018 19:00:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

setappdata(0,'divisor',20);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in DrawDownCheckbox.
function DrawDownCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to DrawDownCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DrawDownCheckbox


% --- Executes on button press in ReposeCheckbox.
function ReposeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to ReposeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ReposeCheckbox


% --- Executes on button press in SelectFilePushbutton.
function SelectFilePushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFilePushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

LoadData(hObject, eventdata, handles)
SortSlices(hObject, eventdata, handles)
if get (handles.AOR,'Value') == 1
    RegressAOR(hObject, eventdata, handles)
else
    RegressDD(hObject, eventdata, handles)
end

% --- Executes on slider movement.
function SliceSlider_Callback(hObject, eventdata, handles)
% hObject    handle to SliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


SortSlices(hObject, eventdata, handles)
if get (handles.AOR,'Value') == 1
    RegressAOR(hObject, eventdata, handles)
else
    RegressDD(hObject, eventdata, handles)
end




% --- Executes during object creation, after setting all properties.
function SliceSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

if get (handles.AOR,'Value') == 1
    RegressAOR(hObject, eventdata, handles)
else
    RegressDD(hObject, eventdata, handles)
end
        

% --- Executes on button press in DrawdownCheckbox.
function DrawdownCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to DrawdownCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DrawdownCheckbox


% --- Executes on slider movement.
function RegSlider_Callback(hObject, eventdata, handles)

if get (handles.AOR,'Value') == 1
    RegressAOR(hObject, eventdata, handles)
else
    RegressDD(hObject, eventdata, handles)
end



% --- Executes during object creation, after setting all properties.
function RegSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on button press in AOR.
function AOR_Callback(hObject, eventdata, handles)
SortSlices(hObject, eventdata, handles)
if get (handles.AOR,'Value') == 1
    RegressAOR(hObject, eventdata, handles)
else
    RegressDD(hObject, eventdata, handles)
end


% --- Executes on button press in Drawdown.
function Drawdown_Callback(hObject, eventdata, handles)
SortSlices(hObject, eventdata, handles)
if get (handles.AOR,'Value') == 1
    RegressAOR(hObject, eventdata, handles)
else
    RegressDD(hObject, eventdata, handles)
end

function LoadData (hObject, eventdata, handles)
% Load and bin data
[file,path] = uigetfile('*.csv');
filename = file;
pathname = path;
[Imported_num, Imported_txt] = xlsread(strcat(pathname,'/',filename));
% figure(1);
% pcshow([Imported_num(:,2),Imported_num(:,3),Imported_num(:,4)],'MarkerSize',100);

xlabel('X');
ylabel('Y');
zlabel('Z');
% slice to 2D
divisor = 3;
width = max(abs(Imported_num(:,4))/divisor);

setappdata(0,'Imported_num', Imported_num);
setappdata(0,'width', width);
setappdata(0,'divisor', divisor);
setappdata(0,'ref_filename', file);
setappdata(0,'ref_pathname', path);

set(handles.SelectedFileText,'string',strcat(pathname,'/',filename));

  

function SortSlices(hObject, eventdata, handles)

AOR = get(handles.AOR,'Value')

% divisor divides in Z
divisor = getappdata(0,'divisor');
width = getappdata(0,'width');
Imported_num = getappdata(0,'Imported_num');
bin=[];
temp_bin=[];
for l = 1:divisor
    top = width*l;
    bottom = top - width;
    limits(l,1)=bottom;
    limits(l,2)=top;
    m=0;
    temp_bin=[];
    for n = 1: size(Imported_num)
        % check if AOR ore draw-down
        if AOR == 1
            if Imported_num(n,3)<0
                if Imported_num(n,4)>bottom
                    if Imported_num(n,4)<top
                        m=m+1;
                        temp_bin(m,:) = Imported_num(n,1:4);
                        length(l) = m;
                    end
                end
            end
          elseif AOR == 0
            if Imported_num(n,3)>0
                if Imported_num(n,4)>bottom
                    if Imported_num(n,4)<top
                        m=m+1;
                        temp_bin(m,:) = Imported_num(n,1:4);
                        length(l) = m;
                    end
                end
            end
          end
    end   
    size(temp_bin);
    bin{l}=temp_bin;
end
setappdata(0,'bin', bin);
SliderVal = get(handles.SliceSlider,'value');

SelectedBin = bin{floor(SliderVal)}(:,2:3);
setappdata(0,'SelectedBin', SelectedBin);
axes(handles.SlicePlot)
plot(SelectedBin(:,1),SelectedBin(:,2),'ob')
if get(handles.AOR,'value') == 1
    ylim ([-1 0]);
else
    ylim ([0 1]);
end

function RegressDD(hObject, eventdata, handles)

SelectedBin = getappdata(0,'SelectedBin');
SelectedBin_sorted = sortrows(SelectedBin,1);
window = get(handles.RegSlider,'value');
max(SelectedBin_sorted(:,1));
PosVal = floor(get(handles.PosSlider,'value'));

m = 1;
for n = 1: size(SelectedBin_sorted,1)
    if SelectedBin_sorted(n,1)>0
        windowmin(m) = SelectedBin_sorted(n,1);
        m=m+1
    end
end
windowmin = min(windowmin);

for l = 1:20
    step = (max(SelectedBin_sorted(:,1)-windowmin)/20);
    top = windowmin + step * l;
    bottom = top - step;
    m=0;
    temp_bin=[];
    for n = 1:size(SelectedBin_sorted,1)
        if SelectedBin_sorted(n,1)>bottom
            if SelectedBin_sorted(n,1)<top
                m = m + 1;
                temp_bin(m,:) = SelectedBin_sorted(n,:);
            end
        end
    end
    temp_bin = sortrows(temp_bin,2);
    regressionpoints(l,:) = temp_bin(end,:);
end

% Apply window width
regressionpoints = regressionpoints(((size(regressionpoints,1)/2)-window):((size(regressionpoints,1)/2)+window),:);

% Apply Position Value
n=1;
for i = (abs(PosVal)+1):(size(regressionpoints,1)-abs(PosVal)-1)
    regressionpoints_pos(n,:) = regressionpoints((i + PosVal),:);
    n=n+1;
    i;
end
regressionpoints = regressionpoints_pos;

x = [ones(length(regressionpoints(:,1)),1), regressionpoints(:,1)];

b1 = x\regressionpoints(:,2);
reg = b1(1)+b1(2)*regressionpoints(:,1);
angle = atan(b1(2))*180/pi();

set(handles.AngleRight,'string',num2str(angle))
axes(handles.FinalPlot)

plot(SelectedBin(:,1),SelectedBin(:,2),'ob');
hold on
plot(regressionpoints(:,1),regressionpoints(:,2),'or')
plot(regressionpoints(:,1),reg,'LineWidth',2,'Color','Green');
if get(handles.AOR,'value') == 1
    ylim ([-1 0]);
else
    ylim ([0 1]);
end
hold off

function RegressAOR(hObject, eventdata, handles)

SelectedBin = getappdata(0,'SelectedBin');
SelectedBin_sorted = sortrows(SelectedBin,1);
window = get(handles.RegSlider,'value');
max(SelectedBin_sorted(:,1));
PosVal = floor(get(handles.PosSlider,'value'));

for l = 1:20
    top = ((max(SelectedBin_sorted(:,1))/20))*l
    bottom = top - ((max(SelectedBin_sorted(:,1))/20))
    m=0;
    temp_bin=[];
    for n = 1:size(SelectedBin_sorted,1)
        if SelectedBin_sorted(n,1)>bottom
            if SelectedBin_sorted(n,1)<top
                m = m + 1;
                temp_bin(m,:) = SelectedBin_sorted(n,:)
            end
        end
    end
    temp_bin = sortrows(temp_bin,2);
    regressionpoints(l,:) = temp_bin(end,:);
end

% Apply window width
regressionpoints = regressionpoints(((size(regressionpoints,1)/2)-window):((size(regressionpoints,1)/2)+window),:);

% Apply Position Value
n=1;
for i = (abs(PosVal)+1):(size(regressionpoints,1)-abs(PosVal)-1)
    regressionpoints_pos(n,:) = regressionpoints((i + PosVal),:);
    n=n+1;
    i;
end
regressionpoints = regressionpoints_pos;

x = [ones(length(regressionpoints(:,1)),1), regressionpoints(:,1)];

b1 = x\regressionpoints(:,2);
reg = b1(1)+b1(2)*regressionpoints(:,1);
angle = atan(b1(2))*180/pi();

set(handles.AngleRight,'string',num2str(angle))
axes(handles.FinalPlot)

plot(SelectedBin(:,1),SelectedBin(:,2),'ob');
hold on
plot(regressionpoints(:,1),regressionpoints(:,2),'or')
plot(regressionpoints(:,1),reg,'LineWidth',2,'Color','Green');
if get(handles.AOR,'value') == 1
    ylim ([-1 0]);
else
    ylim ([0 1]);
end
hold off


% --- Executes on slider movement.
function PosSlider_Callback(hObject, eventdata, handles)

if get (handles.AOR,'Value') == 1
    RegressAOR(hObject, eventdata, handles)
else
    RegressDD(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function PosSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PosSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
