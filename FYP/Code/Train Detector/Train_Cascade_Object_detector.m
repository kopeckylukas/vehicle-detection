%% |Train Cascade Detector|
%
% Train a custom cascade object detector based on the Viola-Jones algorithm 
% using MATLAB’s function vision. trainCascadeObjectDetector(). This solution 
% was part of my vehicle detection system. 
% 
% The Viola-Jones algorithm consists of a cascade of weak learners that allows 
% objects to pass to the next stage of the cascade according to a specified false 
% alarm rate. Precision and processing time are the buyout between the number 
% of stages and false alarm rate ratio. Moreover, the algorithm is sensitive to 
% aspect ratio hence multiple detectors are needed for detection of an object 
% from various angles or for different objects. To overcome this issue, I combined 
% cascade detector with a classifier that is able of filtering false positive 
% instances. Implementation of this model is done in the Vehiecle_detector.m file. 
% 
% Training of the detector requires two kinds of instances. Positive instances 
% labelled by MATLAB's Image Labeler or instances imported from external file 
% in form of a 2-by-n matrix where the first column points at the training files, 
% second column represents ROI (regions of interest) labels and n the number of 
% training samples. The second kind are negative samples which represent images 
% of desired scenes that do not contain objects of interest. Particularly, negative 
% instances for vehicle detection might be pictures of cartridge way, streetlamps, 
% traffic signs, bridges and surrounding area. It is recommended to use hundreds 
% to thousands of training samples. 
% 
% Created by Lukas Kopecky 
% 
% 28 April 2021 @ University of Westminster 
% 
% References: <https://www.mathworks.com/help/vision/ug/train-a-cascade-object-detector.html>


%% Load Files

% Load Positive Imaes
load('vehicleLabels_v4.mat');
% Load Negative Immages
negativeImages = fullfile('~/FYP/Data/Negative');

%% Train Cascade Detector
trainCascadeObjectDetector('carDetector_v13.xml',vehicleLabels, negativeImages, 'NumCascadeStages',8,"FalseAlarmRate",0.1);

%% Test Detector
detector = vision.CascadeObjectDetector('carDetector_v13.xml');

scenePath = fullfile ('~/FYP/Data/TrainingFolder/');

scenes = imageDatastore(scenePath);

numberOfImages = numel(scenes.Files);

for t = 1:numberOfImages
    
    img = readimage(scenes, t);

    bbox = step(detector,img);

    detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'car');

    figure; imshow(detectedImg);
end

%% Note: 
% Testing of the detector in this file is done only by visualisation. To calculate 
% accuracy and and precission it is necessary to deploy the model the Vehiecle_detector.m 
% file and analysed trough data_analytics.m.