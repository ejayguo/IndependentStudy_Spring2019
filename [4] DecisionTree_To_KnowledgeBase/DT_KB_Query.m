function [labelRtn, pathRtn] = DT_KB_Query(nodeRoot, example)
    labelRtn = -1;
    
    node = nodeRoot;
    
    nodeLabel = node.label;
    nodeLabelMax = node.labelMax;
    [NumChildren,~] = size(node.children);
    
    path = [];
    
    while NumChildren > 0
        
        valueCurrent = example(node.indexCol);
        path = [path, valueCurrent];
               
        idxNextPath = -1;
        
        for idxChild = 1:NumChildren
            
            nodeChild = node.children(idxChild);
            
            valueChild = nodeChild.value;
            
            if valueCurrent == valueChild
                idxNextPath = idxChild;
                
                break;
            end
            
            
        end
        
        if idxNextPath ~= -1
            
            nodeNext = node.children(idxNextPath);
            
            node = nodeNext;
            nodeLabel = node.label;
            nodeLabelMax = node.labelMax;
            [NumChildren,~] = size(node.children);
            
            
            
        else
            break;
        end
        
        
        
    end
    
    if nodeLabel ~= -1
        labelRtn = nodeLabel;
    end
    
    if labelRtn == -1
        labelRtn = nodeLabelMax;
    end
    
    pathRtn = path;
    
end

