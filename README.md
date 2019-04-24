# IndependentStudy_Spring2019
Yijie(EJay) Guo Independent Study for Spring 2019

## Summary
This project is designed to convert decision trees to knowledge bases, test the accuracies of both methods and check if the knowledge bases could produce the same level as the decision trees.

## System Requirements
1. Matlab 2017a or later
2. Python 2.7

## General Procedure

1. Use Feature_Extraction to generate examples, seperate these examples into training set and testing set and save them to one data file.

2. Use NormalDistributeAnalysis(NDA) to convert real continous numbers to integers using thresholding.

3. Use DecisionTree to train a decision tree using the training set.

4. Use DecisionTree_To_KnowledgeBase to calculate a knowledgebase using the previous decision tree and the training set.

5. Use KB_Nils to predict examples from the testing set and compare the accuracy from decision tree and knowledge base using BR_KB_Jacobian.

### Label Marker
1. Open the folder "[1] Feature_Extraction" and run "LabelMarker.m" using Matlab.

2. Click "Load Video" to specify a video file (.avi or .mov) to extract moving objects in the video.

    - a) If it is the first time trying to analyze the video, it will compute and generate background image first and save that image as 
    "imRef.mat" in the same folder as the video.
    
    - b) Once the computation is finished, a new figure window showing the first object will pop up and anthor timeline figure window will
    open as well indicating which object is being showed currently.
    
    - c) Click "Previous Frame", "Next Frame", "Jump Prev 30 Frames" or "Jump Next 30 Frames" to swith objects without labeling.
    
    - d) Click any of "Mark As Car", "Mark As Bus", "Mark As Truck", "Mark As Others" and "Mark As Zero" to label the current object.
    
3. After labeling is finished, click the "Save To Data File" to save all labeled objects to a data file specified by you.

4. Put all labeled data files into one data folder.

5. Click "Combine All Data File" to choose that data folder and the program will combine all single data files into one mega matrix data file "dataMatrix.mat" in the following format:

    - example01_Label, example01_Freature01, example01_Freature02, example01_Freature03, ..., example01_Freature12 
    
    - example02_Label, example02_Freature01, example02_Freature02, example02_Freature03, ..., example02_Freature12 
    
    - example03_Label, example03_Freature01, example03_Freature02, example03_Freature03, ..., example03_Freature12
    
    - ...

6. The combined data set will be seperated into two part: one training data set using 4/5 of all data set picked randomly and one testing data set using the remaining 1/5 of all data set
    
### NormalDistributeAnalysis(NDA)
1. Copy and Paste the previous matrix data file "dataMatrix.mat" into the "[2] NDA" folder.

2. Run the "NDA_Main_Loader.m" using the Matlab and the integer data file will be saved as "dataMatrix_Converted.mat" in the NDA folder.

### DecisionTree
1. Copy and Paste the previous converted data file "dataMatrix_Converted.mat" into the "[3] DecisionTree" folder.

2. Run the "DT_Main_Driver.m" and the decision tree will be generated using the training set and be saved as "DecisionTree.mat" in the same folder.

### DecisionTree_To_KnowledgeBase
1. Copy and Paste the previous converted data file "dataMatrix_Converted.mat" and the decision tree "DecisionTree.mat" into the "[4] DecisionTree_To_KnowledgeBase" folder.

2. Run the "DT_KB_Main_Loader.m" and the knowledge base will be generated using the training set and be saved as "KnowledgeBase.mat" in the same folder.

### KB_Nils
1. Copy and Paste the previous converted data file "dataMatrix_Converted.mat" and the knowledge base "KnowledgeBase.mat" into the "[5] KB_Nils" folder.

2. Set a breakpoint at the end of the "KB_Nils_Main_Loader.m" and Run the "KB_Nils_Main_Loader.m". 

3. The accuracy of the decision tree and the accuracy of the knowledge base will be calculated and displayed in the Matlab.

## Data Set

1.The default data set uses

    - 1333 examples with 666 cars, 333 buses and 333 trucks as the training data set
    
    - 300 examples with 100 cars, 100 buses and 100 trucks as the testing data set

2. There are several other data sets provided in the "TestData".
