GCTidy
======

Getting and Cleaning Tidy Data Set


STEP 1:  MANUALLY download data file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
STEP 2:  MANUALLY unZIP downloaded file into ./data/ folder into your R default path (obtained by getwd() )

then source script file "run_analysis.R"

which run following steps to get Tidy data set:

load available column list

Now using subsetting with help of regular expression matching to find ONLY mean+std MEASUREMENTS:

finding columns ~ features containing "mean" and not starting with "f" as f are FFT applied signals (= NOT measured)

finding columns ~ features containing "std and not starting with "f" as f are FFT applied signals (= NOT measured)

finding columns ~ features that also Do NOT contain "Jerk" as Jerk were derived (= NOT measured)

finding columns ~ features that also Do NOT contain "Jerk" as Jerk were derived (= NOT measured)

finding columns ~ features that also Do NOT contain "Mag" as Magnitudes were calculated (= NOT measured)

finding columns ~ features that also Do NOT contain "Mag" as Magnitudes were calculated (= NOT measured)

concatenate column indexes for extraction

concatenate column names for extraction

first step to prepare vector of NULL values, each NA means column is skipped during table read

then apply colClasses to column indexes that have to be picked up from source 

load test data set into R

obtain loaded column names (prefixed with "V" + extracted column index) and reorder columns in test_set

rename columns as defined in features list

load train data set into R + reorder columns

rename columns as defined in features list

load test subjects and train subjects

load test activities and train activities

load activity (descriptive) labels

label activities preserving order and utilize inline lookup function

MERGE test: set+subject+activity_label into test_set

MERGE train: set+subject+activity_label into train_set

MERGE into one data set

Apply names to FirstTidy and Save to File

Melt data set

Group by ActivityDescr and VolunteerID and apply mean to variables

Write final SecondTidy.TXT data set into file
