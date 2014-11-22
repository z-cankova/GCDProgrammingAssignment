#R Script for Human Activity Recognition Using Smartphones Tidy Data Summary

The "run_analysis.R" script provided in this repository takes in data from the Human Activity Recognition Using Smartphones Dataset and returns a tidy data summary of the mean values for the mean and standard deviation features grouped by subject and activity. Refer to the provided code book for further explanation about the experimental setup and the data contained in the original and tidy data sets. 

The "run_analysis.R" script requires the "dplyr" and "reshape2" packages. It creates the tidy data set through the following steps:

1. Downloads and unzips the original data using the download.data() and unzip() functions.

2. Obtains the feature names from "features.txt" file using read.table(), and coerces them to syntactically valid unique names (without ()) using make.names(). These will be used to assign descritive variable names to the data from the X_test and X_train files. 

3. Reads activity names from "activity_labels.txt" file using read.table(). These will be used to assign descriptive names to the activities listed in the y_test and y_train files.

4. Reads movement data for the test group from the following files using read.table():
      * subject_test.txt
      * X_test.txt
      * y_test.txt
      
      It assigns the data to the following variables, with the specified parameters:
      * subject_test: a 2947x1 data frame with a factor variable with column name "Subject"
      * X_test: a 2947x561 data frame with integer variables with the descriptive column names extracted in step 2
      * y_test: a 2947x1 data frame with an integer variable with column name "Activity"    

5. Reads movement data for the train group using the corresponding train files and assigns them to train variables using the exact methods used for the test data.

6. Combines the test and train data into one data file. First the test data is merged using cbind() to produce a 2947x563 data frame. Then the train data is combined in the same way. Finally the two new test and train data sets are merged using rbind() to produce a 10299x563 complete data set.

7. Replaces the integer notation of the "Activity" column (using factor()) with the descriptive names extracted in step 3.

8. Selects only features containing the mean and standard deviation using select() (dplyr library) and reorders the resulting data set to narrow format using melt() (reshape2 library).

9. Produces a tidy narrow-format dataset with the average of each variable for each activity and each subject. First, the data are grouped by subject and activity using group_by() (dplyr library). Then, the mean values are calculated for each feature by subject and activity using summarize_each() (dplyr library). Finally the resulting tidy narrow-format data set is written to a "tidy_data_summary.txt" file using write.table().

After sourcing the "run_analysis.R" script in the working directory, the tidy data set can be loaded into R using the following command:

tidy_data <- read.table("./UCI HAR Dataset/tidy_data_summary.txt", header = TRUE)