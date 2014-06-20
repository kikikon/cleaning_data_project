The dataset comprises data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the followinf website:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data were obtained from this address: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and subsequently merged and cleaned for further use.

Variables in the data:
* subject (factor): an id of the given subject who performed the activity, as in the original data
* activity (factor): a name of the given activity (one from)
* the remaining columns (numeric): the measured signal from the smartphone. Units and sepcification depend on the particular column, the columns starting with: 
** BodyAcc: The body acceleration signal obtained by subtracting the gravity from the total acceleration., 
** GravityAcc: standard gravity units 'g', 
** BodyGyro: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 


Data preparation steps:
* The available data were first merged into the training and testing set, that required matching the observed values with subject ids and with activity ids. Then, the training and testing sets were merged together.
* From available activity feature values, only the columns representing mean and standard deviation values were selected. The names of the features were added based on the overview of available features.
* For the sake of explicity, the acitivity codes were changed to their corresponding labels, based on the input text file matching the values and the labels.
* In the last step, for every combination of a subject and an activity, mean values of all activity features were calculated.