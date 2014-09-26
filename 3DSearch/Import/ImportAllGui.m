function varargout = ImportAllGui(varargin)
% IMPORTALLGUI M-file for ImportAllGui.fig
%      IMPORTALLGUI, by itself, creates a new IMPORTALLGUI or raises the existing
%      singleton*.
%
%      H = IMPORTALLGUI returns the handle to a new IMPORTALLGUI or the handle to
%      the existing singleton*.
%
%      IMPORTALLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMPORTALLGUI.M with the given input arguments.
%
%      IMPORTALLGUI('Property','Value',...) creates a new IMPORTALLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImportAllGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImportAllGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImportAllGui

% Last Modified by GUIDE v2.5 16-Aug-2011 12:53:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImportAllGui_OpeningFcn, ...
                   'gui_OutputFcn',  @ImportAllGui_OutputFcn, ...
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


% --- Executes just before ImportAllGui is made visible.
function ImportAllGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImportAllGui (see VARARGIN)

% Choose default command line output for ImportAllGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImportAllGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImportAllGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        BUTTON FUNCTIONS                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in button_import.
function button_import_Callback(hObject, eventdata, handles)
% hObject    handle to button_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
subject_str = get(handles.edit_subject,'string');
handles.subject = str2num(subject_str);
sessions_str = get(handles.edit_sessions,'string');
handles.sessions = str2num(sessions_str);
eegsessions_str = get(handles.edit_eegsessions,'string');
handles.eegsessions = str2num(eegsessions_str);
filetype_str = get(handles.popup_filetype,'string');
handles.filetype = filetype_str{get(handles.popup_filetype,'value')};
eventsrule_str = get(handles.popup_eventsrule,'string');
handles.eventsrule = eventsrule_str{get(handles.popup_eventsrule,'value')};
pixelthresh_str = get(handles.edit_pixelthresh,'string');
handles.pixelthresh = str2num(pixelthresh_str);
timelimits_str = get(handles.edit_timelimits,'string');
handles.timelimits = str2num(timelimits_str);
maxseetime_str = get(handles.edit_maxseetime,'string');
handles.maxseetime = str2num(maxseetime_str);
handles.singlesuffix = get(handles.edit_singlesuffix,'string');
handles.combosuffix = get(handles.edit_combosuffix,'string');
guidata(hObject,handles); % Save variables


for i=1:numel(handles.sessions)
    % Run functions as in ImportData
    Import_3DS_Data_v3(handles.subject,handles.sessions(i),handles.eegsessions(i),handles.filetype,handles.pixelthresh,handles.timelimits);
    ImportToEeglab(handles.subject,handles.sessions(i),handles.eegsessions(i),handles.filetype);
    AddEeglabEvents(handles.subject,handles.sessions(i),handles.singlesuffix,handles.eventsrule,handles.maxseetime);
end
%Combine sessions
CombineEeglabSessions(handles.subject,handles.sessions,handles.singlesuffix,handles.combosuffix);



% --- Executes on button press in button_recalcevents.
function button_recalcevents_Callback(hObject, eventdata, handles)
% hObject    handle to button_recalcevents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
subject_str = get(handles.edit_subject,'string');
handles.subject = str2num(subject_str);
sessions_str = get(handles.edit_sessions,'string');
handles.sessions = str2num(sessions_str);
eventsrule_str = get(handles.popup_eventsrule,'string');
handles.eventsrule = eventsrule_str{get(handles.popup_eventsrule,'value')};
pixelthresh_str = get(handles.edit_pixelthresh,'string');
handles.pixelthresh = str2num(pixelthresh_str);
timelimits_str = get(handles.edit_timelimits,'string');
handles.timelimits = str2num(timelimits_str);
maxseetime_str = get(handles.edit_maxseetime,'string');
handles.maxseetime = str2num(maxseetime_str);
handles.singlesuffix = get(handles.edit_singlesuffix,'string');
handles.combosuffix = get(handles.edit_combosuffix,'string');
guidata(hObject,handles); % Save variables

% Use info to change files!
ChangeSacToObjThresholds(handles.subject,handles.sessions,handles.pixelthresh,...
    handles.timelimits,handles.eventsrule,handles.maxseetime,handles.singlesuffix,handles.combosuffix);



