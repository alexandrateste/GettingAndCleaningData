# Assumption: the zip file is in the working directory
ffile <- unzip("./getdata-projectfiles-UCI HAR Dataset.zip")
# >>>> 1. Merge the training and the test sets to create one data set <<<<
# Extracting activity codes, TEST data, and participant data
test_activity_codes <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = ' ', header=FALSE)
test_original_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_people <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = ' ', header=FALSE)
test_combined_temp <- cbind(test_people, test_activity_codes)
test_combined <- cbind(test_combined_temp, test_original_data)
# Replace names of V1 and V1 for people and activity codes
colnames(test_combined)[1] <- "participant_id"
colnames(test_combined)[2] <- "activity_code"
        
# Extracting TRAIN data - in the same way
train_activity_codes <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = ' ', header=FALSE)
train_original_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_people <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = ' ', header=FALSE)
train_combined_temp <- cbind(train_people, train_activity_codes)
train_combined <- cbind(train_combined_temp, train_original_data)
colnames(train_combined)[1] <- "participant_id"
colnames(train_combined)[2] <- "activity_code"
        
# Combining test and training data
fully_comb <-rbind(test_combined, train_combined)


# - - - - - - - - - - - - - - - - - - -
# >>>> 2. Extract only the measurements on the mean and standard deviation for each measurement
# Extracting the names of the columns of the original test.txt and train.txt files
features <- read.table("./UCI HAR Dataset/features.txt", sep = ' ', header=FALSE)
featureslist<-as.character(features$V2)
# Identifying the column names which contain the string "mean()" or "std()"
list_of_means<- grep(glob2rx("*mean()*"), featureslist, value = TRUE)
list_of_std<- grep(glob2rx("*std()*"), featureslist, value = TRUE)

# Identifying the corresponding column indices in the features list
means_index <- which(featureslist %in% list_of_means)
std_index <- which(featureslist %in% list_of_std)

# Compiling a list of all these indices to take a subset of the full dataframe 'fully_comb'
selectedcolumns <- c(means_index, std_index)
selectedcolumns <- sort(selectedcolumns, decreasing = FALSE)
selectedcolumns_extended <- c(1,2,selectedcolumns+2)
# 'selectedcolumns_extended' contains 2 extra columns: participant_id and activity_code

# Extracting the subset of data related to mean and std measurements
subset_df <- fully_comb[, selectedcolumns_extended]

# - - - - - - - - - - - - - - - - - - -
# >>>> 3. Use descriptive activity names to name the activities in the data set <<<<
# Reading the activity names in the activity_labels.txt file
act_codes <- read.table("./UCI HAR Dataset/activity_labels.txt", sep = ' ', header=FALSE)
# Forcing the values in the activity_code column to be characters, so a replacement
# with actual activity names can be possible
subset_df$activity_code<-as.character(subset_df$activity_code)
rrange <- 1:dim(act_codes)[1]
codes <- as.character(act_codes$V2)

# Replacing the activity codes by the actual activity names
for (kk in rrange){
        subset_df$activity_code[subset_df$activity_code==as.character(kk)]<-codes[kk]
}

# - - - - - - - - - - - - - - - - - - -
# >>>> 4. Appropriately label the data set with descriptive variable names <<<<
full_list<-c('participant_id','activity_code',featureslist[selectedcolumns])
colnames(subset_df) <- full_list

# Replace default row numbers by numerical and increasing values starting at 1
rownames(subset_df) <- 1:nrow(subset_df)
# Sorting the results both by participant_id and by activity_code (increasing order)
subset_df<-subset_df[with(subset_df, order(participant_id, activity_code)), ]
# Writing to a txt file
write.table(subset_df, file ="UCI_HAR_Dataset_MeanStd_CleanedData.txt",row.names=FALSE, quote = FALSE)

# - - - - - - - - - - - - - - - - - - -
# >>>> 5. Create a second, independent tidy data set with the average of each variable
# for each activity and each subject <<<<
nber_var <- length(selectedcolumns_extended)
nber_act <- dim(act_codes)[1]
nber_people <- length(unique(subset_df$participant_id))
peoplerange <- 1:nber_people
# Splitting the subset_df dataframe by participant
person_subdf <- split(subset_df[2:nber_var],subset_df$participant_id)
sorted_codes <- sort(codes)
for (jj in peoplerange){
        # For each participant, computing the average of each column for each of the 6 activity types
        # Saving the results in a dataframe
        # Adding the participant_id and the activity_code columns to the dataframe
        # Putting them as the first 2 columns
        currlist<- by(person_subdf[[jj]][,c(3:nber_var-1)],person_subdf[[jj]]$activity_code, FUN=colMeans, na.rm = TRUE)
        mat <-matrix(unlist(currlist),nrow=(nber_var-2),ncol=nber_act)
        temp_df <- data.frame(mat)
        temp_df <- data.frame(t(temp_df)) # Transposing the dataframe
        part <- c(rep(jj,nber_act))
        temp_df$participant <- part
        temp_df$activity <- sorted_codes # currlist shows the activity codes in alphabetical order
        # Putting the participant and activity columns at the beginning
        temp_df <- temp_df[c(nber_var-1, nber_var, 1:(nber_var-2))]
        
        # Adding data to the master dataframe that will be saved in a txt file
        if (jj == 1){
                final_df <- temp_df
        } else{
                final_df <- rbind(final_df,temp_df)
        }
}
# Adding column names to the master dataframe
colnames(final_df) <- full_list
# Adding the prefix 'Add_' to all column names (except the participant and activity ones)
# to indicate what the values correspond to
colnames(final_df)[3:nber_var] <- paste("Avg", colnames(final_df)[3:nber_var], sep = "_")

# Replace default row numbers by numerical and increasing values starting at 1
rownames(final_df) <- 1:nrow(final_df) # For numerical and increasing row numbers
# Writing to a txt file
write.table(final_df, file ="UCI_HAR_Dataset_Averages_CleanedData.txt",row.names=FALSE, quote = FALSE)

