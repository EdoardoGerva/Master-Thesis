library(tidyverse)
library(dagitty)
library(lavaan)
library(stats)
library(bnlearn)
library(naniar)
library(ggplot2)
library(caret)
library(MLmetrics)
library(Rgraphviz)
library(epiGTBN)
library(data.table)

#Removing Main Effects: Features for which chi-squared test p-value < 0.01.

require(data.table)
data <- fread("C:\\Users\\edoge\\Desktop\\Università\\Epistasis\\Codes\\complete_withANSWER.csv",sep=',')


mydata <- setDF(data)

df <- data.frame(SNP = character(),          # Specify empty vectors in data.frame
                 p_value = double(),
                 stringsAsFactors = FALSE)

#computing p-values
l=1
for(i in c(1:(ncol(mydata)-1))){
  col <- mydata[,i]
  test <- chisq.test( col,mydata$Y )
  test$p.value
  
  df[l, ] <- list(colnames(mydata)[i],test$p.value)
  l<-l+1
}

#removing SNPs according to treshold
filtered <- filter(df,p_value>0.01)
filtered

Selected_SNPS <- filtered[,1]
write.csv(Selected_SNPS, file = "C:\\Users\\edoge\\filtered_SNPs.csv")