% --- Executes on button press in button_removeduds.
function button_removeduds_Callback(hObject, eventdata, handles)
% hObject    handle to button_removeduds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
subject_str = get(handles.edit_subject,'string');
handles.subject = str2num(subject_str);
duds_str = get(handles.edit_duds,'string');
eval(sprintf('handles.duds = {%s};',duds_str)); % make duds a cell array of strings
handles.inputsuffix = get(handles.edit_inputsuffix,'string');
handles.outputsuffix = get(handles.edit_outputsuffix,'string');
guidata(hObject,handles); % Save variables

% Remove bad electrodes
RemoveElectrodes(sprintf('3DS-%d%s.set',handles.subject,handles.inputsuffix),sprintf('3DS-%d%s.set',handles.subject,handles.outputsuffix),handles.duds);



% --- Executes on button press in button_removefrontal.
function button_removefrontal_Callback(hObject, eventdata, handles)
% hObject    handle to button_removefrontal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
subject_str = get(handles.edit_subject,'string');
handles.subject = str2num(subject_str);
handles.inputsuffix = get(handles.edit_inputsuffix,'string');
handles.outputsuffix = get(handles.edit_outputsuffix,'string');
filetype_str = get(handles.popup_filetype,'string');
handles.filetype = filetype_str{get(handles.popup_filetype,'value')};
guidata(hObject,handles); % Save variables

% Remove bad electrodes
RemoveFrontalElectrodes(sprintf('3DS-%d%s.set',handles.subject,handles.inputsuffix),sprintf('3DS-%d%s.set',handles.subject,handles.outputsuffix),handles.filetype);


% --- Executes on button press in button_removeblinks.
function button_removeblinks_Callback(hObject, eventdata, handles)
% hObject    handle to button_removeblinks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
subject_str = get(handles.edit_subject,'string');
handles.subject = str2num(subject_str);
handles.inputsuffix = get(handles.edit_inputsuffix,'string');
handles.outputsuffix = get(handles.edit_outputsuffix,'string');
filetype_str = get(handles.popup_filetype,'string');
handles.filetype = filetype_str{get(handles.popup_filetype,'value')};
guidata(hObject,handles); % Save variables

% Remove blink artifacts
blink_expand = [-50 100]; % ms to expand blinks outside the eyelink saccade events
outside_window = 25; % ms to average outside the blink window for mean subtraction
RemoveBlinkArtifacts(sprintf('3DS-%d%s.set',handles.subject,handles.inputsuffix),sprintf('3DS-%d%s.set',handles.subject,handles.outputsuffix),blink_expand,outside_window);


% --- Executes on button press in button_eyecalibration.
function button_eyecalibration_Callback(hObject, eventdata, handles)
% hObject    handle to button_eyecalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI field
subject_str = get(handles.edit_subject,'string');
handles.subject = str2num(subject_str);
eyesession_str = get(handles.edit_eyesession,'string');
handles.eyesession = str2num(eyesession_str);
handles.inputsuffix = get(handles.edit_inputsuffix,'string');
handles.outputsuffix = get(handles.edit_outputsuffix,'string');
filetype_str = get(handles.popup_filetype,'string');
handles.filetype = filetype_str{get(handles.popup_filetype,'value')};
reference_str = get(handles.popup_reference,'string');
handles.reference = reference_str{get(handles.popup_reference,'value')};
if strcmp(handles.reference,'Select Reference') % use default
    handles.reference = 'None';
end
guidata(hObject,handles); % Save variables

[~, eye_filename] = ImportEyeCalibration(handles.subject,handles.eyesession,handles.filetype);
% RemoveElectrodes(eye_filename,eye_filename,{'PO2'});
search_filename = sprintf('3DS-%d%s.set',handles.subject,handles.inputsuffix);
eyeremoved_filename = sprintf('3DS-%d%s.set',handles.subject,handles.outputsuffix);
UseEyeCalibration(search_filename,eye_filename,eyeremoved_filename,handles.reference); % creates 'eyeremoved' dataset

