## One of the things that this script depends on, is to first download the data set and extract it. 
## Then set that downloaded & extracted folder as your working directory.

d1 <- data.frame()
d2 <- data.frame() 
d3 <- data.frame()
d4 <- data.frame()
d5 <- data.frame()
d6 <- data.frame()
last <- data.frame()
data <- data.frame()
labels <- data.frame()
names <- data.frame()
names1 <- character()
subject <- data.frame()
activity <- data.frame()
postion <- integer()
tidy <- data.frame()
d1 <- read.table("./train/y_train.txt")
d2 <- read.table("./train/X_train.txt")
d3 <- read.table("./test/X_test.txt")
d4 <- read.table("./test/y_test.txt")
data <- rbind(d2,d3) ## rbind is the best function so that both data sets can be merged, given that each variable is the same in both sets.
labels <- rbind(d1,d4) ## the order of rbind must be the same in each execution, so that we are always looking at the same data in the same order.
names <- read.table("features.txt")
data <- setNames(data,names[,2]) ## Two columns are present in this data, we must only use the one with the names of the variables.
activity <- read.table("activity_labels.txt")
labels[] <- activity$V2[match(unlist(labels),activity$V1)] ## this function allows the user to see which activity is being performed, instead of having to learn what the number mean. 
labels <- setNames(labels, "Activity")
d5 <- read.table("./train/subject_train.txt")
d6 <- read.table("./test/subject_test.txt")
subject <- rbind(d5,d6)
subject <- setNames(subject,"Subject")
position <- grep("mean()|std()",names[,2]) ## we can find the position of each variable that is either a mean or a standard deviation.
data <- data[,position] ## now we filter the data frame in order to only see the variables that matter to us. 
names1 <- names(data) ## is easier to edit the variable names in a separate vector and then use setNames to go through with the changes.
names1 <- gsub("-"," ", names1)
names1 <- sub("std()","Standrard Deviation", names1)
names1 <- sub("mean()","Mean", names1)
names1 <- sub("^t","Time ", names1)
names1 <- sub("^f","Frequency domain ", names1)
names1 <- sub("Body","Body ", names1)
names1 <- sub("Acc","Accelerometer Signal ", names1)
names1 <- sub("()$","", names1)
names1 <- sub("X","X axis", names1)
names1 <- sub("Y","Y axis", names1)
names1 <- sub("Z","Z axis", names1)
names1 <- sub("Gyro","Gyroscope signal", names1)
names1 <- sub("Gravity","Gravity ", names1)
names1 <- sub("Mag","Magnitude ", names1)
names1 <- sub("Jerk","Jerk ", names1)
data <- setNames(data,names1)
tidy <- cbind(subject, labels, data) ## Now we merge all the data, and we have the tidy data set that is requested in the assingment
library(dplyr) ## we load the dplyr package in order to easily create a new variable with mutate.
last <- tidy %>% mutate(Subject & Activity = paste(Subject,Activity)) ## this variable is a concatenation of Activity and Subject, in order to have to only group by only variable.
last <- group_by(last,Subject & Activity) ## this will allow the creation of the requested data
last <- summarise_at(last,3:81,mean) ## only looking at the numeric variables, that have been previously selected. The only variables that are left out is the subject and activity variables, that have already been used.