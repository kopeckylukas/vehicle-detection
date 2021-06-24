%% |Vehicle Detector|
%
% Detect vehicles in images or in a sequence of video frames from either 
% moving or statical camera source. This detector is able to detect 
% vehicles from the rear view but is also able to detect the rear side of 
% vehicles from views where the aspect ratio of detected objects is not 
% affected by the angle of camera. 
%
% My implementation of this detector proposed in the model ‘carDetector_v11.xml’
% allows tracking of multiple vehicle types such as automobiles, lorries 
% and emergency vehicles. This model, however, detects a high rate of false
% positive instances. Nevertheless, those false positive instances are then
%filtered out by a support vector machine classifier. The classifier 
% ‘svm4.mat’ is capable to distinguish between all previously mentioned 
% vehicle types, i.e. cars, lorries and emergency vehicles, as well as 
% negative (false positive) instances. This solution allows for real-time 
% tracking of various vehicle types by using only a single detector.
%
%The outcome of detection and classification is then carried by visualisation 
% of rectangular labels over the video source and by saving detected data 
% in CSV files for each frame in the form of a 5-by-n matrix. The first 
% 4 columns [x,y,w,h] represent the size and position of the bounding box 
% where x and y specify the upper-left corner of the rectangle and w 
% specifies the width of the rectangle, which is its length along the x-axis 
% together with h which specifies the height of the rectangle, which is its 
% length along the y-axis. The fifth column carries string value of the vehicle type. 
% The name of CSV files corresponds to the name of each image or video frame. 
%
% Further analysis, such as F1 score, recall, precision and Jaccard index 
% can be calculated using the ‘data_analytics.m’ file. 
%
% Created by Lukas Kopecky
%
% 28 April 2021 @ University of Westmisnter 
%
% References: <https://uk.mathworks.com/help/vision/ref/selectstrongestbbox.html#bud6cbl-score>
%             <https://www.mathworks.com/help/matlab/ref/writecell.html>
%             <https://uk.mathworks.com/help/vision/ref/insertobjectannotation.html>


%% Load Files
detector = vision.CascadeObjectDetector('carDetector_v11.xml');
load('~/FYP/Code/Classifier/svm4.mat');
scenePath = fullfile ('~/FYP/Data/TestSample');
scenes = imageDatastore(scenePath);
fileNames = scenes.Files;

%Set image to a suitable size
globalImageSize = [480 640];


%% Process Sequence of images of video frames
for t = 1:numel(scenes.Files)
    
    name = fileNames(t);
    [~,filename,~] = fileparts(name);
    img = readimage(scenes, t);
    bbox = step(detector,img);
    [numOfDetectedObjects, ~] = size(bbox);
    toPrint = cell(numOfDetectedObjects,5);
    [labels,frameClassificationData] = clasifyDetected(bbox, img, classifier);
    
    for w = 1:numOfDetectedObjects
    toPrint{w,1} = bbox(w,1);
    toPrint{w,2} = bbox(w,2);
    toPrint{w,3} = bbox(w,3);
    toPrint{w,4} = bbox(w,4);
    
        if strcmp(labels(w,1),'car')
            toPrint{w,5} = 'car';
        end
        if strcmp(labels(w,1),'lorry')
            toPrint{w,5} = 'lorry';
        end
        if strcmp(labels(w,1),'false_positive')
            toPrint{w,5} = 'false_positive';
        end
        if strcmp(labels(w,1),'emergency')
            toPrint{w,5} = 'emergency';
        end
    
    end

    %Save labels to CSV files
    printName = fullfile("~/FYP/Data/Labels",filename);
    writecell(toPrint,printName,"FileType","spreadsheet");

    %Display annotations (for demonstration)
    anot = insertObjectAnnotation(img,'rectangle',bbox,labels(:,1),"Color",labels(:,2),"TextColor",labels(:,3));
    imshow(anot);
   
end 


%% Annotation Functions 
%Following code annotatates detected vehicles by their categorical labels

%Classify detected vehicles
function [anotated,classificationData] = clasifyDetected(objectCoordinates, I, classi)
%Get the numbner of Detected Objects
[numOfDetectedObjects, ~] = size(objectCoordinates);

%Create array for objects
labels = cell(numOfDetectedObjects,3);
otherData = cell(numOfDetectedObjects,3);

    for cr=1:numOfDetectedObjects
    
        coordinates = objectCoordinates(cr,:);
        croppedI = imcrop(I,coordinates);
        imres = imresize(croppedI, [480, 640]);
        features = extractHOGFeatures(imres,'CellSize',[90 90]);
        [classPredicted, NegLoss, PBScore] = predict(classi,features);
        [anotLabel, colour, fontColour] = getAnotation(classPredicted, NegLoss);
        
        labels{cr,1} = anotLabel;
        labels{cr,2} = colour;
        labels{cr,3} = fontColour;
        otherData{cr,3} = PBScore;
        otherData{cr,2} = NegLoss;
        otherData{cr,1} = classPredicted;
    end
    
    %Return data
    classificationData = otherData;
    anotated = labels;
end

% Get annotations and label colours
function [anotLabel, colour, fontColour] = getAnotation(classes, ~)
    switch double(classes)
        case 1
            anotLabel = ['car'];
            colour = 'yellow';
            fontColour = 'black';
        case 2
            anotLabel = ['lorry'];
            colour = 'green';
            fontColour = 'black';
        case 3
            anotLabel = ['false_positive'];
            colour = 'white';
            fontColour = 'black';    
        otherwise
            anotLabel = ['emergency'];
            colour = 'red';
            fontColour = 'black';
    end
end