% RemoveFrontalElectrodes(search_filename, sprintf('3DS-%d-all-nofrontal.set',subject), filetype); % creates 'nofrontal' dataset
clear eye_filename search_filename eyeremoved_filename



% --- Executes on button press in button_epoch.
function button_epoch_Callback(hObject, eventdata, handles)
% hObject    handle to button_epoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
subject_str = get(handles.edit_subject,'string');
handles.subject = str2num(subject_str);
version_str = get(handles.popup_version,'string');
handles.version = version_str{get(handles.popup_version,'value')};
reference_str = get(handles.popup_reference,'string');
handles.reference = reference_str{get(handles.popup_reference,'value')};
if strcmp(handles.reference,'Select Reference') % use default
    handles.reference = 'None';
end
epochtimes_str = get(handles.edit_epochtimes,'string');
handles.epochtimes = str2num(epochtimes_str);
baselinetimes_str = get(handles.edit_baselinetimes,'string');
handles.baselinetimes = str2num(baselinetimes_str);
baseevent_str = get(handles.popup_baseevent,'string');
handles.baseevent = baseevent_str{get(handles.popup_baseevent,'value')};
handles.removeIncorrect = get(handles.check_incorrect,'value');
handles.removeBlinks = get(handles.check_blinks,'value');
handles.useCutoff = get(handles.check_cutoff,'value');
cutoff_str = get(handles.edit_cutoff,'string');
handles.cutoff = str2num(cutoff_str);
tepoch_str = get(handles.edit_t_win_epoch,'string');
handles.tepoch = str2num(tepoch_str);
tsaccade_str = get(handles.edit_t_win_saccade,'string');
handles.tsaccade = str2num(tsaccade_str);
tdiscrim_str = get(handles.edit_saccade_range,'string');
handles.tdiscrim = str2num(tdiscrim_str);
% Get events from GUI checkboxes
handles.eventnames = {};
handles.eventnumbers = [];
GetNumbers; % define numbers struct containing 3DSearch constants
if get(handles.check_event_stim,'value')
    handles.eventnames = [handles.eventnames, {'targapp','distapp'}];
    handles.eventnumbers = [handles.eventnumbers, Numbers.ENTERS+Numbers.TARGET, Numbers.ENTERS+Numbers.DISTRACTOR];
end
if get(handles.check_event_sac,'value')
    handles.eventnames = [handles.eventnames, {'targsac','distsac'}];
    handles.eventnumbers = [handles.eventnumbers, Numbers.SACCADE_TO+Numbers.TARGET, Numbers.SACCADE_TO+Numbers.DISTRACTOR];
end
if get(handles.check_event_vis,'value')
    handles.eventnames = [handles.eventnames, {'targsee','distsee'}];
    handles.eventnumbers = [handles.eventnumbers, Numbers.SEES+Numbers.TARGET, Numbers.SEES+Numbers.DISTRACTOR];
end
if get(handles.check_event_resp,'value')
    handles.eventnames = [handles.eventnames, {'targresp','distresp'}];
    handles.eventnumbers = [handles.eventnumbers, Numbers.BUTTON, Numbers.SIM_BUTTON];
end
guidata(hObject,handles); % Save variables


% Run Epoching - because we're using EEGLAB, we must evaluate these
% expressions in the base workspace, where EEGLAB is running!
filename = sprintf('3DS-%d-all-%s.set',handles.subject,handles.version); % use suffix indicated by input string 'version'

% USE BASELINE RELATIVE TO OBJECT APPEARANCE
if strcmp(handles.baseevent,'Stimulus')
    % epoch to appear time with baseline subtraction and wide epoch times
    [ALLEEG] = EpochEeglabFile(filename,[-2000 4000],handles.baselinetimes,...
        Numbers.ENTERS+[Numbers.TARGET, Numbers.DISTRACTOR],{'baseline=appear'},handles.reference); 
    % re-epoch to individual events with desired epoch times and no baseline subtraction
    [ALLEEG, EEG, CURRENTSET] = EpochEeglabFile(ALLEEG(end),handles.epochtimes,[],...
        handles.eventnumbers,handles.eventnames,handles.reference); 

