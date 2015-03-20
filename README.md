# README.md #

## Project objective ##
The code run_analysis.R aims at executing five specific operations (described below) on a data set collected from the accelerometers from the Samsung Galaxy S smartphone, and made available on the [UCI Machine Learning website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Data set description ##

The data set used in this project was compiled by Jorge L. Reyes-Ortiz's team in Italy and is called the "Human Activity Recognition Using Smartphones data set" (version 1.0) [1].

The experiments conducted to collect these data were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, Reyes-Ortiz's team captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments were video-recorded to label the data manually. The obtained data set was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of 561 features was obtained by calculating variables from the time and frequency domain. Features were normalized and bounded within [-1,1]. These 561 variables were used in the analysis described below, along with the 6 activity labels and an identifier of the subject who carried out the experiments.

These data were stored in the "X_test/train.txt", "y_test/train.txt", "features.txt", "subject_test/train.txt" and "activity_labels.txt" files. Note that the 3 groups of data sets body_acc_\*.txt, body_gyro_\*.txt and total_acc_\*.txt were not considered here, as the goals of this project were to extract only columns related to mean and standard deviation of measurements, and to calculate their respective averages.

*[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012*

## Work conducted ##
The code run_analysis.R:
 
 1. Merges the training and the test sets to create one data set
 2. Extracts only the measurements on the mean and standard deviation for each measurement
 3. Uses descriptive activity names to name the activities in the data set
 4. Appropriately labels the data set with descriptive variable names
 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The data set "UCI_HAR_dataset_Averages_CleanedData.txt" submitted for this project results from this. The section below describes in more detail each of the steps that led to the creation of this file.

#### 1. Merge of training and test data ####

 1. Assuming that the zip file 'getdata-projectfiles-UCI HAR Dataset.zip' is in the working directory, unzip it
 2. Extract the activity codes (subject_test.txt), TEST data (X_test.txt), and participant data (y_test.txt)
 3. Store them all into a single dataframe (test_combined), with participants as the first column, activity codes as the second one, and the measurements as the rest of the columns
 4. As these 3 sets of data end up with the same first variable (V1), replace that name with 'participant_id' and 'activity_code' for the first 2 columns
 5. Do the same with the training data (subject_train.txt, X_train.txt, y_train.txt), and store them into the train_combined dataframe
 6. Combine the 2 dataframes into a single one: fully_comb (for fully_combined), with the rbind function

#### 2. Extraction of only mean and standard deviation variables for each measurement ####

 1. Extract the names of the columns of the original test.txt and train.txt files from the features.txt file, and store them into the 'features' dataframe
 2. Force the elements of the second column of the 'features' dataframe to be read as characters
 3. Identify the names which contain the string "mean()" or "std()"
 4. Identify the corresponding indices in the features list
 5. Compile a list of all these indices to take a subset of the full dataframe 'fully_comb'
 6. Add the 2 extra indices for the columns 'participant_id' and 'activity_code'
 7. Extract the subset of data related to mean and std measurements, and to participants and activities, and store them into the dataframe 'subset_df'

#### 3. Use of descriptive activity names to name the activities in the data set ####

 1. Read the activity names from the activity_labels.txt file and store them into the 'act_codes' dataframe
 2. Force the values in the 'activity_code' column of the 'subset_df' dataframe to be characters (and no longer integers) so a replacement by their actual names can be possible
 3. Replace the activity codes by the actual activity names (e.g. Laying, Standing, etc.)
 
#### 4. Appropriately label the data set with descriptive variable names ###

 1. Create a list containing only the 'mean' and 'std' column names as well as 'participant_id' and 'activity_code'
 2. Replace the current names of the 'subset_df' columns by those included in the list mentioned above
 3. Replace default row numbers by numerical and increasing values starting at 1 (not needed for this project, but cleaner)
 4. Sort the results both by 'participant_id' and by 'activity_code' (increasing order)
 5. Write to a .txt file without the row number column nor quotes

#### 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject ####

 1. Split the 'subset_df' dataframe by participant
 2. For each participant:
        
  a. Compute the average of each column for each of the 6 activity types
  b. Save the results in a matrix, then in a dataframe and transpose it to have the variables in columns and not rows
  c. Add the 'participant_id' and the 'activity_code' columns to the dataframe
  d. Move them so they become the first two columns
  e. Add data to the master dataframe 'final_df' that will be saved in a .txt file
 3. Add column names to the master dataframe
 4. Add the prefix 'Add_' to all column names (except the participant and activity ones) to indicate what the values correspond to
 5. Replace default row numbers by numerical and increasing values starting at 1 (not needed for this project, but cleaner)
 6. Write to a .txt file without the row number column nor quotes
