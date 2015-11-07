############################################################
# Library Setup                                            #
# Source Data Download                                     #
# Data Preparation                                         #
############################################################

#install the required packages for the code to run
toInstallCandidates <- c("utils","chron")

# check if pkgs are already present
toInstall <- toInstallCandidates[!toInstallCandidates%in%library()$results[,1]] 
if(length(toInstall)!=0)
{install.packages(toInstall, repos = "http://cran.r-project.org")}
# load pkgs
lapply(toInstallCandidates, library, character.only = TRUE)


# download zip file from the given URL
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
unzip(temp)
unlink(temp)


# read the source file
electc_pw_consmp <- read.table("household_power_consumption.txt",header= TRUE, sep = ";",
                               stringsAsFactors = F)

# change data taype first and second column to date and time
electc_pw_consmp$Date <- as.Date(electc_pw_consmp$Date,format="%d/%m/%Y")
electc_pw_consmp$Time <- times(electc_pw_consmp$Time)

# subset data
date_range <- as.Date(c("2007-02-01","2007-02-02")) # date range of which data is to be extracted
subset.data <- subset(electc_pw_consmp,electc_pw_consmp$Date >= date_range[1] & 
                        electc_pw_consmp$Date <= date_range[2])

##############################################################
# plot3.png                                                  #
# prepare dimension for plot                                 #
# plot xy-graph for Global Energy Sub Metering and timestamp #
##############################################################

# prepare x-dimension which is timestamp for two days in date range
subset.data <- transform(subset.data, timestamp=as.POSIXct(paste(Date, Time)))

# prepare y-dimension which is Energy Sub Metering
subset.data$Sub_metering_1 <- as.numeric(subset.data$Sub_metering_1)
subset.data$Sub_metering_2 <- as.numeric(subset.data$Sub_metering_2)
subset.data$Sub_metering_3 <- as.numeric(subset.data$Sub_metering_3)

# plot data
plot(subset.data$timestamp,subset.data$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering", col="black")
lines(subset.data$timestamp,subset.data$Sub_metering_2, type="l", col="red")
lines(subset.data$timestamp,subset.data$Sub_metering_3, type="l", col="blue")

#plot legend
legend("topright",col=c("black","red","blue"), c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1),lwd=c(1,1))

# copy work to png device
dev.copy(png,file="plot3.png", width=580, height=480)
dev.off()