% OR USE BASELINE RELATIVE TO EACH INDIVIDUAL EVENT
else
    [ALLEEG, EEG, CURRENTSET] = EpochEeglabFile(filename,handles.epochtimes,handles.baselinetimes,handles.eventnumbers,handles.eventnames,handles.reference);
end
    
% PERFORM EPOCHING
nFiles = length(ALLEEG);
for i=2:nFiles
    assignin('base','i',i);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'retrieve',i,'study',0);
    if handles.removeIncorrect
        EEG = RemoveIncorrectTrials(EEG);
    end
    if handles.removeBlinks
        EEG = RemoveEyeBlinkTrials(EEG,Numbers.BLINK,handles.tepoch,handles.tsaccade,handles.tdiscrim);        
    end
    if handles.useCutoff
        EEG = ExcludeTrialsByCutoff(EEG,handles.cutoff,handles.tepoch,handles.tsaccade,handles.tdiscrim);
    end
    %  Store results (but do not save)
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET,'overwrite','on','gui','off'); 
    EEG = eeg_checkset( EEG );
end
% Send results to base workspace so user can explore (and use them for
% analysis parts of this gui)
assignin('base','ALLEEG',ALLEEG);
assignin('base','EEG',EEG);
assignin('base','CURRENTSET',CURRENTSET);
evalin('base','eeglab redraw');

% --- Executes on button press in button_ploterps.
function button_ploterps_Callback(hObject, eventdata, handles)
% hObject    handle to button_ploterps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
timelock_str = get(handles.popup_timelock,'string');
handles.timelock = timelock_str{get(handles.popup_timelock,'value')};
guidata(hObject,handles); % Save variables

% Select which datasets to use (targets, then distractors for proper subtraction).
GetNumbers;
switch handles.timelock
    case 'Saccade'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.SACCADE_TO+Numbers.TARGET), find(handles.eventnumbers==Numbers.SACCADE_TO+Numbers.DISTRACTOR)];
    case 'Stimulus'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.ENTERS+Numbers.TARGET), find(handles.eventnumbers==Numbers.ENTERS+Numbers.DISTRACTOR)];
    case 'Visibility'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.SEES+Numbers.TARGET), find(handles.eventnumbers==Numbers.SEES+Numbers.DISTRACTOR)];
    case 'Response'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.BUTTON), find(handles.eventnumbers==Numbers.SIM_BUTTON)];
end

% Draw ERP
ALLEEG = evalin('base','ALLEEG'); % Get ALLEEG from base workspace
MakeErpMovie(ALLEEG,whichDatasets(1),whichDatasets(2)); % Make ERPs


% --- Executes on button press in button_run.
function button_run_Callback(hObject, eventdata, handles)
% hObject    handle to button_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get info from GUI fields
timelock_str = get(handles.popup_timelock,'string');
handles.timelock = timelock_str{get(handles.popup_timelock,'value')};
handles.doloo = get(handles.check_doloo,'value');
handles.bootstrap = get(handles.check_bootstrap,'value');
spw_str = get(handles.edit_spw,'string'); % Samples per window
handles.spw = str2num(spw_str);
sps_str = get(handles.edit_sps,'string'); % Samples per shift
handles.sps = str2num(sps_str);
guidata(hObject,handles); % Save variables

% Select which datasets to use (distractors, then targets for proper forward model).  
GetNumbers;
switch handles.timelock
    case 'Saccade'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.SACCADE_TO+Numbers.DISTRACTOR), find(handles.eventnumbers==Numbers.SACCADE_TO+Numbers.TARGET)];
    case 'Stimulus'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.ENTERS+Numbers.DISTRACTOR), find(handles.eventnumbers==Numbers.ENTERS+Numbers.TARGET)];
    case 'Visibility'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.SEES+Numbers.DISTRACTOR), find(handles.eventnumbers==Numbers.SEES+Numbers.TARGET)];
    case 'Response'
        whichDatasets = 1+[find(handles.eventnumbers==Numbers.SIM_BUTTON), find(handles.eventnumbers==Numbers.BUTTON)];
end

