# Vehicle detection - Dissertation
This repository is outcome of my Final-year project and dissertation at the University of Westminster. This project was created in cooperation with Intelligent Transport Infrastructure (ITI) group at the university. My role in this research was to develop a machine learning based object detection model that was later compared to YOLO model that was developed by the by the ITI group. The outcome of this comparison is reflected in my dissertation and will be published in ITI conference paper. For more details, view my [dissertation in PDF form](https://drive.google.com/file/d/1w5eEIKuJ4ND1poV2Rl2LnFRG0ogTMcX6/view?usp=sharing).

Detect vehicles in images or in a sequence of video frames from either moving or statical camera source with my pre-trained model 'carDetector_v11.xml' implemented in the file 'Vehicle_detector.m'. This detector is able to detect vehicles from the rear view but is also able to detect the rear side of vehicles from views where the aspect ratio of detected objects is not affected by the angle of camera. 

My implementation of this detector proposed in the model ‘carDetector_v11.xml’ allows tracking of multiple vehicle types such as automobiles, lorries and emergency vehicles. This model, however, detects a high rate of false positive instances. Nevertheless, those false positive instances are then filtered out by a support vector machine classifier. The classifier ‘svm4.mat’ is capable to distinguish between all previously mentioned vehicle types, i.e. cars, lorries and emergency vehicles, as well as negative (false positive) instances. This solution allows for real-time  tracking of various vehicle types by using only a single detector.

The outcome of detection and classification is then carried by visualisation of rectangular labels over the video source and by saving detected data  in CSV files for each frame in the form of a 5-by-n matrix. The first 4 columns [x,y,w,h] represent the size and position of the bounding box where x and y specify the upper-left corner of the rectangle and w specifies the width of the rectangle, which is its length along the x-axis together with h which specifies the height of the rectangle, which is its length along the y-axis. The fifth column carries string value of the vehicle type. The name of CSV files corresponds to the name of each image or video frame. 

To create custom object detector, use the files 'Train_Cascade_Object_detector.m' and to train cascade classifier use the 'Train_Object_Classifier.m' file. Further analysis, such as F1 score, recall, precision and Jaccard index (IoU - Intersection over Union) can be calculated using the ‘data_analytics.m’ file.

#### Dataset used
Dataset| Size         | Resolution                          | Description 
--------------------------|--------------|-------------------------------------|------------
[Caltech Cars](http://www.vision.caltech.edu/html-files/archive.html)|126|896 x 592|Shot in 1999 at Caltech. It contains pictures of parked cars shot from the rear. Photos shot with natural daylight in a good weather conditions.
[English LP](http://www.zemris.fer.hr/projects/LicensePlates/english/)|509|Mixed|Produced in 2003 in Croatia. The dataset contains images of parked cars, lorries and bikes from both the front and rear. The light and weather conditions vary.
[Open ALPR EU](https://github.com/openalpr/benchmarks/tree/master/endtoend/eu)|108|Mixed|Produced in 2016 by Matthew Hill. Dataset contains pictures of European cars from the front and the rear. The light and weather conditions vary.
[AOLP](https://github.com/AvLab-CV/AOLP)|2,049|Mixed|Produced in 2013 in Taiwan. Contains images of vehicles shot from various angles and in varying lighting conditions.
[UFPR-ALPR](https://web.inf.ufpr.br/vri/databases/ufpr-alpr/license-agreement/)|4,500|1920 x 1080|Set of video frames taken by the University of Paraná, Brazil. Video frames include cars and motorbikes from the rear view. Weather conditions are good.
[TAU](https://www.kaggle.com/c/vehicle/data)|36,003|Mixed|Part of the Kaggle platform. Contains images of 17 vehicle categories. Images have been shot from various angles and at differing distances.
[GTI](https://www.gti.ssr.upm.es/data/Vehicle_database.html)|7,325|360 x 256 & 64 x 64|Produced in 2012 by the Universidad Politécnica de Madrid, Spain. Contains close and mid-range vehicle picture from the rear as well as negative samples.
[TSRD](http://www.nlpr.ia.ac.cn/pal/trafficdata/recognition.html)|6,164|Mixed|Contains images of Chinese traffic signs. Produced at the Beijing Jiaotong University.

## Detector performance
Dataset     |Recall    |Precision |F1 Score  |Mean IoU  |Standard Dev IoU
------------|----------|----------|----------|----------|-----------
Caltech Cars|0.96774|0.49383|0.65395|0.6991|0.21587
UFPR ALPR (validation subset)|0.98889|0.27980|0.46553|0.46553|0.34123
UFPR ALPR (custom selected)|1.0000|0.68966|0.81633|0.75343|0.085902
English LP|0.81139|0.62105|0.70358|0.33929|0.29064
Open ALPR EU|0.89815|0.60625|0.72388|0.46757|0.26353
Open ALPR EU (cutom selected)|1.0000|0.70968|0.83019|0.58274|0.15134

The table contains summary statistics for the performance of my model for each of the datasets used.

#### Jaccard index visualisation
![IoU graphical](https://github.com/kopeckylukas/vehicle-detection/blob/0ebb0f2131dd4833a73b7d4a48bae40b334e8ec1/Charts/Jaccard%20Indices.png)

Histograms to show the performance of the model measured using the Jaccard Index. Dashed line and shaded region is a measure of the confidence interval (mean ± standard deviation).

#### Comparision to ITI project results
![ITI comparision Graphical](https://github.com/kopeckylukas/vehicle-detection/blob/0ebb0f2131dd4833a73b7d4a48bae40b334e8ec1/Charts/comparision%20to%20YOLO.png)

The chart demonstrates comparison of ITI detection model (red) and FYP model (yellow) against the four main datasets. The ITI research group is using YOLO algorithm.

### Links and references
* You can find additinal files such as various detection and clasification models created during development and traing [here](https://drive.google.com/drive/folders/1G0q9osPLSATcsaeHxgwOLj1hruiJfp1V?usp=sharing).
* Check repository of the ITI project for more info about automatic number plate recognition [here](https://github.com/RedaAlb/alpr-pipeline).
* Reach me at [LinkedIn](https://www.linkedin.com/in/kopeckylukas/). 
