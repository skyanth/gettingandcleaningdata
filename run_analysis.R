# This script assumes: 
# - you have downloaded the dataset (a zip file) for the Getting And Cleaning Data project 
# (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
# - you have unpacked the dataset to a directory called 'dataset' in your working directory
# - this R script also resides in your working directory
# So: WorkingDir
#     |_ dataset
#       |_ activity_labels.txt
#       |_ etc.
#     |_ run_analysis.R

# check if the necessary packages are installed; if not, install them
list.of.packages <- c('dplyr')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,'Package'])]
if(length(new.packages)) install.packages(new.packages)

# load necessary packages
library(dplyr)

######################################
# STEP 1. read all the necessary data
######################################
X_test <- read.table('UCI HAR Dataset/test/X_test.txt', quote='\"')
y_test <- read.table('UCI HAR Dataset/test/y_test.txt', quote='\"')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', quote='\"')
X_train <- read.table('UCI HAR Dataset/train/X_train.txt', quote='\"')
y_train <- read.table('UCI HAR Dataset/train/y_train.txt', quote='\"')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', quote='\"')
features <- read.table('UCI HAR Dataset/features.txt', quote='\"')
activities <- read.table('UCI HAR Dataset/activity_labels.txt', quote='\"')

################################################
# STEP 2. build a full table for the 'test' set
################################################
# First we merge X_test and y_test, adding y_test (the activities) as a first column
test.full <- cbind(y_test, X_test)
# Then we merge test.full and subject_test, adding subject_test (the subject numbers) as a column before the activities
test.full <- cbind(subject_test, test.full)

#################################################
# STEP 3. build a full table for the 'train' set
#################################################
# First we merge X_train and y_train, adding y_train (the activities) as a first column
train.full <- cbind(y_train, X_train)
# Then we merge train.full and subject_train, adding subject_train (the subject numbers) as a column before the activities
train.full <- cbind(subject_train, train.full)

#################################################################
# STEP 4. merge the full test and train sets in table 'all.data'
#################################################################
all.data <- rbind(train.full, test.full)

######################################################################################
# STEP 5. use the 'features' dataframe to extract column names for our all.data set
######################################################################################
# First, lose the number column (i.e. only keep the second col with the feature names)
features <- features[,2]
# Second, convert this 1-column dataframe of feature names to a vector
features <- as.vector(features)
# Third, create the table header
names(all.data) <- c('subject', 'activity', features)

#########################################################################
# STEP 6. use the activities dataframe to correctly label our activities 
# (which at this point are still just listed as 1:6)
#########################################################################
# First, lose the number column (i.e. only keep the second col with the activity names)
activities <- activities[,2]
# Second, convert this 1-column dataframe of activity names to a vector
activities <- as.vector(activities)
# Thirdly, prettify the labels a bit
activities <- tolower(activities)
activities <- sub('_', ' ', activities)
# Lastly use this 'activities' vector as a list of labels for the 'activity' column in all.data
all.data$activity <- factor(all.data$activity, labels=activities)
# While we're at it, factorize subject numbers too
all.data$subject <- factor(all.data$subject)

####################################################################
# STEP 7. cull all feature columns that are not mean or std related 
# (and pretty-print the labels)
####################################################################
# Make a vector with all of the column names that contain 'mean' or 'std'
# only grep on lowercase m and s as we don't want the Freq and Angle means
meanstdnames <- grep('mean\\(\\)|std\\(\\)', names(all.data), value=TRUE)
# Subset all.data to contain only 'subject', 'activity' and all the mean/std columns
selected.data <- all.data[,c('subject', 'activity', meanstdnames)]
# We will now modify the feature names to use descriptive variable names:
names(selected.data)<-gsub('^t', 'time', names(selected.data))
names(selected.data)<-gsub('^f', 'frequency', names(selected.data))
names(selected.data)<-gsub('Acc', 'Accelerometer', names(selected.data))
names(selected.data)<-gsub('Gyro', 'Gyroscope', names(selected.data))
names(selected.data)<-gsub('Mag', 'Magnitude', names(selected.data))
names(selected.data)<-gsub('BodyBody', 'Body', names(selected.data))
names(selected.data)<-gsub('-mean\\(\\)', 'Mean', names(selected.data))
names(selected.data)<-gsub('-std\\(\\)', 'STD', names(selected.data))

##########################################
# STEP 8 Create independent tidy data set
##########################################
# Store average of each variable for each activity and each subject in dataframe 'tidy.data' & write to file
tidy.data <- selected.data %>% group_by(activity, subject) %>% summarise_each(funs(mean))
write.table(tidy.data, file = 'tidy_data.txt', row.name=FALSE)