% Run Analysis - because we're using EEGLAB, we must evaluate these
% expressions in the base workspace, where EEGLAB is running!
ALLEEG = evalin('base','ALLEEG'); % Get ALLEEG from base workspace
[~, time, Azloo] = MakeLogRegMovie(ALLEEG,whichDatasets,1:ALLEEG(whichDatasets(1)).nbchan,handles.spw,handles.sps,handles.doloo,handles.bootstrap);

if handles.doloo
    % Save the results in the 'LOO.mat' file
    SaveLooResults(ALLEEG(whichDatasets(1)),ALLEEG(whichDatasets(2)),time,Azloo,handles.spw,handles.sps,datestr(now),handles.bootstrap);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         EDIT FUNCTIONS                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit_subject_Callback(hObject, eventdata, handles)
% hObject    handle to edit_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_subject as text
%        str2double(get(hObject,'String')) returns contents of edit_subject as a double

% Get subject number
subject_str = get(handles.edit_subject,'string');
% Set prefix for files in Cleanup Panel
set(handles.text_inputsuffix,'string',strcat('3DS-',subject_str));
set(handles.text_outputsuffix,'string',strcat('3DS-',subject_str));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        UNUSED FUNCTIONS                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function edit_subject_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_subject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sessions_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sessions as text
%        str2double(get(hObject,'String')) returns contents of edit_sessions as a double


% --- Executes during object creation, after setting all properties.
function edit_sessions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_filetype.
function popup_filetype_Callback(hObject, eventdata, handles)
% hObject    handle to popup_filetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_filetype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_filetype


% --- Executes during object creation, after setting all properties.
function popup_filetype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_filetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function edit_eyesession_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eyesession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eyesession as text
%        str2double(get(hObject,'String')) returns contents of edit_eyesession as a double


