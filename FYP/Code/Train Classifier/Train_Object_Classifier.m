%% |Train SVM object classifier|
%
% Train object classifier using HOG feature extraction and multiclass models
% for support vector machines. To retrieve data with identical feature 
% vector length instances are resized to 640 x 480 px which is 
% standard 4:3 aspect ratio.  
%
% This implementation can be used for any kind of object classification. 
% The number of classes depends on the structure and number of subfolders 
% in the dataset. The files are then randomly sampled for training and testing
% in the ratio of 4:1. 
% 
% Created by Lukas Kopecky 
% 
% 28 April 2021 @ University of Westminster 
% 
% Reference: <https://www.mathworks.com/help/stats/support-vector-machines-for-binary-classification.html#bsr5o09> 



%% Data Preparation
% Load images from folder:

% Global Size Settings
globalCellSize= [90 90]
globalImageSize = [480 640]

% Set File Path
filePath = fullfile('~/FYP/Data/Categorised');
imgSet = imageDatastore(filePath,'IncludeSubFolders',true','LabelSource','foldernames');

% Split data into trainin set and testing set in ration 4:1
[imgSetTrain, imgSetTest] = splitEachLabel(imgSet,0.8,'randomized');

% Show the count of labels in each set:
countEachLabel(imgSetTrain)
countEachLabel(imgSetTest)

% Set up size of feature vector
img = readimage(imgSetTrain, 470);
img = imresize(img, globalImageSize);

[hog_final, vis_final] = extractHOGFeatures(img,'CellSize',globalCellSize);
hogFeatureSize = length(hog_final);


%% Extract data using HOG algorithm
%
% Loop over the imgSetTrain to extrat HOG features from each immage, save those 
% features into training features array.
%
numImages = numel(imgSetTrain.Files);
trainingFeatures = zeros(numImages, hogFeatureSize, 'single');

for i = 1:numImages
    imag = readimage(imgSetTrain, i);
    imag = imresize(imag, globalImageSize);

    % Following pre-processing steps might be applied, however, accuracy with binarised 
    % pictures wasn't beneficial for given dataset:

    %imag = rgb2gray(imag);
    %imag = imbinarize(imag);
 
    % Extract HOG features and save them in array of cells:

    trainingFeatures(i, :) = extractHOGFeatures(imag, 'CellSize', globalCellSize);  
end

% Get labels for each image
trainingLabels = imgSetTrain.Labels;


%% Train classifier
classifier = fitcecoc(trainingFeatures, trainingLabels);


%% Test Model
% Test the trained model and retrieve a confusion matrix

[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(imgSetTest, hogFeatureSize, globalCellSize, globalImageSize);

% Make class predictions using the test features.
predictedLabels = predict(classifier, testFeatures);

% Display confusion matrix 
cm = confusionchart(testLabels, predictedLabels);
cm.RowSummary = 'row-normalized';
cm.ColumnSummary = 'column-normalized';
cm;


%% Extract data for testing set
function [features, setLabels] = helperExtractHOGFeaturesFromImageSet(imds, hogFeatureSize, cellSize, globalImageSize)

% Extract HOG features from an imageDatastore.
setLabels = imds.Labels;
numImages = numel(imds.Files);
features  = zeros(numImages, hogFeatureSize, 'single');

% Process each image and extract features
    for j = 1:numImages
        img = readimage(imds, j);
        img = imresize(img, globalImageSize);
        %img = rgb2gray(img);
        %img = imbinarize(img);
        features(j, :) = extractHOGFeatures(img,'CellSize',cellSize);
    end

end