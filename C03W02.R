installed.packages("httpuv")
remove.packages("httpuv", lib="~/R/win-library/3.6")
## To resort to out of band authentication.
library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. To make your own application, register at
#    https://github.com/settings/developers. Use any URL for the homepage URL
#    (http://github.com is fine) and  http://localhost:1410 as the callback url
#
#    Replace your key and secret below.
myapp<-oauth_app("github",key = "Iv1.ea3a6e317b47d98b", secret = "4b8ec9113c33621214282c38400a6ed1911c6a5c")
# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp, cache = FALSE)
# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://github.com/hadley/httr/blob/master/demo/oauth2-github.r", gtoken)
stop_for_status(req)
# OR:
req <- with_config(gtoken, GET("https://github.com/hadley/httr/blob/master/demo/oauth2-github.r"))
stop_for_status(req)
json1<-content(req)

install.packages("rjson")
library(rjson)
json2<-jsonlite::fromJSON(toJSON(json1))
json2[json2$name=="datasharing",]$created_at

install.packages("sqldf")
library(sqldf)
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileurl,destfile = "./data/americancommunity.csv",method = "curl")
acs<-read.csv("./data/americancommunity.csv")
sqldf("select pwgtp1 from acs where AGEP<50")
sqldf("select distinct AGEP from acs")

fileurl<-"http://biostat.jhsph.edu/~jleek/contact.html"
doc<-readLines(fileurl)
nchar(doc[10])

fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
hd<-read.fwf(fileurl, widths=c(10,rep(c(9,4),4)), skip=4)
sum(hd$V4)
