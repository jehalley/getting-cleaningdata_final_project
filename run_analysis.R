#Load the necessary packages for the script#
  library(tidyr)
  library(dplyr)
  library(readr)
  library(data.table)

#download the Data Set and Unzip it #
  filename<-"UCIzipfile.zip"
  fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if(!file.exists(filename)){
     download.file(fileurl, filename)
  }
  unzip(zipfile = "UCIzipfile.zip")
  
#change the working directory to the unzipped file#
  setwd("UCI HAR Dataset")

#read features and make a variable containing a vector of each feature to be used as column names
  features<-read_fwf("features.txt",fwf_empty("features.txt"))
  features<-separate(features,X1,c(NA,"feature"), sep = " ")
  features<-features$feature

#Make "test" data frame
  setwd("test")

  #get activity labels for the test dataset
    activitylablestest<-read_fwf("Y_test.txt",fwf_empty("Y_test.txt", col_names = c("activity")))
    
    
  #get subject labels 
    subjectlabelstest<-read_fwf("subject_test.txt",fwf_empty("subject_test.txt", col_names = c("subject")))
    
  #read fixed width text file containing test results and make a dataframe where the features list is used as column names
    suppressWarnings(xtest<-read_fwf("X_test.txt",fwf_empty("X_test.txt", col_names = features)))

  #add the test-subject labels, and label each experiment as part of the "test" dataset to test-results data frame
    xtest<-cbind(subjectlabelstest, activitylablestest,dataset="test",xtest)

#Make "train" data frame 
  setwd("..")
  setwd("train")

  #get train-activity labels
    activitylablestrain<-read_fwf("Y_train.txt",fwf_empty("Y_train.txt", col_names = c("activity")))
    
  #get train-subject labels
    subjectlablestrain<-read_fwf("subject_train.txt",fwf_empty("subject_train.txt", col_names = c("subject")))
  
  #read fixed width text file containing train results and make a datframe where the features list is used as column names
    suppressWarnings(xtrain<-read_fwf("X_train.txt",fwf_empty("X_train.txt", col_names = features)))
  
  #add the test-subject labels, and label each experiment as part of the "train" dataset to test-results data frame
    xtrain<-cbind(subjectlablestrain,activitylablestrain,dataset="train",xtrain)

#Combine the train and test data frames
  combineddata<-data.table(rbind(xtest,xtrain))
  
#change activity codes to lowercase descriptive word
  combineddata$activity<-recode_factor(combineddata$activity, "1"= "WALKING","2"="WALKING_UPSTAIRS","3"="WALKING_DOWNSTAIRS","4"="SITTING","5"="STANDING","6"="LAYING")
  combineddata$activity<-tolower(combineddata$activity)
  
#subset the combined data to only show the means and std for each measurement
  combineddata2<-select(combineddata,activity,subject,dataset,matches('mean\\(\\)|std\\(\\)'),-matches('Freq'))
  
  
#convert the data from wide form to long form to make it tidy
  longdata<-gather(combineddata2,feature, observation, -c(1,2,3))

    
#summarize the data and make a data frame with the data in tidy long format with the average of each variable for each activity and subject
 summarytable<-longdata %>% group_by(subject,dataset,activity,feature) %>% summarise(mean_observation = mean(observation))
 
#replace feature names with descriptive words
 summarytable$feature<- sub('f','frequency-',summarytable$feature)
 summarytable$feature<- sub('t','time-',summarytable$feature)
 summarytable$feature<- gsub('Acc','-accelerometer-g-',summarytable$feature)
 summarytable$feature<- gsub('Gyro','-gyroscope-radians\\/second-',summarytable$feature)
 summarytable$feature<- gsub('Mag','_magnitude-',summarytable$feature)
 summarytable$feature<- gsub('--','-',summarytable$feature)
 summarytable$feature<- gsub('-_','-',summarytable$feature)
 summarytable$feature<- gsub('stime-d','std',summarytable$feature)
 summarytable$feature<- gsub('er-me','er-NA-me',summarytable$feature)
 summarytable$feature<- gsub('er-st','er-NA-st',summarytable$feature)
 summarytable$feature<- gsub('pe-me','pe-NA-me',summarytable$feature)
 summarytable$feature<- gsub('pe-s','pe-NA-me',summarytable$feature)
 summarytable$feature<- gsub('\\(\\)','',summarytable$feature)
 summarytable$feature<- gsub('std','standard_deviation',summarytable$feature)
 summarytable$feature<- gsub('metd','standard_deviation',summarytable$feature)
 summarytable$feature<- gsub('Jerk','jerk',summarytable$feature)
 summarytable$feature<- gsub('B','b',summarytable$feature)
 summarytable$feature<- gsub('G','g',summarytable$feature)
 
#tidy the features column by separating into multiple variables
 suppressWarnings(summarytable<-separate(summarytable, feature, c("domain","acceleration_signal_type","instrument","unit_of_measurement","measurement_type","statistic_type", "axis"), sep = "-"))

#move back to the UCI folder so that the tidy data table is stored in the main folder
setwd("..")
 
#save the table as a text file using write.table()
 write.table(summarytable,row.names = FALSE, file = "getting_cleaningdata_project.txt")

#to View this file please use the following code, you may need to adjust the file path accordingly
 UCI_HAR_Tidy_Data <- read.table("./getting_cleaningdata_project.txt", header = TRUE)
 View(UCI_HAR_Tidy_Data)
 
 
