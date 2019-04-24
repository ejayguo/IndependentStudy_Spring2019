function DisplayDecisionTree(nodeRoot)

% nodes(1) = 0;     % Root node
% nodes(2) and nodes(8) are children of nodes(1), so set these elements of the input vector to 1:
% 
% nodes(2) = 1;     nodes(8) = 1;
% nodes(5:7) are children of nodes(4), so set these elements to 4:
% 
% nodes(5) = 4;     nodes(6) = 4;     nodes(7) = 4;
% Continue in this manner until each element of the vector identifies its parent. For the plot shown above, the nodes vector now looks like this:

% nodes = [0 1 2 2 4 4 4 1 8 8 10 10];
% Now call treeplot to generate the plot:


    
    figure(1532);
    
%     [~,NumNode] = size(nodeTest);
    
    indexMax = FindMaxIndex(nodeRoot, -1);

    arrayNode = zeros(1,indexMax);
    
    arrayString = cell(1, indexMax);
    for idxNum = 1:indexMax
        arrayString{idxNum} = "";
    end
    
    [arrayNodeRTN, arrayStringRTN] = RecursionTree(nodeRoot, arrayNode, arrayString);
    
    treeplot(arrayNodeRTN);
    
    [x,y] = treelayout(arrayNodeRTN);
    
    for i=1:indexMax
        strNode = arrayStringRTN{i};
        
        lengthName = length(strNode);
        
        textOffset = 0.025;
        
        if lengthName < 1
            strNode = num2str(nodeTest(i).value);
            textOffset = -0.025;
        end
        
        t = text(x(i),y(i)+textOffset,strNode);
        s = t.FontSize;
        t.FontSize = 12;
    end

end

function indexMax = FindMaxIndex(node, indexMax)
    
    indexMaxCurrent = node.index;
    
    if indexMaxCurrent > indexMax
        indexMax = indexMaxCurrent;
    end
    
    if ~isempty(node.children)
        [NumChildren, ~] = size(node.children);
        
        for idxChild = 1:NumChildren
            nodeChild = node.children(idxChild);
            indexMax = FindMaxIndex(nodeChild, indexMax);
        end
        
        
    end

end

function [arrayNodeParentRTN, arrayNodeStringRTN] = RecursionTree(node, arrayNodeParent, arrayNodeString)

    arrayNodeParentRTN = arrayNodeParent;
    arrayNodeStringRTN = arrayNodeString;
    
    stringVal = "";
        
    if ~isempty(node.parent)
        
        arrayNodeParentRTN(node.index) = node.parent.index;
        
        stringVal = convertCharsToStrings(node.parent.nameCol) + ": " + node.value;
        
        if node.label ~= -1
            stringVal = stringVal + "=" + convertCharsToStrings(num2str(node.label));
        else
            
            if strlength(node.nameCol) > 0
                stringVal = stringVal + newline + convertCharsToStrings(node.nameCol);
            end
        
        end
        
    else
        
        if strlength(node.nameCol) > 0
            stringVal = convertCharsToStrings(node.nameCol);
        end
        
    end
    
    arrayNodeStringRTN{node.index} = stringVal;
    
    if ~isempty(node.children)
        [NumChildren, ~] = size(node.children);

        for idxChild = 1:NumChildren
            nodeChild = node.children(idxChild);
            nodeChild.parent = node;
            
%             arrayNodeParentRTN, arrayNodeStringRTN
            
            [arrayChildParentRTN, arrayChildStringRTN] = RecursionTree(nodeChild, arrayNodeParentRTN, arrayNodeStringRTN);

            arrayMergedParent = MergeArray(arrayChildParentRTN, arrayNodeParentRTN);
            
            arrayMergedString = MergeStringArray(arrayChildStringRTN, arrayNodeStringRTN);

            arrayNodeParentRTN = arrayMergedParent;
            arrayNodeStringRTN = arrayMergedString;
        end

    end
    
    

end


function arrayMerged = MergeArray(array01, array02)

    [~, Num01] = size(array01);
    [~, Num02] = size(array02);
    
    
    
    if Num01 ~= Num02
        ERROR = 1;
    end
    
    arrayMerged = zeros(1, Num01);
    
    for idxNum = 1:Num01
        
        if array01(idxNum) == 0 && array02(idxNum) ~= 0
            
            arrayMerged(idxNum) = array02(idxNum);
            
        elseif array01(idxNum) ~= 0 && array02(idxNum) == 0
            
            arrayMerged(idxNum) = array01(idxNum);
            
        elseif array01(idxNum) == 0 && array02(idxNum) == 0
            
            arrayMerged(idxNum) = 0;
            
        elseif array01(idxNum) == array02(idxNum) 
            
            arrayMerged(idxNum) = array01(idxNum);
            
        end
        
        
    end
end

function arrayStringMerged = MergeStringArray(array01, array02)

    [~, Num01] = size(array01);
    [~, Num02] = size(array02);
    
    
    
    if Num01 ~= Num02
        ERROR = 1;
    end
    
    arrayStringMerged = cell(1, Num01);
    for idxNum = 1:Num01
        arrayStringMerged{idxNum} = "";
    end
    
    for idxNum = 1:Num01
        
        if strlength(array01{idxNum}) >=  strlength(array02{idxNum})
            
            arrayStringMerged{idxNum} = array01{idxNum};
            
        elseif strlength(array01{idxNum}) <  strlength(array02{idxNum})
            
            arrayStringMerged{idxNum} = array02{idxNum};
            
        elseif strlength(array01{idxNum}) == 0 && strlength(array02{idxNum}) == 0
            
            arrayStringMerged{idxNum} = "";
                        
        end
        
        
    end

end


