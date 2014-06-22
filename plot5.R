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

SCCVehicles <-  as.character(mapping$SCC[grepl("Vehicles", mapping$EI.Sector)]) ## find all SCC-values for vehicle related sources
VehiclesIndex <- PM25EmissionData$SCC %in% SCCVehicles ## find indices of the SCC-values in the emission data
PM25Vehicles <- PM25EmissionData[VehiclesIndex,] ## subset all the vehicles related sources in the data

totalVehiclesBalt <- tapply(PM25Vehicles$Emissions[PM25Vehicles$fips==24510], 
                            PM25Vehicles$year[PM25Vehicles$fips==24510], sum) ## sum over the years only for Baltimore

## save barplot png
png("./figures/plot5.png")
barplot(totalVehiclesBalt,ylab="PM2.5 emission (in tons)", xlab="year", ylim = c(0,350),
        main="Vehicle PM2.5 emission in Baltimore over the years", col = "red")
dev.off()