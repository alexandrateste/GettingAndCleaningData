# CodeBook for the analysis of the Samsung Galaxy S smartphone data #

The variables described below are created within the run_analysis.R code.

### Section 1 - Merging of the training and test data sets ###
Variable name | 1st appearance in code | Description | Type | Values
------------ | ------------- | ------------ | ------------- | -----------------
ffile | 2 | Names of the files originally compressed in the zip file | List -- chr 28 names | ["./UCI HAR Dataset/activity_labels.txt", "./UCI HAR Dataset/features.txt", etc.]
test_activity_codes | 5 | Activity codes corresponding to LAYING, STANDING, etc. | Dataframe -- num 2947 obs, 1 var | 1 = WALKING <br> 2 = WALKING_UPSTAIRS <br> 3 = WALKING_DOWNSTAIRS <br> 4 = SITTING <br> 5 = STANDING <br> 6 = LAYING
test_original_data | 6 | Data stored in the original "X_test.txt" file - Observations of the 561 features listed in "features.txt" | Dataframe -- num 2947 obs, 561 var | float
test_people | 7 | Participant ID | Dataframe -- num 2947 obs, 1 var | 1,2,3,...,30
test_combined_temp | 8 | Participant ID and activity codes | Dataframe -- num 2947 obs, 2 var | 1,2,3,...,30 & <br> 1 = WALKING <br> 2 = WALKING_UPSTAIRS <br> 3 = WALKING_DOWNSTAIRS <br> 4 = SITTING <br> 5 = STANDING <br> 6 = LAYING
test_combined | 9 | Participant ID, activity codes and 561 variables | Dataframe -- chr & num 2947 obs, 563 var | Combination of values described above
train_activity_codes | 15 | Same as 'test_activity_codes' but for training set "X_train.txt" | Dataframe -- num 7352 obs, 1 var |  1 = WALKING <br> 2 = WALKING_UPSTAIRS <br> 3 = WALKING_DOWNSTAIRS <br> 4 = SITTING <br> 5 = STANDING <br> 6 = LAYING
train_original_data | 16 | Same as 'test_original_data' but for training set | Dataframe -- num 7352 obs, 561 var | float
train_people | 17 | Same as 'test_people' but for training set | Dataframe -- num 2947 obs, 1 var | 1,2,3,...,30
train_combined_temp | 18 | Same as 'test_combined_temp' but for training set | Dataframe -- num 7352 obs, 2 var | 1,2,3,...,30 & <br> 1 = WALKING <br> 2 = WALKING_UPSTAIRS <br> 3 = WALKING_DOWNSTAIRS <br> 4 = SITTING <br> 5 = STANDING <br> 6 = LAYING
train_combined | 19 | Same as 'test_combined_temp' but for training set | Dataframe -- chr & num 2947 obs, 563 var | Combination of values described above
fully_comb | 24 | Ensemble of test and training data | Dataframe -- chr & num 10299 obs, 563 var | Combination of values described above

### Section 2 - Extraction of mean and standard deviation variables for each measurement ###
Variable name | 1st appearance in code | Description | Type | Values
------------ | ------------- | ------------ | ------------- | -----------------
features | 30 | 561 features contained in the "X_test/train.txt" files | Dataframe -- num & chr 561 obs, 2 var | 1,2,3,...,561 (row #) & ["tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", etc.]
featureslist | 31 | Names of these 561 features | List -- chr 561 names | ["tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", etc.]
list_of_means | 33 | Names of the 33 features that contain the sub-string 'mean()' | List -- chr 33 names | ["tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", etc.]
list_of_std | 34 | Names of the 33 features that contain the sub-string 'std()' | List -- chr 33 names | ["tBodyAcc-std()-X", "tBodyAcc-std()-Y", etc.]
means_index | 37 | Indices of the 33 features that contain the sub-string 'mean()' | List -- num 33 integers | 1,2,3,41,42,43,81,82,83,etc.
std_index | 38 | Indices of the 33 features that contain the sub-string 'std()' | List -- num 33 integers | 4,5,6,44,45,46,84,85,86,etc.
selectedcolumns | 41 | Combination of means_index and std_index | List -- num 66 integers | 1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,etc.
selectedcolumns_extended | 43 | Same as 'selectedcolumns' shifted by 2 positions and to which the indices 1 and 2 were added to account for the 'participant_id' and 'activity_code' columns | List -- num 68 integers | 1,2,3,4,5,6,7,8,43,44,45,46,47,48,83,84,85,86,87,88,etc.
subset_df | 47 | Subset of the 'fully_comb' dataframe with only the columns corresponding to the indices in 'selectedcolumns_extended' | Dataframe -- chr & num 10299 obs, 68 var | Combination of values described above

### Section 3 - Replacement of activity codes by activity names ###
Variable name | 1st appearance in code | Description | Type | Values
------------ | ------------- | ------------ | ------------- | -----------------
act_codes | 52 | Activity codes and names | Dataframe -- chr & num 6 obs, 2 var | 1,2,3,4,5,6 & ["WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"]
rrange | 56 | Integer sequence from 1 to number of rows of the 'act_codes' dataframe | Vector -- num 6 integers | 1,2,3,4,5,6
codes | 57 | List of activity names read as character values | List -- chr 6 names | ["WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"]

### Section 4 - Labeling of data set with descriptive variable names ###
Variable name | 1st appearance in code | Description | Type | Values
------------ | ------------- | ------------ | ------------- | -----------------
full_list | 66 | Names of columns of the 'subset_df' dataframe | List -- chr 68 names | ["participant_id", "activity_code", "tBodyAcc-mean()-X", etc.]

### Section 5 - Creation of final tidy data set ###
Variable name | 1st appearance in code | Description | Type | Values
------------ | ------------- | ------------ | ------------- | -----------------
nber_var | 79 | Number of columns in the 'subset_df' dataframe | Integer | 68
nber_act | 80 | Number of activities | Integer | 6
nber_people | 81 | Number of participants | Integer | 30
peoplerange | 82 | Sequence from 1 to 30 | Vector -- num 30 integers | 1,2,3,..., 30
person_subdf | 84 | 'subset_df' split by participant | List of 30 dataframes -- chr & num varying # of obs, 67 var | Similar values as in 'subset_df' without participant ID
sorted_codes | 85 | List of activity names sorted alphabetically | List -- chr 6 names | ["LAYING", "SITTING", "STANDING", "WALKING", "WALKING_DOWNSTAIRS", "WALKING_UPSTAIRS"]
currlist | 91 | For a given participant and each activity type, average of each of the 66 variables | List of 6 lists (one for each activity) -- chr 66 names and num 66 values| ["tBodyAcc-mean()-X", "tBodyAcc-mean()-Y", etc.] & float
mat | 92 | Matrix version of the above list of list | Matrix -- 66 rows, 6 columns | float
temp_df | 93 | Dataframe version of the above matrix | Dataframe -- ultimately chr & num 6 obs, 68 var | float
part | 95 | Appropriate repetition of participant_id to integrate in the final version of the 'temp_df' dataframe | Vector -- num 6 int | 6 times the appropriate participant ID
final_df | 103 | Final dataframe containing the average data for all participants and all activity codes | Dataframe -- chr & num 180 obs, 68 var | Combination of values described above