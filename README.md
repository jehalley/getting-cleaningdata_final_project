# getting-cleaningdata_final_project
Read Me for Getting& Cleaning Data Final Project

Thanks for grading my assignment!

To view a properly formatted version of my data table “getting&cleaningdata_project.txt” you can either run the run_analysis.R script or open it in R using the following code:

UCI_HAR_Tidy_Data <- read.table("./getting&cleaningdata_project.txt", header = TRUE)
View(UCI_HAR_Tidy_Data)


Review Criteria:

1. The submitted data is tidy: 

Hadley Wickham says tidy data has the following properties:

       A. Each variable forms a column. 
       B. Each observation forms a row. 
       C. Each type of observational unit forms a table.


A. In the data table I have provided each variable does have it’s own column. The variables in this dataset are the following and each has its own column
	* subject
	* dataset
	* activity
	* domain
	* acceleration_signal_type:
	* instrument
	* nit_of_measure
	* measurement_type
	* statistic_type
	* mean_observation

B. In the data table I have provided each observation does have it’s own row. Each row corresponds to a particular measurement type and statistic type performed by a particular subject doing a particular activity.

C. In the data table I have provided only one observation is shown per row and that is the mean of the stated statistic (last column). 


2. The Github repo contains the required scripts:

The repo linked below contains the 4 required components. run_Analysis.R, README.txt, the codebook and a txt file of the data table produced by the script.

3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.

The codebook provided in the repo was based on the codebook from the Week 1 quiz.  

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf


I list and describe each of the variables from the data table and for each variable I list the different variable names. 


4. The README that explains the analysis files is clear and understandable

Explanation of script:

A. The script loads the R packages used in the rest of the script.

B. The script downloads and unzips the UCI Har dataset.

C. The script moves to the appropriate working directory.

D. The features.txt file is used to make column names for the dataframe

E. I make two dataframes, one containing the test data and containing the train data. I will later combine these into a single large data frame called combineddata. 
   
   For both the train and test dataframes the script:
	1. moves to the appropriate directory
	2. makes a dataframe containing just activity labels by reading in the Y_test.txt or Y_train.txt data 	using read_fwf()
	3. Makes a dataframe containing just subject labels by reading in the subject_test.txt or 		subject_train.txt data using read_fwf()
	4. Makes a dataframe containing all of the processed measurements by reading X_test.txt or X_train.txt 	using read_fwf(). 
		Note: I did not read the inertial signals into this dataframe because they do not contain 		either means or standard deviations so they will be discarded when the final data table is 		produced. 
	5. Labels the measurement dataframe with the subject and activity labels dataframes to appropriately 	label the subject and activity corresponding to each measurement. 
	6. Make a “dataset” column where I label all data from each dataset as either “test” or “train”

F. The script combines the “test” and “train” dataframes into a single large data frame called combineddata using rbind() on the “train” and “test” dataframes. 

G. The script subsets combineddata to produce a second dataframe called combineddata2 that only contain the mean and standard deviations of the various measurements.  The data was subsetted using the select() function to select the activity labels, subject labels, and any columns containing the literals “mean()” or “std()”
	Note: the instructions only called for mean and standard deviation there were columns that had other 	types of means that were not included because they seemed to be different statistics than what the 	instructions were asking for. 

H. Combineddata2 has multiple observations in a single row, so to tidy this dataframe the script converts the data from wide data into short data using the gather() function to collapse the different measurement types into a column called “feature” and column called “observation” where the actual observation is recorded. The tidier data frame is called longdata 

I. The instructions request the final table to show the average value of the standard deviation and mean for each subject and each activity, to accomplish this the script groups the data by subject, dataset, activity and feature and then the summarize function is used to find the mean of each observation type. The summarized data is stored in a new dataframe called summarytable.

J. To fully tidy the summarytable I needed to convert the “feature” column into several different columns so that each column contained only 1 variable. 

	1. The authors named the features with a different number of variables so the names needed to be 	processed prior to using the separate() function. 

	2. The gsub() was used to make text substitutions that gave the different variables within the names 	descriptive names and also made them ready for separation using the location of “-“

	3. The gsub()function was also used to introduce the “unit_of_measurement” variable into the 		feature

	4. The separate function was used to split the feature column into 7 different variables: "domain", 	"acceleration_signal_type", "instrument", "unit_of_measurement", "measurement_type", "statistic_type", 	"axis"

K. The resulting table meets all of Hadley Wickham’s criteria for tidy data. 

L. The script uses write.table() to export the summarytable dataframe as a text file called “getting&cleaningdata_project.txt”

If you run the run_analysis.R script the table will open at the end of the script. 

Alternatively you can download the text file and use the following code to read a properly formatted version of the file in R (depending on where you save the .txt file you may need to modify the file path).

UCI_HAR_Tidy_Data <- read.table("./getting&cleaningdata_project.txt", header = TRUE)
View(UCI_HAR_Tidy_Data)



Thanks again!
