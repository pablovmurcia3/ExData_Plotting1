# Download
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./data/UCexdata_data_household_power_consumption.zip",
              method="curl")  
unzip(zipfile="./data/UCexdata_data_household_power_consumption.zip",
      exdir = "./data")

# Read the subset of data between the dates 2007-02-01 and 2007-02-02
library(data.table)
household <- fread("./data/household_power_consumption.txt",
                   skip = grep("1/2/2007",
                               readLines("./data/household_power_consumption.txt"))[1]-1,
                   nrows = 2880
)
# set the column names
header <- fread("./data/household_power_consumption.txt", nrows = 1, header = FALSE)
colnames(household) <- unlist(header)
remove(header)

# Create a variable that combines the current Date and Time variables
dt <- paste(household$Date, household$Time)
datetime <- strptime(dt, format="%d/%m/%Y %H:%M:%S")
household <- cbind(datetime, household)
class(household$datetime)

################################################################################
                                # Plot 3 #
################################################################################
dev_null <- Sys.setlocale("LC_TIME", "english")
png(filename="plot3.png", width=480, height=480,  type="cairo")
par(mar = c(3,4,2,2))
with(household, plot(datetime,Sub_metering_1, 
                     type = "l",
                     ylab = "Energy sub metering",
                     cex.lab = 0.8,
                     cex.axis =0.8))
with(household, lines(datetime, Sub_metering_2,
                      col ="red"))
with(household, lines(datetime, Sub_metering_3,
                      col ="blue"))
legend("topright", lty = 1, col = c("black","blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_2"),
       cex = 0.75)
dev.off()
