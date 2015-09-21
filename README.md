Getting and Cleaning Data Course Project
========================================

Project of [Getting and Cleaning Data course on Coursera](https://www.coursera.org/course/getdata), September 2015.

## Project Description
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers
on a series of yes/no questions related to the project.

You will be required to submit:

1. a tidy data set as described below
2. a link to a Github repository with your script for performing the analysis, and
3. a code book that describes the variables, the data, and any transformations or
   work that you performed to clean up the data called CodeBook.md. You should also
   include a README.md in the repo with your scripts. This file explains how all
   of the scripts work and how they are connected. 

One of the most exciting areas in all of data science right now is wearable computing.
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced
algorithms to attract new users. The data linked to from the course website represent
data collected from the accelerometers from the Samsung Galaxy S smartphone.
A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive activity names. 
* Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## What you find in this repository

* __CodeBook.md__: information about the raw and tidy data set
* __README.md__: this file
* __run_analysis.R__: R script to transform raw data set in a tidy one

## Guide to create the tidy data file
1. Download the data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Unzip the data on your local drive. You will have a UCI HAR Dataset folder.
3. Put run_analysis.R in the parent folder of UCI HAR Dataset
4. Set this parent folder as your working directory using the setwd() function in R.
5. Run the following command:
  source('run_analysis.R') 
  this will generate a new file tidy_data.txt in your working directory.

*Note:* the dplyr package is needed for execution of run_analysis.R. *The script will download and install these packages if they are not yet installed on your machine.*

## Breakdown of the code in run_analysis.R

### PREAMBLE

First we check if the necessary packages are installed; if not, we install them

    list.of.packages <- c('dplyr')
    new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,'Package'])]
    if(length(new.packages)) install.packages(new.packages)

Load necessary packages

    library(dplyr)


### STEP 1. read all the necessary data

    X_test <- read.table('UCI HAR Dataset/test/X_test.txt', quote='\"')
    y_test <- read.table('UCI HAR Dataset/test/y_test.txt', quote='\"')
    subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', quote='\"')
    X_train <- read.table('UCI HAR Dataset/train/X_train.txt', quote='\"')
    y_train <- read.table('UCI HAR Dataset/train/y_train.txt', quote='\"')
    subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', quote='\"')
    features <- read.table('UCI HAR Dataset/features.txt', quote='\"')
    activities <- read.table('UCI HAR Dataset/activity_labels.txt', quote='\"')


### STEP 2. build a full table for the 'test' set

First we merge X_test and y_test, adding y_test (the activities) as a first column

    test.full <- cbind(y_test, X_test)

Then we merge test.full and subject_test, adding subject_test (the subject numbers) as a column before the activities

    test.full <- cbind(subject_test, test.full)


### STEP 3. build a full table for the 'train' set

First we merge X_train and y_train, adding y_train (the activities) as a first column

    train.full <- cbind(y_train, X_train)

Then we merge train.full and subject_train, adding subject_train (the subject numbers) as a column before the activities

    train.full <- cbind(subject_train, train.full)


### STEP 4. merge the full test and train sets in table 'all.data'

    all.data <- rbind(train.full, test.full)


### STEP 5. use the 'features' dataframe to extract column names for our all.data set

First, lose the number column (i.e. only keep the second col with the feature names)

    features <- features[,2]

Second, convert this 1-column dataframe of feature names to a vector

    features <- as.vector(features)

Third, add names for the subject & activity columns (which we added in steps 2 and 3) & create the table header

    names(all.data) <- c('subject', 'activity', features)


### STEP 6. use the activities dataframe to correctly label our activities 
(which at this point are still just listed as 1:6)

First, lose the number column (i.e. only keep the second col with the activity names)

    activities <- activities[,2]

Second, convert this 1-column dataframe of activity names to a vector

    activities <- as.vector(activities)

Thirdly, prettify the labels a bit

    activities <- tolower(activities)
    activities <- sub('_', ' ', activities)


Lastly use this 'activities' vector as a list of labels for the 'activity' column in all.data

    all.data$activity <- factor(all.data$activity, labels=activities)

While we're at it, factorize subject numbers too

    all.data$subject <- factor(all.data$subject)


### STEP 7. cull all feature columns that are not mean or std related 
(and pretty-print the labels)

Make a vector with all of the column names that contain 'mean' or 'std'
only grep on lowercase m and s as we don't want the Freq and Angle means

    meanstdnames <- grep('mean\\(\\)|std\\(\\)', names(all.data), value=TRUE)

Subset all.data to contain only 'subject', 'activity' and all the mean/std columns

    selected.data <- all.data[,c('subject', 'activity', meanstdnames)]

We now modify the feature names to use descriptive variable names:

    names(selected.data)<-gsub('^t', 'time', names(selected.data))
    names(selected.data)<-gsub('^f', 'frequency', names(selected.data))
    names(selected.data)<-gsub('Acc', 'Accelerometer', names(selected.data))
    names(selected.data)<-gsub('Gyro', 'Gyroscope', names(selected.data))
    names(selected.data)<-gsub('Mag', 'Magnitude', names(selected.data))
    names(selected.data)<-gsub('BodyBody', 'Body', names(selected.data))
    names(selected.data)<-gsub('-mean\\(\\)', 'Mean', names(selected.data))
    names(selected.data)<-gsub('-std\\(\\)', 'STD', names(selected.data))


### STEP 8 Create independent tidy data set

Store average of each variable for each activity and each subject in dataframe 'tidy.data' & write to file

    tidy.data <- selected.data %>% group_by(activity, subject) %>% summarise_each(funs(mean))
    write.table(tidy.data, file = 'tidy_data.txt', row.name=FALSE)
