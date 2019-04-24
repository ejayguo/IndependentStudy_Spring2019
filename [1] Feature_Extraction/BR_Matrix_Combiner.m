function BR_Matrix_Combiner()

    charFolderPath = uigetdir();

    listInfoFiles = dir([charFolderPath '/*.mat']);

    NumFiles = size(listInfoFiles,1);

    matrixExamples = [];
    listExamples = [];
    listProperties = [];

    setData_Raw = [];

    for idxFile = 1:NumFiles

        infoFile = listInfoFiles(idxFile);
        charFileName = infoFile.name;
        charFileFolder = infoFile.folder;

        strFilePath = convertCharsToStrings(charFileFolder) + "\" + convertCharsToStrings(charFileName);
        charFilePath = char(strFilePath);

        S = load(charFilePath);

        setData_Raw = [setData_Raw; setData.data];


    end
    
    csvwrite(char(convertCharsToStrings(charFolderPath) + "\MatrixRaw.csv"),matrixOneAll);

end