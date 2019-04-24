function varargout = LabelMarker(varargin)
% LABELMARKER MATLAB code for LabelMarker.fig
%      LABELMARKER, by itself, creates a new LABELMARKER or raises the existing
%      singleton*.
%
%      H = LABELMARKER returns the handle to a new LABELMARKER or the handle to
%      the existing singleton*.
%
%      LABELMARKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELMARKER.M with the given input arguments.
%
%      LABELMARKER('Property','Value',...) creates a new LABELMARKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LabelMarker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LabelMarker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LabelMarker

% Last Modified by GUIDE v2.5 16-Mar-2019 19:07:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LabelMarker_OpeningFcn, ...
                   'gui_OutputFcn',  @LabelMarker_OutputFcn, ...
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
end


% --- Executes just before LabelMarker is made visible.
function LabelMarker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LabelMarker (see VARARGIN)

% Choose default command line output for LabelMarker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LabelMarker wait for user response (see UIRESUME)
% uiwait(handles.figure1);

        handles.BTN_Load_Video.UserData.listFrames = [];
        handles.BTN_Load_Video.UserData.idxFrame = -1;
        handles.BTN_Load_Video.UserData.jumper = 30;
        
    	handles.BTN_Load_Video.UserData.WIDTH_BLOCK = 20;
        handles.BTN_Load_Video.UserData.HEIGHT_LINE = 100;
    
    	handles.BTN_Load_Video.UserData.SIZE_INTERVAL = 3;

end


% --- Outputs from this function are returned to the command line.
function varargout = LabelMarker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end



% --- Executes on button press in BTN_Load_Video.
function BTN_Load_Video_Callback(hObject, eventdata, handles)
% hObject    handle to BTN_Load_Video (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [charFileName,charFilePath] = uigetfile({'*.avi'; '*.mov'; '*.*'});
    
    strVideoFilePath = convertCharsToStrings(charFilePath) + convertCharsToStrings(charFileName);
    
    charVideoFilePath = char(strVideoFilePath);
    
    [~,lengthName] = size(charFileName);
    
    if lengthName > 1
        
%         videoRef = VideoReader(charVideoFilePath);
%         imRef_RGB = BR_Video_Generate_ImRef(videoRef);
%         pathRef = [charFilePath,'/imRef_RGB'];
%         save(pathRef,'imRef_RGB');
        
        fileImRef = convertCharsToStrings(charFilePath) + "imRef_RGB.mat";
        if isfile(fileImRef)
            load(fileImRef);
        else
            videoRef = VideoReader(charVideoFilePath);
            imRef_RGB = BR_Video_Generate_ImRef(videoRef);
            pathRef = [charFilePath,'/imRef_RGB'];
            save(pathRef,'imRef_RGB');
        end
        video = VideoReader(charVideoFilePath);
        listFrames_All = BR_Video_Process_AVI(video, imRef_RGB);
        
        [NumFrames, ~] = size(listFrames_All);
        
        listFrames = [];
        
        for idxFrame = 1:NumFrames
            frame = listFrames_All(idxFrame);
            if frame.isEmpty == 0
                listFrames = [listFrames; frame];
            end
        end
        
        handles.BTN_Load_Video.UserData.listFrames = listFrames;
        
        handles.CB_Label.Value = 0;
        
        Helper_Show_First_Available_Image(handles);
        
        Helper_Initialize_Label_TimeLine(handles);
        Helper_Refresh_Label_TimeLine(handles);
        
    end

end


% --- Executes on button press in BTN_Save_To_Data_File.
function BTN_Save_To_Data_File_Callback(hObject, eventdata, handles)
% hObject    handle to BTN_Save_To_Data_File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    listFrames_All = handles.BTN_Load_Video.UserData.listFrames;
    
    [NumFrames_All, ~] = size(listFrames_All);
    
   listFrames = []; 
    
    for idxFrame = 1:NumFrames_All
        frame = listFrames_All(idxFrame);
        
        if frame.isEmpty == 0 && frame.label ~= 0
            
            imageBW = frame.object.imageBW_Refined;
        
            imageEdge = edge(imageBW,'Canny');

            B = bwboundaries(imageEdge);

            listPts = B{1};

            X = CS6640_FFT_shape(listPts, 5);

            frame.object.Curvature.fourierCoefficients = X;
        
            listFrames = [listFrames; frame];
        end
        
    end
    
%     matrixData = BR_Matrix_Generator(listFrames);
    
%     data.listFrames = listFrames;
    data.listFrames = listFrames;
    
%     dirSaving = uigetdir;
%     
%     fileImRef = convertCharsToStrings(dirSaving) + "\dataFile.mat";
    
    startingFolder = pwd;
    defaultFileName = fullfile(startingFolder, '*.*');
    
    [baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
    
    if baseFileName == 0
      % User clicked the Cancel button.
      return;
    end
    fullFileName = fullfile(folder, baseFileName);


    save(fullFileName, 'data', '-v7.3');
    
    msg = "File Saved: " + fullFileName;
    
    disp(msg);
    
end

% --- Executes on button press in CB_Label.
function CB_Label_Callback(hObject, eventdata, handles)
% hObject    handle to CB_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CB_Label
    msg = sprintf("Label: %d", handles.CB_Label.Value);
%     disp(msg);
end

% --- Executes on button press in BTN_Next_Frame.
function BTN_Next_Frame_Callback(hObject, eventdata, handles)
% hObject    handle to BTN_Next_Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFrameNext = idxFrame + 1;
    
    isSuccess = Helper_Show_Image(handles, idxFrameNext);
    
%     isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrame);
    
    Helper_Refresh_Label_TimeLine(handles);
    
end

% --- Executes on button press in BTN_Previous_Frame.
function BTN_Previous_Frame_Callback(hObject, eventdata, handles)
% hObject    handle to BTN_Previous_Frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFramePre = idxFrame - 1;
    
    isSuccess = Helper_Show_Image(handles, idxFramePre);
    
%     isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrame);
    
    Helper_Refresh_Label_TimeLine(handles);
    
