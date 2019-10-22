## This program reads already downloaded csv files in the data folder
## and reads all files. Sample function calls:
## pollutantmean("specdata", "sulfate", 1:10)

pollutantmean<-function(directory,pollutant,id=1:332){
    s<-numeric(length(id))
    c<-numeric(length(id))
    j<-1
    for (i in id){
        path<-paste0('./data/rprog_data_specdata/',directory,'/',sprintf("%03d.csv",i))
        my_data<-read.csv(path)
        s[j]<-sum(my_data[,pollutant],na.rm=TRUE)
        c[j]<-sum(!is.na(my_data[,pollutant]))
        j<-j+1
    }
    sum(s)/sum(c)
}
complete<-function(directory,id=1:332){
    df<-data.frame(id=integer(),nobs=integer())
    j<-1
    for(i in id){
        path<-paste0('./data/rprog_data_specdata/',directory,'/',sprintf("%03d.csv",i))
        my_data<-read.csv(path)
        df[j,1]<-i
        df[j,2]<-sum(!is.na(my_data[,"sulfate"])&!is.na(my_data[,"nitrate"]))
        j<-j+1
    }
    df
}
corr<-function(directory,threshold=0){
    corr<-vector()
    j<-1
    for(i in 1:332){
        path<-paste0('../data/rprog_data_specdata/',directory,'/',sprintf("%03d.csv",i))
        my_data<-read.csv(path)
        if(sum(!is.na(my_data[,"sulfate"])&!is.na(my_data[,"nitrate"]))>threshold){
            corr[j]<-cor(my_data[,"sulfate"],my_data[,"nitrate"],use="complete.obs",method = c("pearson", "kendall", "spearman"))
            j<-j+1
        }
    }
    corr
}