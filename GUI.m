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

% Last Modified by GUIDE v2.5 11-Oct-2018 09:24:36

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
[filename, pathname] = uigetfile({'*.csv'},'File Selector');

setappdata(0,'ref_filename', filename)
setappdata(0,'ref_pathname', pathname)

set(handles.SelectedFileText, 'string', strcat(pathname,'/',filename))

% Load and bin data
filename = getappdata(0,'ref_filename')
pathname = getappdata(0,'ref_pathname')
[Imported_num, Imported_txt] = xlsread(strcat(pathname,'/',filename));
figure(1);
pcshow([Imported_num(:,2),Imported_num(:,3),Imported_num(:,4)],'MarkerSize',100);

xlabel('X');
ylabel('Y');
zlabel('Z');
% slice to 2D
divisor = 3;
width = max(abs(Imported_num(:,4))/divisor);


% Drawdown Analysis
if get(handles.Drawdown,'value') == 1
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
                if Imported_num(n,3)>0
                    if abs(Imported_num(n,4))>bottom
                        if abs(Imported_num(n,4))<top
                            m=m+1;
                            temp_bin(m,:) = Imported_num(n,1:4);
                            length(l) = m;
                        end
                    end
                end
            end   
            size(temp_bin);
            bin{l}=temp_bin;
        end
    setappdata(0,'bin', bin); 
    axes(handles.SlicePlot)
    plot(bin{floor(1)}(:,2),bin{floor(1)}(:,3),'o');
    ylim([0 1])    
end

% Angle of Repose Analysis
if get(handles.AOR,'value') == 1
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
                if Imported_num(n,3)<0
                    if abs(Imported_num(n,4))>bottom
                        if abs(Imported_num(n,4))<top
                            m=m+1;
                            temp_bin(m,:) = Imported_num(n,1:4);
                            length(l) = m;
                        end
                    end
                end
            end   
            size(temp_bin);
            bin{l}=temp_bin;
        end
    setappdata(0,'bin', bin);    
    axes(handles.SlicePlot)
    plot(bin{floor(1)}(:,2),bin{floor(1)}(:,3),'o');
    ylim([-1 0]);
end

set(handles.SliceSlider, 'Value', 2);

axes(handles.SlicePlot)
SliderVal = 2;
bin = getappdata(0,'bin')
plot(bin{floor(SliderVal)}(:,2),bin{floor(SliderVal)}(:,3),'o');
setappdata(0,'SelectedBin', bin{floor(SliderVal)}(:,2:3))


if get(handles.AOR,'value') == 1
    ylim ([-1 0])
else
    ylim ([0 1])
end

SelectedBin = getappdata(0,'SelectedBin');
axes(handles.FinalPlot)
window = get(handles.RegSlider,'value');
m=0;

for n = 1: size(SelectedBin,1)
    if SelectedBin(n,1)>0.25-window
        if SelectedBin(n,1)<0.25+window
            m=m+1;
            regressionpoints(m,:) = SelectedBin(n,:);
        end
    end
end   


size(regressionpoints,2);
step = floor(size(regressionpoints,1)/8);
step = [1:8]*step

regressionpoints_sorted = sortrows(regressionpoints,1);
   
for n = 1:7
    [M,I] = max(regressionpoints_sorted(step(n):step(n+1),2));
    regressionpoints_sorted(step(n):step(n+1),2);
    i(n)=I+step(n)-1;
    regressionpoints_sorted(I,:);
end

for n=1:7
    data (n,:) = regressionpoints_sorted(i(n),:)
end

plot(SelectedBin(:,1),SelectedBin(:,2),'o');
hold on
plot(data (:,1),data (:,2),'or');
if get(handles.AOR,'value') == 1
    ylim ([-1 0]);
else
    ylim ([0 1]);
end

size(data(:,1),1)


x = [ones(size(data(:,1),1),1), data(:,1)]

b1 = x\data(:,2);
reg = b1(1)+b1(2)*data(:,1);
plot(data(:,1),reg,'LineWidth',2,'Color','Green');    
hold off


angle = atan(b1(2))*180/pi()
set(handles.AngleText,'string',num2str(angle))



% --- Executes on slider movement.
function SliceSlider_Callback(hObject, eventdata, handles)
% hObject    handle to SliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

axes(handles.SlicePlot)
SliderVal = get(handles.SliceSlider,'value')
bin = getappdata(0,'bin')
plot(bin{floor(SliderVal)}(:,2),bin{floor(SliderVal)}(:,3),'o');
setappdata(0,'SelectedBin', bin{floor(SliderVal)}(:,2:3))


if get(handles.AOR,'value') == 1
    ylim ([-1 0])
else
    ylim ([0 1])
end
    





% --- Executes during object creation, after setting all properties.
function SliceSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
        

% --- Executes on button press in DrawdownCheckbox.
function DrawdownCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to DrawdownCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DrawdownCheckbox


% --- Executes on slider movement.
function RegSlider_Callback(hObject, eventdata, handles)
% hObject    handle to RegSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

SelectedBin = getappdata(0,'SelectedBin');
axes(handles.FinalPlot)
window = get(handles.RegSlider,'value');
m=0;

for n = 1: size(SelectedBin,1)
    if SelectedBin(n,1)>0.25-window
        if SelectedBin(n,1)<0.25+window
            m=m+1;
            regressionpoints(m,:) = SelectedBin(n,:);
        end
    end
end   


size(regressionpoints,2);
step = floor(size(regressionpoints,1)/8);
step = [1:8]*step

regressionpoints_sorted = sortrows(regressionpoints,1);
   
for n = 1:7
    [M,I] = max(regressionpoints_sorted(step(n):step(n+1),2));
    regressionpoints_sorted(step(n):step(n+1),2);
    i(n)=I+step(n)-1;
    regressionpoints_sorted(I,:);
end

for n=1:7
    data (n,:) = regressionpoints_sorted(i(n),:);
end

plot(SelectedBin(:,1),SelectedBin(:,2),'o');
hold on
plot(data (:,1),data (:,2),'or');
if get(handles.AOR,'value') == 1
    ylim ([-1 0]);
else
    ylim ([0 1]);
end

x = [ones(length(data(:,1)),1), data(:,1)]

b1 = x\data(:,2);
reg = b1(1)+b1(2)*data(:,1);
plot(data(:,1),reg,'LineWidth',2,'Color','Green');    
hold off


angle = atan(b1(2))*180/pi()
set(handles.AngleText,'string',num2str(angle))


% --- Executes during object creation, after setting all properties.
function RegSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RegSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in AOR.
function AOR_Callback(hObject, eventdata, handles)
% hObject    handle to AOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AOR


% --- Executes on button press in Drawdown.
function Drawdown_Callback(hObject, eventdata, handles)
% hObject    handle to Drawdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Drawdown
