#Load necessary libraries:
library(dplyr)
library(reshape2)

#Download and unzip activity data:
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./UCI_HAR_Dataset.zip", method = "curl")
unzip("./UCI_HAR_Dataset.zip")

#Read variable names from "features.txt" file and coerce them to syntactically valid names (without ()):
X_names <- read.table("./UCI HAR Dataset/features.txt")
valid_X_names <- make.names(X_names[ , 2], unique = TRUE)

#Read activity names from "activity_labels.txt" file:
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Read activity data for test group:
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                           colClasses = "factor",
                           col.names = "Subject")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt",
                     col.names = valid_X_names)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",
                     col.names = "Activity")

#Read activity data for train group:
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                            colClasses = "factor",
                            col.names = "Subject")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt",
                      col.names = valid_X_names)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",
                      col.names = "Activity")

#Merge test and train datasets:
test <- cbind(subject_test, y_test, X_test)
train <- cbind(subject_train, y_train, X_train)
movement_data <- rbind(train, test)

#Label activities with descriptive names:
movement_data$Activity <- factor(movement_data$Activity,
                                 labels = activity_labels[ , 2])

#Select only variables containing the mean and standard deviation:
mean_std_movement_data <- select(movement_data, 
                                 Subject, 
                                 Activity, 
                                 contains("mean"), 
                                 contains("std"))
narrow_movement_data <- melt(mean_std_movement_data,
                             id = c("Subject", "Activity"),
                             variable.name = "Feature",
                             value.name = "Mean Value")

#Make a tidy dataset with the average of each variable for each activity and each subject:
grouped_movement_data <- group_by(narrow_movement_data, Subject, Activity, Feature)
movement_summary <- summarise_each(grouped_movement_data, funs(mean))
write.table(movement_summary,
            file = ("./UCI HAR Dataset/tidy_data_summary.txt"),
            row.names = FALSE)