end

% --- Executes on button press in BTN_Jump_Next_Frames.
function BTN_Jump_Next_Frames_Callback(hObject, eventdata, handles)
% hObject    handle to BTN_Jump_Next_Frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    jumper = handles.BTN_Load_Video.UserData.jumper;
    
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFrameNext = idxFrame + jumper;
    
    isSuccess = Helper_Show_Image(handles, idxFrameNext);
    
%     isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrameNext - 1);
    
    Helper_Refresh_Label_TimeLine(handles);
    
end

% --- Executes on button press in BTN_Jump_Pre_Frames.
function BTN_Jump_Pre_Frames_Callback(hObject, eventdata, handles)
% hObject    handle to BTN_Jump_Pre_Frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    jumper = handles.BTN_Load_Video.UserData.jumper;
    
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFramePre = idxFrame - jumper;
    
    isSuccess = Helper_Show_Image(handles, idxFramePre);
    
%     isLabelSuccess = Helper_Label_Marker(handles, idxFramePre + 1, idxFrame);
    
    Helper_Refresh_Label_TimeLine(handles);
    
end

function Helper_Show_First_Available_Image(handles)

    listFrames = handles.BTN_Load_Video.UserData.listFrames;
    
    [NumFrames, ~] = size(listFrames);
    
    
    
    idxFirst = 0;
    
    for idxFrame = 1:NumFrames
        
        frame = listFrames(idxFrame);
        
        if frame.isEmpty == 0
            idxFirst = idxFrame;
            break;
        end
        
    end
    
    if idxFirst > 0 && idxFirst <= NumFrames
        Helper_Show_Image(handles, idxFirst);
    end

end

function isSuccess = Helper_Show_Image(handles, idxFrame)

    isSuccess = 0;

    listFrames = handles.BTN_Load_Video.UserData.listFrames;
    
    [NumFrames, ~] = size(listFrames);
    
    if idxFrame > 0 && idxFrame <= NumFrames
        
        frame = listFrames(idxFrame);
        
        if frame.isEmpty == 0
        
            figImage = figure(127);
            

            imshowpair(frame.object.image_Refined, frame.object.imageBW_Refined, 'montage');
            
            set(figImage,'Position',[10 500 1000 500])

            handles.BTN_Load_Video.UserData.idxFrame = idxFrame;

            isSuccess = 1;
        
        end
        
    end
    
    
    

end

function isSuccess = Helper_Label_Marker(handles, idxStart, idxEnd, labelMarked)

    isSuccess = 0;

    listFrames = handles.BTN_Load_Video.UserData.listFrames;
    
    [NumFrames, ~] = size(listFrames);
    
    if idxStart > 0 && idxStart <= NumFrames && idxEnd > 0 && idxEnd <= NumFrames 
        label = labelMarked;
        
        
        for idxFrame = idxStart:idxEnd
            
            frame = listFrames(idxFrame);
            
            
            
            frame.label = label;
            
            listFrames(idxFrame) = frame;
            
        end
        
        isSuccess = 1;
        
        handles.BTN_Load_Video.UserData.listFrames = listFrames;
        
        msg = sprintf("[Idx%d, ---- Idx%d] Label = %d", idxStart, idxEnd, label);
        
        disp(msg);
        
    end


