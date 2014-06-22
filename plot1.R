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

totalEmmisionPerYear <- tapply(PM25EmissionData$Emissions, PM25EmissionData$year,sum) ## sum emission over year

if(!file.exists("./figures")) {dir.create("figures")} ## if figure does not exist create: figure dir, 

## save barplot png
png("./figures/plot1.png")
barplot(totalEmmisionPerYear/1000000,ylab="PM2.5 emission (in million ton)",xlab="year",
        main="Total Emission of PM2.5 over the years USA", col = "red",ylim=c(0,8))
dev.off()