GCTidy
======

Getting and Cleaning Tidy Data Set


STEP 1:  MANUALLY download data file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

STEP 2:  MANUALLY unZIP downloaded file into ./data/ folder into your R default path (obtained by getwd() )

then source script file "run_analysis.R"

which run following steps to get desired Tidy data set:

1) using regular expressions filter/prepare columne vector to import (only mean+std measurements, no derived/calculated columns)

2) load test & train data set into R

3) load subjects & activities 

4) merge all into FirstTidy data set

5) Apply names to FirstTidy and Save to File

6) Melt data set

7) Group by ActivityDescr and VolunteerID and apply mean to variables

8) Write final SecondTidy.TXT data set into file
