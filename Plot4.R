# Coursera - Exploratory Data Analysis - Plot4.R
# Course Project 1: goal here is simply to examine household energy usage
# reconstruct the 4 plots: 
#  (1) histogram Global_active_power
#  (2) plot Global_active_power for 2007-02-01 and 2007-02-02
#  (3) plot Sub_metering_1 to Sub_metering_3 for 2007-02-01 and 2007-02-02
#  (4) lattice plots
#
getwd()
setwd('/home/dybalskig/R_Exploratory_Data_Analysis/Course_Project_1')
getwd()

library(ggplot2)
library( dplyr )
data_file <- 'household_power_consumption.txt'
# Description of Fields in Data File 
# 1. Date: Date in format dd/mm/yyyy
# 2. Time: time in format hh:mm:ss
# 3. Global_active_power: household global minute-averaged active power (in kilowatt)
# 4. Global_reactive_power: household global minute-averaged reactive power 
#   (in kilowatt)
# 5. Voltage: minute-averaged voltage (in volt)
# 6. Global_intensity: household global minute-averaged current intensity (in ampere)
# 7. Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). 
#   It corresponds to the kitchen, containing mainly a dishwasher, an oven and a 
#   microwave (hot plates are not electric but gas powered).
# 8. Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). 
#   It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
# 9. Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). 
#   It corresponds to an electric water-heater and an air-conditioner.


dat <- read.csv( data_file, header=TRUE, sep=';', as.is = TRUE, na.strings='?' )
# contents of the data frame
str(dat)

# convert the date stored as text or character field to date type
dat <- within(dat, Datevar <- as.Date(paste(Date), format = "%d/%m/%Y"))
head( dat)
str(dat)
nrow( dat)

# We will only be using data from the dates 2007-02-01 and 2007-02-02. 
# One alternative is to read the data from just those dates rather than 
# reading in the entire dataset and subsetting to those dates.

begdate <- as.Date( "2007-02-01", format = "%Y-%m-%d")
str(begdate)
enddate <- as.Date( "2007-02-02", format = "%Y-%m-%d")
str(enddate)

# Just the 2 days of data
reduced_dat <- filter( dat, Datevar ==begdate | Datevar ==enddate )

# create a date and time variable for the plots
reduced_dat$Date_time <-strptime( paste( reduced_dat$Date, reduced_dat$Time ) , "%d/%m/%Y %H:%M:%S")
head( reduced_dat )
str( reduced_dat )

# data check
with( reduced_dat, table(  Date))

picwidth=480
picheight=480

#  4th Figure (4 plots in 1)
png(file="plot4.png", width=picwidth, height=picheight) # set pixel width and height
par( mfrow = c(2 , 2))
# upper left plot
plot( reduced_dat$Date_time , reduced_dat$Global_active_power,  type = "l", main='',
      xlab='Date/Time', ylab = 'Global Active Power (kilowatt)' )
# upper right
with ( reduced_dat, plot( Date_time , Voltage ,  type = "l", main='',
      xlab='Date/Time', ylab = 'Voltage' ) )

# lower left
with( reduced_dat, plot( Date_time, Sub_metering_1 , type = "l", main='', col='black', 
                         xlab='Date/Time', ylab='Sub Metering') )
with( reduced_dat, lines(Date_time, Sub_metering_2, col='red', xlab='' ) )
with( reduced_dat, lines(Date_time, Sub_metering_3 , col='blue', xlab='') )

# lower right
with ( reduced_dat, plot( Date_time , Global_reactive_power ,  type = "l", main='',
                          xlab='Date/Time', ylab = 'Global Reactive Power' ) )
dev.off()
