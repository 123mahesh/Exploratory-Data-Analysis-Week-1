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

############################################################
# plot2.png                                                #
# prepare dimension for plot                               #
# plot xy-graph for Global Active Power and timestamp      #
############################################################

# prepare x-dimension which is timestamp for two days in date range
subset.data <- transform(subset.data, timestamp=as.POSIXct(paste(Date, Time)))

# prepare y-dimension which is Global Active Power
subset.data$Global_active_power <- as.numeric(subset.data$Global_active_power)

# plot data
plot(subset.data$timestamp,subset.data$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")

# copy work to png device
dev.copy(png,file="plot2.png")
dev.off()