end

function Helper_Initialize_Label_TimeLine(handles)

    listFrames = handles.BTN_Load_Video.UserData.listFrames;
    
    [NumFrames, ~] = size(listFrames);
    
    WIDTH_BLOCK = handles.BTN_Load_Video.UserData.WIDTH_BLOCK;
    HEIGHT_LINE = handles.BTN_Load_Video.UserData.HEIGHT_LINE;
    LINE_NUM = 1;
    SIZE_INTERVAL = handles.BTN_Load_Video.UserData.SIZE_INTERVAL;
    numCol =WIDTH_BLOCK * NumFrames + SIZE_INTERVAL * (NumFrames - 1);
    
    imTimeLine = zeros(HEIGHT_LINE, numCol, 3, 'uint8');
    
    for idxFrame = 1:NumFrames - 1
        
        idxCol = 1 + WIDTH_BLOCK * idxFrame + SIZE_INTERVAL * (idxFrame-1);
        
        for idxIntervel = idxCol:idxCol + SIZE_INTERVAL - 1
            
            for m = 1:HEIGHT_LINE
                
                imTimeLine(m,idxIntervel,:) = [255, 255, 255];
                
            end
            
        end
        
    end
    
    handles.BTN_Load_Video.UserData.imTimeLine = imTimeLine;


end

function Helper_Refresh_Label_TimeLine(handles)

    
    
    listFrames = handles.BTN_Load_Video.UserData.listFrames;
    
    idxFrameCurrent = handles.BTN_Load_Video.UserData.idxFrame;

    imTimeLine = handles.BTN_Load_Video.UserData.imTimeLine;
    
    WIDTH_BLOCK = handles.BTN_Load_Video.UserData.WIDTH_BLOCK;
    HEIGHT_LINE = handles.BTN_Load_Video.UserData.HEIGHT_LINE;

    SIZE_INTERVAL = handles.BTN_Load_Video.UserData.SIZE_INTERVAL;
    
    [NumFrames, ~] = size(listFrames);
    
    for idxFrame = 1:NumFrames
        frame = listFrames(idxFrame);
        
        if frame.isEmpty == 0 
            
            idxCol = 1 + WIDTH_BLOCK * (idxFrame - 1) + SIZE_INTERVAL * (idxFrame-1);
        
            for idxBlock = idxCol:idxCol + WIDTH_BLOCK - 1
            
                for m = 1:HEIGHT_LINE
                
                    if frame.label == 1
                        imTimeLine(m,idxBlock,:) = [255, 0, 0];
                    elseif frame.label == 2
                        imTimeLine(m,idxBlock,:) = [0, 255, 0];
                    elseif frame.label == 3
                        imTimeLine(m,idxBlock,:) = [0, 0, 255];
                    elseif frame.label == 4
                        imTimeLine(m,idxBlock,:) = [255, 255, 0];
                    elseif frame.label == 0
                        imTimeLine(m,idxBlock,:) = [0, 0, 0];
                    end
                    
                    if idxFrame == idxFrameCurrent
                        imTimeLine(m,idxBlock,:) = [255, 255, 255];
                    end
                    
                end

            end
            
        end
        
    end
    
    figure(128);
    imshow(imTimeLine);
    
    
    handles.BTN_Load_Video.UserData.imTimeLine = imTimeLine;
end


% --- Executes on button press in MarkAsCar1.
function MarkAsCar1_Callback(hObject, eventdata, handles)
% hObject    handle to MarkAsCar1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFrameNext = idxFrame + 1;
    
    isSuccess = Helper_Show_Image(handles, idxFrameNext);
    
    isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrame,1);
    
    Helper_Refresh_Label_TimeLine(handles);
end

% --- Executes on button press in MarkAsBus2.
function MarkAsBus2_Callback(hObject, eventdata, handles)
% hObject    handle to MarkAsBus2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFrameNext = idxFrame + 1;
    
    isSuccess = Helper_Show_Image(handles, idxFrameNext);
    
    isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrame,2);
    
    Helper_Refresh_Label_TimeLine(handles);
end

% --- Executes on button press in MarkAsTruck3.
function MarkAsTruck3_Callback(hObject, eventdata, handles)
% hObject    handle to MarkAsTruck3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFrameNext = idxFrame + 1;
    
    isSuccess = Helper_Show_Image(handles, idxFrameNext);
    
    isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrame,3);
    
    Helper_Refresh_Label_TimeLine(handles);
