##Reading the file
if (!file.exists("./data/getdata3.zip")){
  fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileurl,"./data/getdata3.zip",method="curl")
}
if (!(file.exists("./data/Source_Classification_Code.rds")&file.exists("./data/summarySCC_PM25.rds"))) { 
  unzip("./data/getdata3.zip",exdir="./data") 
}

##Plot 1: Total Emissions by Year
NEI<-readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
yearly_Emissions<-aggregate(Emissions~year,NEI,sum)
pal<-colorRampPalette(c("black","grey"))
png(filename = "./data/plot1.png",width = 480,height = 480,units = "px")
barplot(yearly_Emissions$Emissions/10^6,yearly_Emissions$year,main="Total yearly Emissions in Mt in USA",col=pal(4))
text(x=bp[,1],y=-0.2,adj=c(1,1),yearly_Emissions$year,cex=1.0,srt=0,xpd=TRUE)
dev.off()
yearly_Emissions<-transform(yearly_Emissions,year=factor(year))## Demo that ggplot needs factors
g<-ggplot(data=yearly_Emissions,aes(year,Emissions))+geom_bar(stat="identity",fill="steelblue")

##Plot 2: Total Emissions by Year for Baltimore City
NEI<-readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
library(dplyr)
baltimore_NEI<-NEI%>%filter(fips=="24510")%>%group_by(year)%>%summarise(Emissions=sum(Emissions))
png(filename = "./data/plot2.png",width = 480,height = 480,units = "px")
barplot(yearly_Emissions$Emissions/10^6,yearly_Emissions$year,main="Total yearly Emissions in Mt in Baltimore City",col="steelblue")
text(x=bp[,1],y=-0.2,adj=c(1,1),yearly_Emissions$year,cex=1.0,srt=0,xpd=TRUE)
dev.off()

##Plot 3: Decrease in Emissions by type for Baltimore City
NEI<-readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
library(ggplot2)
library(dplyr)
baltimore_NEI<-NEI%>%filter(fips=="24510")%>%group_by(year,type)%>%summarise(Emissions=sum(Emissions))
file<-tempfile()
ggplot(data = baltimore_NEI,aes(year,Emissions,col=type))+geom_line()+ylab("Emissions in tons")+theme(axis.title.x=element_blank())+ggtitle("Yearly Emissions in Baltimore City by Type")
ggsave(filename = "./data/plot3.png",device = "png")
unlink(file)

##Plot 4: Emissions changes from coal combustion-related sources
NEI<-readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
table(SCC$EI.Sector,SCC$Data.Category) ## to find coal-combustion scources
coal_index<-grep(".*Coal.*",SCC$EI.Sector)
coal_SCC<-SCC$SCC[coal_index]
coal_NEI<-subset(NEI,NEI$SCC %in% coal_SCC)
yearly_Emissions<-aggregate(Emissions~year,coal_NEI,sum)
file<-tempfile()
ggplot(data = yearly_Emissions,aes(year,Emissions))+geom_line()+ylab("Emissions in tons")+theme(axis.title.x=element_blank())+ggtitle("Yearly Emissions in USA from coal-related sources")
ggsave(filename = "./data/plot4.png",device = "png")
unlink(file)

##Plot 5: Emissions from motor vehicle sources in Baltimore City
NEI<-readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
table(SCC$EI.Sector,SCC$Data.Category) ## to check motor vehicle sources
baltimore_motor<-subset(NEI,fips=="24510" & type=="ON-ROAD")
yearly_Emissions<-aggregate(Emissions~year,baltimore_motor,sum)
file<-tempfile()
ggplot(data = yearly_Emissions,aes(year,Emissions))+geom_line()+ylab("Emissions in tons")+theme(axis.title.x=element_blank())+ggtitle("Yearly Emissions in Baltimore from motor vehicle sources")
ggsave(filename = "./data/plot5.png",device = "png")
unlink(file)

##Plot 6: Comparison of emissions of Baltimore City vs Los Angeles
NEI<-readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
table(SCC$EI.Sector,SCC$Data.Category) ## to check motor vehicle sources
library(dplyr)
baltimore_motor<-NEI%>%filter(fips=="24510" & type=="ON-ROAD")%>%group_by(year)%>%summarise(Emissions=sum(Emissions))%>%mutate(County="Baltimore City")
losangeles_motor<-NEI%>%filter(fips=="06037" & type=="ON-ROAD")%>%group_by(year)%>%summarise(Emissions=sum(Emissions))%>%mutate(County="Los Angeles County")
yearly_Emissions<-rbind(losangeles_motor,baltimore_motor)
file<-tempfile()
ggplot(yearly_Emissions,aes(factor(year),Emissions,fill=County))+geom_bar(stat = "identity")+facet_grid(County~.,scales = "free")+xlab("year")+ggtitle("Baltimore vs Los Angeles Motor Vehicle Emissions")+theme(legend.position = "none")+theme(axis.title.x=element_blank())+ylab("Emissions in tons")
ggsave(filename = "./data/plot6.png",device = "png")
unlink(file)