% --- Executes during object creation, after setting all properties.
function edit_eyesession_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eyesession (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_blinks.
function check_blinks_Callback(hObject, eventdata, handles)
% hObject    handle to check_blinks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_blinks


% --- Executes on button press in check_cutoff.
function check_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to check_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_cutoff



function edit_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to edit_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_cutoff as text
%        str2double(get(hObject,'String')) returns contents of edit_cutoff as a double


% --- Executes during object creation, after setting all properties.
function edit_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_timelock.
function popup_timelock_Callback(hObject, eventdata, handles)
% hObject    handle to popup_timelock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_timelock contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_timelock


% --- Executes during object creation, after setting all properties.
function popup_timelock_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_timelock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_doloo.
function check_doloo_Callback(hObject, eventdata, handles)
% hObject    handle to check_doloo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_doloo


% --- Executes on button press in check_bootstrap.
function check_bootstrap_Callback(hObject, eventdata, handles)
% hObject    handle to check_bootstrap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_bootstrap



function edit_spw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_spw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_spw as text
%        str2double(get(hObject,'String')) returns contents of edit_spw as a double


% --- Executes during object creation, after setting all properties.
function edit_spw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_spw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_sps_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sps as text
%        str2double(get(hObject,'String')) returns contents of edit_sps as a double


% --- Executes during object creation, after setting all properties.
function edit_sps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_eegsessions_Callback(hObject, eventdata, handles)
% hObject    handle to edit_eegsessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_eegsessions as text
%        str2double(get(hObject,'String')) returns contents of edit_eegsessions as a double


% --- Executes during object creation, after setting all properties.
function edit_eegsessions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_eegsessions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_version.
function popup_version_Callback(hObject, eventdata, handles)
% hObject    handle to popup_version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_version contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_version


% --- Executes during object creation, after setting all properties.
function popup_version_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_reference.
function popup_reference_Callback(hObject, eventdata, handles)
% hObject    handle to popup_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_reference contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_reference


% --- Executes during object creation, after setting all properties.
function popup_reference_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_eventsrule.
function popup_eventsrule_Callback(hObject, eventdata, handles)
% hObject    handle to popup_eventsrule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_eventsrule contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_eventsrule


% --- Executes during object creation, after setting all properties.
function popup_eventsrule_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_eventsrule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_singlesuffix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_singlesuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_singlesuffix as text
%        str2double(get(hObject,'String')) returns contents of edit_singlesuffix as a double


% --- Executes during object creation, after setting all properties.
function edit_singlesuffix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_singlesuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_combosuffix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_combosuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_combosuffix as text
%        str2double(get(hObject,'String')) returns contents of edit_combosuffix as a double


% --- Executes during object creation, after setting all properties.
function edit_combosuffix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_combosuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_pixelthresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixelthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixelthresh as text
%        str2double(get(hObject,'String')) returns contents of edit_pixelthresh as a double


% --- Executes during object creation, after setting all properties.
function edit_pixelthresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixelthresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_timelimits_Callback(hObject, eventdata, handles)
% hObject    handle to edit_timelimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_timelimits as text
%        str2double(get(hObject,'String')) returns contents of edit_timelimits as a double


% --- Executes during object creation, after setting all properties.
function edit_timelimits_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_timelimits (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_duds_Callback(hObject, eventdata, handles)
% hObject    handle to edit_duds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_duds as text
%        str2double(get(hObject,'String')) returns contents of edit_duds as a double


% --- Executes during object creation, after setting all properties.
function edit_duds_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_duds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_inputsuffix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_inputsuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_inputsuffix as text
%        str2double(get(hObject,'String')) returns contents of edit_inputsuffix as a double


% --- Executes during object creation, after setting all properties.
function edit_inputsuffix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_inputsuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_outputsuffix_Callback(hObject, eventdata, handles)
% hObject    handle to edit_outputsuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_outputsuffix as text
%        str2double(get(hObject,'String')) returns contents of edit_outputsuffix as a double


% --- Executes during object creation, after setting all properties.
function edit_outputsuffix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_outputsuffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_maxseetime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_maxseetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_maxseetime as text
%        str2double(get(hObject,'String')) returns contents of edit_maxseetime as a double


% --- Executes during object creation, after setting all properties.
function edit_maxseetime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_maxseetime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_epochtimes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_epochtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_epochtimes as text
%        str2double(get(hObject,'String')) returns contents of edit_epochtimes as a double


% --- Executes during object creation, after setting all properties.
function edit_epochtimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_epochtimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_baselinetimes_Callback(hObject, eventdata, handles)
% hObject    handle to edit_baselinetimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_baselinetimes as text
%        str2double(get(hObject,'String')) returns contents of edit_baselinetimes as a double


% --- Executes during object creation, after setting all properties.
function edit_baselinetimes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_baselinetimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_event_sac.
function check_event_sac_Callback(hObject, eventdata, handles)
% hObject    handle to check_event_sac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_event_sac


% --- Executes on button press in check_event_stim.
function check_event_stim_Callback(hObject, eventdata, handles)
% hObject    handle to check_event_stim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_event_stim


% --- Executes on button press in check_event_vis.
function check_event_vis_Callback(hObject, eventdata, handles)
% hObject    handle to check_event_vis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_event_vis


% --- Executes on button press in check_event_resp.
function check_event_resp_Callback(hObject, eventdata, handles)
% hObject    handle to check_event_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_event_resp


% --- Executes on selection change in popup_baseevent.
function popup_baseevent_Callback(hObject, eventdata, handles)
% hObject    handle to popup_baseevent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_baseevent contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_baseevent


% --- Executes during object creation, after setting all properties.
function popup_baseevent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_baseevent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t_win_epoch_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t_win_epoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t_win_epoch as text
%        str2double(get(hObject,'String')) returns contents of edit_t_win_epoch as a double


% --- Executes during object creation, after setting all properties.
function edit_t_win_epoch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t_win_epoch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t_win_saccade_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t_win_saccade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t_win_saccade as text
%        str2double(get(hObject,'String')) returns contents of edit_t_win_saccade as a double


% --- Executes during object creation, after setting all properties.
function edit_t_win_saccade_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t_win_saccade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_incorrect.
function check_incorrect_Callback(hObject, eventdata, handles)
% hObject    handle to check_incorrect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_incorrect



function edit_saccade_range_Callback(hObject, eventdata, handles)
% hObject    handle to edit_saccade_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_saccade_range as text
%        str2double(get(hObject,'String')) returns contents of edit_saccade_range as a double


% --- Executes during object creation, after setting all properties.
function edit_saccade_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_saccade_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
