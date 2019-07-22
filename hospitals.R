## This function reads hospital mortality data in the US and returns the best hospital
## (i.e. with the lowest mortality rate) given the state and a specified outcome

best <- function(state,outcome){
    my_data <- read.csv("outcome-of-care-measures.csv",stringsAsFactors = FALSE)
    outnames <- list(names=c("heart attack", "heart failure", "pneumonia"),cols=c(11,17,23))
    states <- unique(my_data[,7])
    if(is.na(match(toupper(state),states)))
        cat(sprintf("Error in best(\"%s\", \"%s\"): invalid state",state,outcome))
    else if(!(outcome %in% outnames$names))
        cat(sprintf("Error in best(\"%s\", \"%s\"): invalid outcome",state,outcome))
    else{
        state_set<-my_data[my_data$State == toupper(state),]
        col<-outnames$cols[match(outcome,outnames$names)]
        state_set[,col] <- as.numeric(state_set[,col])
        state_set[order(state_set[,col],state_set[,2]),][1,2]
    }
}

## This function reads hospital mortality data in the US and returns the rank of the hospital by
## mortality rate given the state and a specified outcome

rankhospital <- function(state, outcome, num = "best"){
    my_data <- read.csv("outcome-of-care-measures.csv",stringsAsFactors = FALSE)
    outnames <- list(names=c("heart attack", "heart failure", "pneumonia"),cols=c(11,17,23))
    states <- unique(my_data[,7])
    if(is.na(match(toupper(state),states)))
        cat(sprintf("Error in rankhospital(\"%s\", \"%s\",\"%s\"): invalid state",state,outcome,num))
    else if(!(outcome %in% outnames$names))
        cat(sprintf("Error in rankhospital(\"%s\", \"%s\",\"%s\"): invalid outcome",state,outcome,num))
    else{
        state_set<-my_data[my_data$State == toupper(state),]
        col<-outnames$cols[match(outcome,outnames$names)]
        state_set[,col] <- as.numeric(state_set[,col])
        if(num=="best")
            state_set[order(state_set[,col],state_set[,2]),][1,2]
        else if(num=="worst")
            state_set[order(-state_set[,col],state_set[,2]),][1,2]
        else if(is.numeric(num))
            state_set[order(state_set[,col],state_set[,2]),][num,2]
    }
}

## This function reads hospital mortality data in the US and returns the n best hospitals in each state
## and sorted by mortality rate given a specified outcome

rankall <- function(outcome, num = "best"){
    my_data <- read.csv("outcome-of-care-measures.csv",stringsAsFactors = FALSE)
    outnames <- list(names=c("heart attack", "heart failure", "pneumonia"),cols=c(11,17,23))
    states <- unique(my_data[,7])
    if(!(outcome %in% outnames$names))
        cat(sprintf("Error in rankall(\"%s\", \"%s\"): invalid outcome",outcome,num))
    col<-outnames$cols[match(outcome,outnames$names)]
    my_data[,col] <- as.numeric(my_data[,col])
    state<-my_data[order(my_data[,7],my_data[,col],na.last = NA),][,c(2,7)]
    if(num=="best"){
        l<-sapply(split(state,state$State),head,n=1)
        out<-cbind(l[1,],l[2,])
        columns<-c("Hospital","State")
        colnames(out)<-columns
        rownames(out)<-NULL
        data.frame(out)
    }
    else if(num=="worst"){
        l<-sapply(split(state,state$State),tail,n=1)
        out<-cbind(l[1,],l[2,])
        columns<-c("Hospital","State")
        colnames(out)<-columns
        rownames(out)<-NULL
        data.frame(out)
    }
    else if(is.numeric(num)){
        l<-lapply(split(state,state$State),head,n=num)
        df<-as.data.frame(do.call(rbind,l))
        rownames(df)<-NULL
        df
    }
}