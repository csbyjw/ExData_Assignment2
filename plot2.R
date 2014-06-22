## confirm if data exists, if not: download and unzip
setwd("~/Documents/git/ExData_Assignment2")
if(!file.exists("./data/summarySCC_PM25.rds")){
       if(!file.exists("./data")){dir.create("data")}
       
       fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
       download.file(fileUrl, destfile = "./data/PM25.zip", method="curl")
       unzip("./data/PM25.zip",exdir="./data")
       unlink("./data/PM25.zip"); 
}

PM25EmissionData <- readRDS("./data/summarySCC_PM25.rds") ## read in data

totalEmmisionBaltimore <- tapply(PM25EmissionData$Emissions[PM25EmissionData$fips==24510], 
                                 PM25EmissionData$year[PM25EmissionData$fips==24510],sum) ## sum emission over years only from Baltimore

## save barplot png
png("./figures/plot2.png")
barplot(totalEmmisionBaltimore/1000,ylab="PM2.5 emission (in thousand ton)",xlab="year",
        main="Baltimore PM2.5 emissions over the years", col = "red")
dev.off()