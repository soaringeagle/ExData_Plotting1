url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile="electric.zip",method="libcurl")
unzip("electric.zip")

install.packages("sqldf")
library(sqldf)
df<- read.csv.sql("household_power_consumption.txt", sql = 'select * from file where Date in( "1/2/2007","2/2/2007")', header=TRUE, sep=";")
closeAllConnections()
colnames(df) <- c("Date","Time","Global_active_power","Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1","Sub_metering_2","Sub_metering_3")
df2<- df
datetime <- strptime(paste(df2$Date, df2$Time), "%d/%m/%Y %H:%M:%S")
df4 <- cbind(datetime,df2)

library(datasets)
png("plot4.png")
par(mfcol=c(2,2))
with(df4, plot(datetime,Global_active_power,main="",xlab="",ylab="Global active power (kilowatts)", type="l"))

plot(df4$datetime,df4$Sub_metering_1,xlab="",ylab="Energy sub metering", type="n")
with(df4,lines(datetime, Sub_metering_1,ylim=40,col="black"))
with(df4,lines(datetime, Sub_metering_2,ylim=40,col="red"))
with(df4,lines(datetime, Sub_metering_3,ylim=40,col="blue"))
legend("topright", lwd=1, col= c("black","red","blue"), bty="n", legend= c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

plot(df4$datetime, df4$Voltage, main="",xlab="datetime",ylab="Voltage",type="l")
plot(df4$datetime, df4$Global_reactive_power, main="", xlab="datetime",ylab="Global_reactive_power",type="l")

dev.off()