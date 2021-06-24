%% |Real-Time Video Detection|
%
% This file demonstrates real-time vehicle detection using the
% 'carDetector_v11.xml' model. The frames are processed by
% vision.VideoPlayer(). 
%
% Created by Lukas Kopecky 
% 
% 28 April 2021 @ University of Westminster 
% 
% References: <https://uk.mathworks.com/help/vision/ref/vision.videoplayer-system-object.html>


%% Load data 

video1 = VideoReader('~/FYP/Data/Scenes_TFL/scenesTFL1.mp4');
processVideo(video1);


%% Ceate system Object Video Player
% Create Video Player:

function obj = setupSystemObjects()
    obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
end


%% Proces Video 
% Detect vehicles in each video frame
function processVideo(videoReader)
detector = vision.CascadeObjectDetector('carDetector_v11.xml');
obj = setupSystemObjects();
    while hasFrame(videoReader)
        frame = readFrame(videoReader);
        bbox = step(detector,frame);
        detectedInFrame = insertObjectAnnotation(frame,'rectangle',bbox,'car');
        obj.videoPlayer.step(detectedInFrame);
    end
 end