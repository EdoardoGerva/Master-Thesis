sink(file = "episcan.txt")

library(data.table)
library(tidyverse)
library(lavaan)
library(bnlearn)
library(naniar)
library(caret)
library(epiGTBN)
library(dplyr)
library(plyr)

#bootstrap procedure for Episcan data

read the data
data_episcan  <- read.csv("Episcan_episcan_full_corrected_top400.csv")
#remove missing genotypes
row <- apply(data_episcan,1,function(row) all(row !=-1))
data_episcan <- data_episcan[row,]

set.seed(111)
source("parameters.R")
edges_rel <- data.frame(from = character(),
                        to = character(),
                        stringsAsFactors = F)

#bootstrap with N:10
N <- 10
for(i in c(1:N)){
  cat('\n',i)
  #sampling random rows mantaining class label ratios with replacement
  data_sample <- data_episcan %>% group_by(Y) %>% sample_n(5000, replace =T)
  
  data_sample$Y[data_sample$Y == 1]<-0
  data_sample$Y[data_sample$Y == 2]<-1
  
  res<- gtbn2(data_sample, max.iter = 100, debug = FALSE)
  prediction <- data.frame(res$arcs)
  #show(prediction)
  edges_rel <- rbind(edges_rel,prediction)
  
}

edges_rel
#graphviz.plot(res,layout='fdp')
score<-ddply(edges_rel,.(from,to),nrow)
score<-score[with(score, order(-V1)), ]
score
write.csv(score,file='score_episcan_top400.csv')

#considering only scores for undirected archs
undir_1 <- score

memory <- data.frame(from = character(),
                     to = character(),
                     V1 = integer(),
                     stringsAsFactors = F)

arch_scores <- data.frame(SNP1 = character(),
                          SNP2 = character(),
                          V1 = integer(),
                          stringsAsFactors = F)



i<-1
for(x in c(1:nrow(undir_1))){
  snp1 <- undir_1[x,1]
  snp2 <- undir_1[x,2]
  curr <- undir_1[x,]
  mate <- undir_1[undir_1$from %like% snp2 & undir_1$to %like% snp1,]
  #cat('\n',nrow(mate))
  #cat('\n',do.call(paste0, memory))
  if(do.call(paste0, curr) %in% do.call(paste0, memory)){
    #cat(i, '   already matched \n')
    i <-i+1
    next
  }
  
  memory <- rbind(memory,mate)
  if(nrow(mate)<1){
    tot_score <- undir_1[x,3]
  }  else {
    tot_score <- undir_1[x,3] + mate$V1
  }
  #cat(i,'  The score for the connection between  ',snp1,'  and  ' ,snp2, '  is: ',tot_score,'\n' )
  arch_scores[x,1] <- snp1
  arch_scores[x,2] <- snp2
  arch_scores[x,3] <- tot_score
  i <-i+1
}

arch_scores <- arch_scores[complete.cases(arch_scores), ]
arch_scores<-arch_scores[with(arch_scores, order(-V1)), ]
arch_scores

write.csv(arch_scores,file='Undirected_arch_scores_episcan_top400.csv')

sink()