end


% --- Executes on button press in MarkAsOthers4.
function MarkAsOthers4_Callback(hObject, eventdata, handles)
% hObject    handle to MarkAsOthers4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFrameNext = idxFrame + 1;
    
    isSuccess = Helper_Show_Image(handles, idxFrameNext);
    
    isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrame,4);
    
    Helper_Refresh_Label_TimeLine(handles);
end


% --- Executes on button press in MarkAsZero0.
function MarkAsZero0_Callback(hObject, eventdata, handles)
% hObject    handle to MarkAsZero0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    idxFrame = handles.BTN_Load_Video.UserData.idxFrame;
    
    idxFrameNext = idxFrame + 1;
    
    isSuccess = Helper_Show_Image(handles, idxFrameNext);
    
    isLabelSuccess = Helper_Label_Marker(handles, idxFrame, idxFrame, 0);
    
    Helper_Refresh_Label_TimeLine(handles);

end


% --- Executes on button press in CombineAllDataFile.
function CombineAllDataFile_Callback(hObject, eventdata, handles)
% hObject    handle to CombineAllDataFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    folderPath = uigetdir();
    [~,length] = size(folderPath);
    
   
    listFileInfo = dir(fullfile(folderPath, '*.mat'));
    
    [NumDataFiles, ~] = size(listFileInfo);
    
    listFrames_Combined = [];
    
    for idxFile = 1:NumDataFiles
        
        fileInfo = listFileInfo(idxFile);
        
        dataFilePath = convertCharsToStrings(fileInfo.folder) + "/" + convertCharsToStrings(fileInfo.name);
        
        if isfile(dataFilePath)

            load(dataFilePath);

            listFrames_Combined = [listFrames_Combined; data.listFrames];
        end
            
    end
    
    dataRaw.listFrames = listFrames_Combined;
    
    [setData, listDataNames] = BR_Data_Matrix_Generator(listFrames_Combined);
    
%     setData_Seperated = BR_Data_Matrix_Seperate_By_Label(setData);

    setData01 = setData(setData(:,1) == 1, :);
    [Num01,~] = size(setData01);
    Num01_5 = int32(Num01/5);
    sizeTrain01 = Num01_5*4;
    sizeDev01 = 1;
%     sizeTest01 = Num01 - sizeTrain01 - sizeDev01;
    sizeTest01 = 100;
    
    setData02 = setData(setData(:,1) == 2, :);
    [Num02,~] = size(setData02);
    Num02_5 = int32(Num02/5);
    sizeTrain02 = Num02_5*4;
    sizeDev02 = 1;
%     sizeTest02 = Num02 - sizeTrain02 - sizeDev02;
    sizeTest02 = 100;
    
    setData03 = setData(setData(:,1) == 3, :);
    [Num03,~] = size(setData03);
    Num03_5 = int32(Num03/5);
    sizeTrain03 = Num03_5*4;
    sizeDev03 = 1;
%     sizeTest03 = Num03 - sizeTrain03 - sizeDev03;
    sizeTest03 = 100;
    
    setData04 = setData(setData(:,1) == 4, :);
    
    [setDataTrain01, setDataDev01, setDataTest01] = BR_Data_Matrix_Seperate_To_Training_Developing_Testing(setData01, sizeTrain01, sizeDev01, sizeTest01);
    [setDataTrain02, setDataDev02, setDataTest02] = BR_Data_Matrix_Seperate_To_Training_Developing_Testing(setData02, sizeTrain02, sizeDev02, sizeTest02);
    [setDataTrain03, setDataDev03, setDataTest03] = BR_Data_Matrix_Seperate_To_Training_Developing_Testing(setData03, sizeTrain03, sizeDev03, sizeTest03);
    
    setDataTrain01 = setDataTrain01(1:666,:);
    setDataTrain02 = setDataTrain02(1:333,:);
    setDataTrain03 = setDataTrain03(1:333,:);
    
    dataMatrix.setData = setData;
    dataMatrix.setDataTrain = [setDataTrain01; setDataTrain02; setDataTrain03];
    dataMatrix.setDataDev = [setDataDev01; setDataDev02; setDataDev03];
    dataMatrix.setDataTest = [setDataTest01; setDataTest02; setDataTest03];
    dataMatrix.listDataNames = listDataNames;
    
    pathRef = [folderPath,'\dataMatrix'];
    save(pathRef,'dataMatrix', '-v7.3');
        
end