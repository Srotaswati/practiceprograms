fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileurl,destfile = "./data/housing.csv",method = "curl")
my_data<-read.csv("./data/housing.csv")
sum(my_data$VAL==24,na.rm = TRUE)

library(xlsx)
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileurl,destfile = "./data/naturalgas.xlsx",mode='wb')
## To fix, Error in .jcall("RJavaTools", "Ljava/lang/Object;", "invokeMethod", cl,  : 
##java.util.zip.ZipException: invalid code -- missing end-of-block
colIndex<-7:15
rowIndex<-18:23
my_data<-read.xlsx("./data/naturalgas.xlsx",sheetIndex = 1,colIndex = colIndex,rowIndex = rowIndex)
sum(my_data$Zip*my_data$Ext,na.rm=T)

library(XML)
fileurl<-"http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
## https did not work Error: XML content does not seem to be XML
doc<-xmlTreeParse(fileurl,useInternalNodes = TRUE)
sum(xpathSApply(rootNode,"//zipcode",xmlValue)=="21231")

library(data.table)
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileurl,destfile = "./data/idahocommunity.csv")
DT<-fread("./data/idahocommunity.csv")
system.time(for (i in 1:1000){sapply(split(DT$pwgtp15,DT$SEX),mean)}) #fastest
system.time(for (i in 1:1000){tapply(DT$pwgtp15,DT$SEX,mean)})
system.time(for (i in 1:1000){mean(DT[DT$SEX==1,]$pwgtp15);mean(DT[DT$SEX==2,]$pwgtp15)})# fastest for data table
system.time(for (i in 1:1000){DT[,mean(pwgtp15),by=SEX]})
mean(DT$pwgtp15,by=DT$SEX) ## both sexes combined
rowMeans(DT)[DT$SEX==1];rowMeans(DT)[DT$SEX==2] ## error