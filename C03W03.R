fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileurl,destfile = "./data/UScommunities.csv")
mydata<-read.csv("./data/UScommunities.csv")
agricultureLogical<-mydata$ACR==3 & mydata$AGS==6
which(agricultureLogical)

library(jpeg)
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileurl,destfile = "./data/parameter.jpg",mode = 'wb')
# To fix, JPEG decompression: Corrupt JPEG data: 1 extraneous bytes before marker 0xc4
pic<-readJPEG("./data/parameter.jpg",native = TRUE)
quantile(pic,probs = c(0.30,0.80))

fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileurl,"./data/gdp.csv",method="curl")
gdp<-read.csv("./data/gdp.csv")
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileurl,"./data/education.csv",method="curl")
edu<-read.csv("./data/education.csv")
head(gdp)
cols<-c("CountryCode","Ranking","","Country","GDP")
colnames(gdp)<-cols
gdp<-gdp[-(1:4),-(6:10)]
which.max(gdp$Ranking=="")
dim(gdp)
gdp<-gdp[-(191:326),-3]
tail(gdp) ## or
library(data.table)
gdp<-fread("./data/gdp.csv",skip=4,nrows=190,select=c(1,2,4,5),col.names=c("CountryCode","Ranking","Country","GDP"))
merged<-merge(gdp,edu,all=FALSE)
dim(merged)
class(merged$Ranking)
merged$Ranking <- as.numeric(as.character(merged$Ranking))
## The column was classed as Factor so the ranking was wrong. 1 followed by 10,100,...
merged[order(merged$Ranking),][13,3] ## The below gives the right answer
arrange(merged, desc(Ranking))[13, 3]

library(dplyr)
unique(merged$Income.Group)
merged%>%group_by(Income.Group)%>%summarise(avg_gdp=mean(Ranking))%>%print ##or
tapply(merged$Ranking,merged$Income.Group,mean)

library(Hmisc)
merged$groups=cut2(merged$Ranking,g=5)
table(merged$Income.Group,merged$groups)
