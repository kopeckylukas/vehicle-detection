%% |Data Analytics|
%
% Calculate performance of your detection model. Comparing ground truth 
% (actual data) against detected labels reveals actual performance of 
% detection model. If the model outcome correctly matches a ground truth 
% class, the result is classified as a true positive (TP). 
% The true negative (TN) outcome occurs when the model correctly predicts 
% a negative class. False positive (FP) outcomes occur when the model 
% incorrectly classifies positive classes, while false negatives (FN) 
% refer to instances where the model incorrectly predicts a negative class.
%
% Precision = TP / (TP + FP)
% 
% Recall = TP / (TP + FN)
%
% FI Score = 2 * (Precision * Recall) / (Precision + Recall);
%
% The Jaccard index is then calculated as the area of the intersection of
% the two regions divided by the area of the union of the two regions.
% Socre higher than 0.5 is considered to be a good detectin and higher than
% 0.7 as en excelent detection. 
%
%
% Created by Lukas Kopecky 
% 
% 28 April 2021 @ University of Westminster 
% 
% References: <https://uk.mathworks.com/help/vision/ref/bboxoverlapratio.html>
%             <https://en.wikipedia.org/wiki/Precision_and_recall>
%             <https://machinelearningmastery.com/classification-accuracy-is-not-enough-more-performance-measures-you-can-use/>


%% Load data

% Set the name of the histogram
name = 'UFPR ALPR (all)';
% path to the detected labels
detName = '~/FYP/Data/Labels/ufpr_alpr_csv/validation';
% path to ground truth labels
labName = '~/FYP/Data/Annotations/ufpr_alpr/validation';
detectedFiles = dir(detName);
labelsFiles = dir(labName);

% create array that will store jaccard indices, the length of the array
% equals to the number of fieles - 2 (. and .. are part of file structure 
% in macOS and unix based systems, change this to zero for MS Windows)
store = zeros(length(labelsFiles)-2,1);

% Set numebr of occurances for true postives, false positive and false
% negatives to 0

FP = 0;
TP = 0;
FN = 0;
misclass = 0;

%% Analyse data

% Ananlyse data (start with walue 3 for macOS and Unix, 0 for MS Windows)
for i=3:length(labelsFiles)
    
    % retrieve detecte labels an dground truth labels
    myDetectedName = fullfile(detectedFiles(i).name);
    myLabelName =  fullfile(labelsFiles(i).name);
    
    myDetected = fullfile(detName,myDetectedName);
    myLabel = fullfile(labName,myLabelName);
    
    % extract detected labels and groud truth labels
    [FN1, detected] = extractDetected(myDetected, FN);
    labeled = extractLabel(myLabel);
    
    % Claculate jaccard index
    overlapRatio = bboxOverlapRatio(labeled,detected);
    r = i-2;
    
    % if more than label retrieved, select the strongest overlap ratio and
    % set the others as false postive
    if numel(overlapRatio)>1
        store(r,1) = max(overlapRatio);
        FP = FP + numel(overlapRatio) - 1;
    else
        store(r,1) = overlapRatio;
    end
   
    %set the number of flase negatives for each itteration 
    FN = FN1; 
end

% calculate analytics 
TP = numel(store) - FN;
precision = TP / (TP + FP);
recall = TP / (TP + FN);
f1 = 2 * (precision * recall) / (precision + recall);



%% Display Analytics

% display chart
displayChart(store, name);

% display analytics
disp("Recall: "+string(recall));
disp("Precision: "+string(precision));
disp("F1 Score: "+string(f1));
disp("Mean IoU: "+string(mean(store)));
disp("STD IoU: "+string(std(store)));


%% Helper functions

%Set up histogram values
function [retHist] = displayChart (store, name)
    mn = mean( store);
    st = std(store);
    h = histogram (store, 'FaceColor','#ffffcc', 'BinWidth', 0.1);
    xlabel('Jaccard Score (IoU)');
    ylabel('Number of detections');
    xlim([0, 1]);
    xline(mn, 'Color', '#77AC30', 'LineWidth', 2);
    xline(mn - st, 'Color', '#D95319', 'LineWidth', 2, 'LineStyle', '-.');
    xline(mn + st, 'Color', '#D95319', 'LineWidth', 2, 'LineStyle', '-.');
    histTitle = sprintf(name);
    title(histTitle, 'FontSize', 15);
    retHist = h;
end

 % Extract dtected labels form csv files
function [FN1, detectedMatrix] = extractDetected(filePath, FN)
    gettable = readtable(filePath);
    if height(gettable) > 0
        detectedMatrix = table2array (gettable(:,1:4));
        FN1 = FN;
    else 
        % if a there is no detections, False negative will increase by one
        % and label [1,1,1,1]. Position and size of such as label won't
        % affect the Jaccard score 
        detectedMatrix = [1,1,1,1];
        FN1 = FN + 1;
    end  
    
end

% Extract bbox data form a txt file 
% txt fiels with true dtections were provided by together with testing and 
% training datasets by the ITI research Group.  
function [labelMatrix] = extractLabel(filepath) 
    content = fileread (filepath);
    retStruct = regexp(content,'position_vehicle: (?<var1>\d+) (?<var2>\d+) (?<var3>\d+) (?<var4>\d+)', "names");
    vehicleType = regexp(content,'type: (?<var5>\w+)', "names");
    display(vehicleType);
    tableR = struct2table(retStruct);
    vect1 = table2array(tableR(:,1));
    vect2 = table2array(tableR(:,2));
    vect3 = table2array(tableR(:,3));
    vect4 = table2array(tableR(:,4));
    num1 = str2double(vect1);
    num2 = str2double(vect2);
    num3 = str2double(vect3);
    num4 = str2double(vect4);
    labelMatrix = [num1, num2, num3, num4];
end