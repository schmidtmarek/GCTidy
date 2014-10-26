# run_analysis.R

# STEP 1:  MANUALLY download data file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# STEP 2:  MANUALLY unZIP downloaded file into ./data/ folder into your R default path (obtained by getwd() )

# load available column list
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Now using subsetting with help of regular expression matching to find ONLY mean+std MEASUREMENTS:
# finding columns ~ features containing "mean" and not starting with "f" as f are FFT applied signals (= NOT measured)
mean_cols <- features[grepl("^[^f]*mean\\(\\)",features$V2, TRUE),]
# finding columns ~ features containing "std and not starting with "f" as f are FFT applied signals (= NOT measured)
std_cols <- features[grepl("^[^f]*std\\(\\)",features$V2, TRUE),]

# finding columns ~ features that also Do NOT contain "Jerk" as Jerk were derived (= NOT measured)
mean_cols_wo_Jerk <- mean_cols[!grepl("*Jerk*",mean_cols$V2, TRUE),]
# finding columns ~ features that also Do NOT contain "Jerk" as Jerk were derived (= NOT measured)
std_cols_wo_Jerk <- std_cols[!grepl("*Jerk*",std_cols$V2, TRUE),]

# finding columns ~ features that also Do NOT contain "Mag" as Magnitudes were calculated (= NOT measured)
mean_cols_wo_Jerk_Mag <- mean_cols_wo_Jerk[!grepl("*Mag*",mean_cols_wo_Jerk$V2, TRUE),]
# finding columns ~ features that also Do NOT contain "Mag" as Magnitudes were calculated (= NOT measured)
std_cols_wo_Jerk_Mag <- std_cols_wo_Jerk[!grepl("*Mag*",std_cols_wo_Jerk$V2, TRUE),]

# concatenate column indexes for extraction
cols_to_extract <- c(mean_cols_wo_Jerk_Mag$V1, std_cols_wo_Jerk_Mag$V1)
# concatenate column names for extraction
cols_to_name <- c(as.character(mean_cols_wo_Jerk_Mag$V2), as.character(std_cols_wo_Jerk_Mag$V2))

# first step to prepare vector of NULL values, each NA means column is skipped during table read
cols_to_load <- as.vector(rep("NULL",nrow(features)), mode="character")
# then apply colClasses to column indexes that have to be picked up from source 
cols_to_load[cols_to_extract] <- "numeric"

# load test data set into R
test_set <- read.table("./data/UCI HAR Dataset/test/X_test.txt", colClasses=cols_to_load )

# obtain loaded column names (prefixed with "V" + extracted column index) and reorder columns in test_set
cols_loaded <- as.character(lapply(as.character(cols_to_extract), function(x) {paste("V", x, sep="")}))
test_set <- test_set[,cols_loaded]
# rename columns as defined in features list
names(test_set) <- cols_to_name

# load train data set into R + reorder columns
train_set <- read.table("./data/UCI HAR Dataset/train/X_train.txt", colClasses=cols_to_load )
train_set <- train_set[,cols_loaded]
# rename columns as defined in features list
names(train_set) <- cols_to_name

# load test subjects and train subjects
test_subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names=c("VolunteerID"))
train_subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names=c("VolunteerID"))

# load test activities and train activities
test_activity <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names=c("ActivityID"))
train_activity <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names=c("ActivityID"))

# load activity (descriptive) labels
activity_descr_mapping <- read.table("./data/UCI HAR Dataset/activity_labels.txt", colClasses=c("integer", "character"), col.names=c("ActivityID", "ActivityDescr"))

# label activities preserving order and utilize inline lookup function
test_activity$ActivityDescr <- as.character(lapply(test_activity$ActivityID, function(x) {activity_descr_mapping[x,2]} ))
train_activity$ActivityDescr <- as.character(lapply(train_activity$ActivityID, function(x) {activity_descr_mapping[x,2]} ))

# MERGE test: set+subject+activity_label into test_set
test_set <- cbind(test_set,test_subject) #column #19
test_set <- cbind(test_set,test_activity$ActivityDescr) #column #20
names(test_set)[20]="ActivityDescr"

# MERGE train: set+subject+activity_label into train_set
train_set <- cbind(train_set,train_subject)
train_set <- cbind(train_set,train_activity$ActivityDescr)
names(train_set)[20]="ActivityDescr"

# MERGE into one data set
FirstTidy <- rbind(test_set, train_set)

# Appropriately labels the data set with descriptive variable names
my_names <- c("BodyAccMean_X", "BodyAccMean_Y", "BodyAccMean_Z",
              "GravityAccMean_X", "GravityAccMean_Y", "GravityAccMean_Z",
              "BodyGyroMean_X", "BodyGyroMean_Y","BodyGyroMean_Z",
              "BodyAccStd_X", "BodyAccStd_Y", "BodyAccStd_Z",
              "GravityAccStd_X", "GravityAccStd_Y", "GravityAccStd_Z",
              "BodyGyroStd_X", "BodyGyroStd_Y","BodyGyroStd_Z",
              "VolunteerID", "ActivityDescr")

# Apply names to FirstTidy and Save to File
names(FirstTidy) <- my_names
write.table(FirstTidy, "./data/UCI HAR Dataset/FirstTidy.TXT", row.names = FALSE)

library(reshape2)
# Melt data set
FirstTidyMelt <- melt(FirstTidy, id=my_names[20:19], measure.vars=my_names[1:18])
# Group by ActivityDescr and VolunteerID and apply mean to variables
SecondTidy <- dcast(FirstTidyMelt, ActivityDescr+VolunteerID ~ variable, mean)

# Write final SecondTidy.TXT data set into file
write.table(SecondTidy, "./data/UCI HAR Dataset/SecondTidy.TXT", row.names = FALSE)
