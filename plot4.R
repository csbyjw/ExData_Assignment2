## confirm if data exists, if not: download and unzip
setwd("~/Documents/git/ExData_Assignment2")
if(!file.exists("./data/summarySCC_PM25.rds")){
       if(!file.exists("./data")){dir.create("data")}
       
       fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
       download.file(fileUrl, destfile = "./data/PM25.zip", method="curl")
       unzip("./data/PM25.zip",exdir="./data")
       unlink("./data/PM25.zip"); 
}

PM25EmissionData <- readRDS("./data/summarySCC_PM25.rds") ## read data in
mapping <- readRDS("./data/Source_Classification_Code.rds") ## read data in

SCCCoalComb <-  as.character(mapping$SCC[grepl("Comb.*Coal", mapping$EI.Sector)]) ## find all SCC-values for coal combustion related sources
CoalCombIndex <- PM25EmissionData$SCC %in% SCCCoalComb ## find indices of the SCC-values in the emission data
PM25CoalComb <- PM25EmissionData[CoalCombIndex,] ## subset all the coalcombustion related sources in the data

totalCoalCombPerYear <- tapply(PM25CoalComb$Emissions, PM25CoalComb$year,sum) ## sum over the years

## save barplot png
png("./figures/plot4.png")
barplot(totalCoalCombPerYear/1000000, ylab="PM2.5 emission (in million tons)", xlab="year", ylim = c(0,0.6),
        main="Coal Combustion PM2.5 emission in the USA over the years", col = "red")
dev.off()