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


SCCVehicles <-  as.character(mapping$SCC[grepl("Vehicles",mapping$EI.Sector)]) ## find all SCC-values for vehicle related sources
VehiclesIndex <- PM25EmissionData$SCC %in% SCCVehicles ## find indices of the SCC-values in the emission data
PM25Vehicles <- PM25EmissionData[VehiclesIndex,] ## subset all the vehicles related sources in the data

baltAndLAVehicles <- PM25Vehicles[(PM25Vehicles$fips=="24510"|PM25Vehicles$fips=="06037"),] ## subset data to only consist of data from Baltimore and Los Angeles

baltAndLAVehicles$fips <- factor(baltAndLAVehicles$fips, labels=c("Los Angeles", "Baltimore")) ## set year and fips as factor with correct labels
baltAndLAVehicles$year <- factor(baltAndLAVehicles$year)

require(ggplot2)
require(grid)

g <- ggplot(baltAndLAVehicles,aes(x = year, y = Emissions)) ## setup ggplot with correct aesthetics

## save png ggplot barplot with different plots for the different cities (fips)
png("./figures/plot6.png", width=1200, height=600)
g + geom_bar(stat = "identity") + facet_grid(.~fips) + ggtitle("Trend of vehicle PM2.5 emission in Baltimore and Los Angeles") +
       theme(plot.title = element_text(face="bold", vjust=2)) + theme(plot.margin = unit(c(1,1,1,0), "cm")) + ylab("PM2.5 Emission (in tons)")
dev.off()