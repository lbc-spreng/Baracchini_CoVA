rm(list=ls())

library("R.matlab")

setwd("/Users/giulia/Desktop")
corr1 <- readMat("Lowertrg_fcmssdcorr_run1_sign.mat")
corr1 <- t(corr1$lowertriangle.corr1)

corr2 <- readMat("Lowertrg_fcmssdcorr_run2_sign.mat")
corr2 <- t(corr2$lowertriangle.corr2)

data <- cbind(corr1,corr2)
data <- as.data.frame(data)

colnames(data)[1] <- "Run1"
colnames(data)[2] <- "Run2"

hist(data$Run1)
hist(data$Run2)

scatterplotter(corr1, corr2, fname = "Run1_Run2", x.lab = "FC-MSSD Run1", y.lab = "FC-MSSD Run2", 
                border = "navyblue", line.col = "darkgray", 
                lineFLAG = TRUE, corFLAG = TRUE)

library("ggpubr")
ggscatter(data, x = "V1", y = "V2", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Run1", ylab = "Run2")
#0.44 with Pearson and 0.39 with Spearman

## Now correlate the two dotprod matrices
rm(list=ls())

setwd("/Users/giulia/Desktop")
data <- read.csv("Dotprod_run1run2.csv", header = TRUE, sep = ,)

library("ggpubr")
ggscatter(data, x = "Run1", y = "Run2", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Dotprod run1", ylab = "Dotprod run2")
#0.96 with Spearman and 0.98 with Pearson. p<.001 in both cases
