#### title: "Course Project Codebook"
#### author: "Patricia Piolon"
#### date: "21-09-2015"


## Project Description
The project involved merging two datasets (train and test), obtained from the accelerometer and gyroscope 3-axial sensors in a Samsung smartphone, to produce one tidy, properly labeled dataset containing *average* and *standard deviation* data. The goal was to prepare this data for subsequent analysis (in this case, analysis consisted of an overview of the averages for each feature, shown per activity and per subject).

##Study design and data processing

###Collection of the raw data
The data for this project was downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip. It was downloaded on September 21, 2015, at 10:59am, GMT.

The following information on the original data comes directly from the README.txt of HAR Smartphones Dataset data from Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

##Cleaning the data
To clean the data prior to the final analysis, the script: 
- merges the train and test datasets, 
- uses the included activity_labels.txt file to label the activities,
- uses the features.txt file to properly name the columns, and
- culls all columns that are not Mean- or Std-related. 

As per the paper on Tidy data by Hadley Wickham of RStudio, the output data is tidy data because the three most important features of Tidy Data are present:

- Each variable forms a column.
- Each observation forms a row.
- Each type of observational unit forms a table.

For more details, see [the readme file](README.md)

## Description of tidy_data.txt

The table is presented in a *wide* form. Dimensions are 180 observations of 68 variables (subject, activity and 66 mean- or standard deviation-related features). meanFreq() as well as angle-related features are not included.

Of course you can easily reshape the table to a *narrow* form (4 variables, with id variables 'subject' and 'activity') using e.g. the reshape2 library. Both forms are equally tidy in the context of this project.

## Description of the variables in tidy_data.txt

###subject
Identifies the subject who performed the activity for each window sample.
Factor var with 30 levels: 1 to 30.

###activity
Activity name.
Factor var with 6 levels: 'walking', 'walking upstairs', 'walking downstairs', 'sitting', 'standing', 'laying'.

###66 feature variables
Average values for the Mean- and Standard-deviation-related features listed below:

1. "timeBodyAccelerometerMean-X"
2. "timeBodyAccelerometerMean-Y"
3. "timeBodyAccelerometerMean-Z"
4. "timeBodyAccelerometerSTD-X"
5. "timeBodyAccelerometerSTD-Y"
6. "timeBodyAccelerometerSTD-Z"
7. "timeGravityAccelerometerMean-X"
8. "timeGravityAccelerometerMean-Y"
9. "timeGravityAccelerometerMean-Z"
10. "timeGravityAccelerometerSTD-X"
11. "timeGravityAccelerometerSTD-Y"
12. "timeGravityAccelerometerSTD-Z"
13. "timeBodyAccelerometerJerkMean-X"
14. "timeBodyAccelerometerJerkMean-Y"
15. "timeBodyAccelerometerJerkMean-Z"
16. "timeBodyAccelerometerJerkSTD-X"
17. "timeBodyAccelerometerJerkSTD-Y"
18. "timeBodyAccelerometerJerkSTD-Z"
19. "timeBodyGyroscopeMean-X"
20. "timeBodyGyroscopeMean-Y"
21. "timeBodyGyroscopeMean-Z"
22. "timeBodyGyroscopeSTD-X"
23. "timeBodyGyroscopeSTD-Y"
24. "timeBodyGyroscopeSTD-Z"
25. "timeBodyGyroscopeJerkMean-X"
26. "timeBodyGyroscopeJerkMean-Y"
27. "timeBodyGyroscopeJerkMean-Z"
28. "timeBodyGyroscopeJerkSTD-X"
29. "timeBodyGyroscopeJerkSTD-Y"
30. "timeBodyGyroscopeJerkSTD-Z"
31. "timeBodyAccelerometerMagnitudeMean"
32. "timeBodyAccelerometerMagnitudeSTD"
33. "timeGravityAccelerometerMagnitudeMean"
34. "timeGravityAccelerometerMagnitudeSTD"
35. "timeBodyAccelerometerJerkMagnitudeMean"
36. "timeBodyAccelerometerJerkMagnitudeSTD"
37. "timeBodyGyroscopeMagnitudeMean"
38. "timeBodyGyroscopeMagnitudeSTD"
39. "timeBodyGyroscopeJerkMagnitudeMean"
40. "timeBodyGyroscopeJerkMagnitudeSTD"
41. "frequencyBodyAccelerometerMean-X"
42. "frequencyBodyAccelerometerMean-Y"
43. "frequencyBodyAccelerometerMean-Z"
44. "frequencyBodyAccelerometerSTD-X"
45. "frequencyBodyAccelerometerSTD-Y"
46. "frequencyBodyAccelerometerSTD-Z"
47. "frequencyBodyAccelerometerJerkMean-X"
48. "frequencyBodyAccelerometerJerkMean-Y"
49. "frequencyBodyAccelerometerJerkMean-Z"
50. "frequencyBodyAccelerometerJerkSTD-X"
51. "frequencyBodyAccelerometerJerkSTD-Y"
52. "frequencyBodyAccelerometerJerkSTD-Z"
53. "frequencyBodyGyroscopeMean-X"
54. "frequencyBodyGyroscopeMean-Y"
55. "frequencyBodyGyroscopeMean-Z"
56. "frequencyBodyGyroscopeSTD-X"
57. "frequencyBodyGyroscopeSTD-Y"
58. "frequencyBodyGyroscopeSTD-Z"
59. "frequencyBodyAccelerometerMagnitudeMean"
60. "frequencyBodyAccelerometerMagnitudeSTD"
61. "frequencyBodyAccelerometerJerkMagnitudeMean"
62. "frequencyBodyAccelerometerJerkMagnitudeSTD"
63. "frequencyBodyGyroscopeMagnitudeMean"
64. "frequencyBodyGyroscopeMagnitudeSTD"
65. "frequencyBodyGyroscopeJerkMagnitudeMean"
66. "frequencyBodyGyroscopeJerkMagnitudeSTD"
