# Analysis of Summarisation of Test and Train Data from Smartphones

## The script run_analysis.R performs the required summarisation operation. Summarisation was carried out in the following steps:

### 0. NOTE: the script expects to be run from the folder containing the train and test data (in the folders names “train” and “test”). It first checks for the presence of these two folders. If they are not found, the script terminates immediately.

### 1. The activity table is first read and populated. This provides the mapping of Activity ID to Activity Name

### 2. The features table is then read to get a list of all the features/measurements that are performed. Features are replicated in each of the three dimensions: X, Y and Z in most cases. In some instances, the magnitude of the feature/measure is used (and this is independent of any axis).

### 3. We then create a list of features that measure mean() and std(). Only these features will be used for further processing and final summarisation.

### 4. The TEST data is read from the appropriate files. Column names are edited to match the content of the variable (e.g.: subject, activity ID and features)

### 5. A reduced feature set is created based on the list from step 3.

### 6. The MASTER TEST set is created from the subject, activity ID and features tables by joining them.

### 7. Steps 4-6 are repeated for the TRAIN data. The MASTER TRAIN data frame is created.

### 8. The MASTER TEST and MASTER TRAIN data frames are merged together to create the MASTER data frame.

### 9. In order to get Activity names from Activity ID, the MASTER data frame is merged with the Activity table. We then perform the required grouping (Activity, Subject) and then delete the redundant Activity ID variable.

### 10. Variable names are renamed for better clarity.

### 11. A summarised data frame is then created with the averages for each group of data (activity and subject)

### 12. The next few steps describe how the summarised data is converted to Tidy Data. We first gather the feature variables into a single column. We then separate the data in the column based on Feature, Aggregate Type (mean or std) and Axis. Finally, the Aggregate Types (mean and std) are spread into their own columns.

### 13. Some variable names are then cleaned up for clarity and some missing values are marked appropriately.

### 14. Finally the data frame is exported as a table to a file. This is a tidy data text file that adheres to the Hadley’s principles of Tidy Data.

## The exported file can be read using the command read.table(filename, header = TRUE)

## There is an accompanying Codebook that describes each of the variables in the tidy data file.