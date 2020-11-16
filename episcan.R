#Feature selection with Episcan

library(episcan)
data<- read.csv("./Complete_withANSWER.csv", row.names=1)
pheno = data$Y
geni = as.matrix(data[,-ncol(data)])
str(geni)
set.seed(123)
# one genotype with case-control phenotype
episcan(geno1 = geni,
        geno2 = NULL,
        pheno = pheno,
        phetype = "quantitative",
        outfile = "episcan_1geno_cc",
        suffix = ".txt",
        zpthres = 0.9,
        chunksize = 1000,
        scale = TRUE)
# take a look at the result

res <- read.table("episcan_1geno_cc.txt",
                  header = TRUE,
                  stringsAsFactors = FALSE)
head(res)