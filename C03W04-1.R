fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileurl,destfile = "./data/community4.csv",method = "curl")
data<-read.csv("./data/community4.csv")
splitnames<-strsplit(names(data),split="wgtp")
splitnames[123]

fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileurl,destfile = "./data/gdp2.csv",method = "curl")
gdp<-read.csv("./data/gdp2.csv")
gdp<-gdp[-(1:4),]
which.max(gdp$X.2=="")
dim(gdp)
gdp<-gdp[-(191:326),]
mean(as.numeric(gsub(",","",gdp$X.3)),na.rm=TRUE)

grep("^United",gdp$X.2)

fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileurl,"./data/gdp3.csv",method="curl")
library(data.table)
gdp<-fread("./data/gdp3.csv",skip=4,nrows=190,select=c(1,2,4,5),col.names=c("CountryCode","Ranking","Country","GDP"))
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileurl,"./data/education2.csv",method="curl")
edu<-read.csv("./data/education2.csv")
merged<-merge(gdp,edu,all=FALSE)
dim(merged)
length(grep("Fiscal year end: June",merged$Special.Notes))

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
amzn2012 <- sampleTimes[grep("^2012", sampleTimes)]
NROW(amzn2012)
NROW(amzn2012[weekdays(amzn2012) == "Monday"])