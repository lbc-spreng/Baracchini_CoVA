rm(list=ls())

source('~/Desktop/Grady_LAB/fMRI147/Useful scripts/scatterplotter.R', encoding = 'UTF-8')
library("R.matlab")
library("hrbrthemes")
setwd("/Users/giulia/Desktop/McGill_PhD/CoVA_PhD1/mat_files")
within <- readMat("ccorr_within_run21.mat")
within <- within$ccorr.within.run21
within <- t(within)

data <- as.data.frame(within)
colnames(data)[1] <- "Total Within"
data$Subjects <- seq(1,154)
data$Subjects <- as.factor(data$Subjects)

library("ggplot2")
library("reshape2")
test <- melt(data, id.vars = "Subjects")
breaks <- pretty(range(test$value), n = nclass.FD(test$value), min.n = 1)
bwidth <- breaks[2]-breaks[1]

#Total within
ggplot(test,aes(x=value, color=variable, ..scaled..)) + geom_density(alpha=0.25, size=1) +
  labs(x = "ccorr total within") + xlim(c(-0.4,0.4)) + theme_ipsum()

##########Now do between#############
rm(list=ls())

source('~/Desktop/Grady_LAB/fMRI147/Useful scripts/scatterplotter.R', encoding = 'UTF-8')
library("R.matlab")
setwd("/Users/giulia/Desktop/McGill_PhD/CoVA_PhD1/mat_files")
between <- readMat("ccorr_between_run21.mat")
between <- between$ccorr.between.run21
between <- t(between)

data <- as.data.frame(between)
colnames(data)[1] <- "Total Between"
data$Subjects <- seq(1,154)
data$Subjects <- as.factor(data$Subjects)

library("ggplot2")
library("reshape2")
test <- melt(data, id.vars = "Subjects")
breaks <- pretty(range(test$value), n = nclass.FD(test$value), min.n = 1)
bwidth <- breaks[2]-breaks[1]

#Total between
ggplot(test,aes(x=value, color=variable, ..scaled..)) + geom_density(alpha=0.25, size=1) +
  labs(x = "ccorr total between") + xlim(c(-0.4,0.4)) + theme_ipsum()

############Now plot tot within and between together###############
rm(list=ls())

#source('~/Desktop/Grady_LAB/fMRI147/Useful scripts/scatterplotter.R', encoding = 'UTF-8')
library("R.matlab")
setwd("/Users/giulia/Desktop/McGill_PhD/CoVA_PhD1/mat_files")
within <- readMat("ccorr_within_run21.mat")
within <- within$ccorr.within.run21
within <- t(within)

between <- readMat("ccorr_between_run21.mat")
between <- between$ccorr.between.run21
between <- t(between)

data <- cbind(within, between)
data <- as.data.frame(data)
colnames(data)[1] <- "Total Within"
colnames(data)[2] <- "Total Between"
data$Subjects <- seq(1,154)
data$Subjects <- as.factor(data$Subjects)

library("ggplot2")
library("reshape2")
library('hrbrthemes')
test <- melt(data, id.vars = "Subjects")
breaks <- pretty(range(test$value), n = nclass.FD(test$value), min.n = 1)
bwidth <- breaks[2]-breaks[1]

#All together
png("Supplementary_densityplot_run21.png", height = 900, width = 800, units='mm', res=300)
ggplot(test,aes(x=value, color=variable, ..scaled..)) + geom_density(alpha=0.25, size=1) +
  labs(x = "ccorr total run2-1") + xlim(c(-0.7,0.7)) + theme_ipsum() + theme(text = element_text(size = 20)) + theme(axis.title = element_text(size = 40))     
dev.off()

##########Let's now compute stats############
rm(list=ls())

#source('~/Desktop/Grady_LAB/fMRI147/Useful scripts/scatterplotter.R', encoding = 'UTF-8')
library("R.matlab")
setwd("/Users/giulia/Desktop/McGill_PhD/CoVA_PhD1/mat_files")
within <- readMat("ccorr_within_run21.mat")
within <- within$ccorr.within.run21
within <- t(within)

between <- readMat("ccorr_between_run21.mat")
between <- between$ccorr.between.run21
between <- t(between)

data <- cbind(between, within)
data <- as.data.frame(data)
colnames(data)[1] <- "Total Between"
colnames(data)[2] <- "Total Within"
data$Subjects <- seq(1,154)
data$Subjects <- as.factor(data$Subjects)

library("ggplot2")
library("reshape2")
test <- melt(data, id.vars = "Subjects")

library(ggpubr)
library(rstatix)

# Save the data in two different vectors
within <- data$`Total Within`
between <- data$`Total Between`
# Compute t-test
res <- t.test(within, between, paired = TRUE)
res
#The effect size for a paired-samples t-test can be calculated by dividing the mean difference 
#by the standard deviation of the difference, as shown below.
#Basically its (mean btw - mean within)/std pooled 
test  %>% cohens_d(value ~ variable, paired = TRUE)
#If you entered within first and between after you'd get a negative effect size
#The sign of your Cohen’s d depends on which sample means you label 1 and 2. 
#If M1 is bigger than M2, your effect size will be positive. 
#If the second mean is larger, your effect size will be negative. IN FACT BTW > WITHIN
#In short, the sign of your Cohen’s d effect tells you the direction of the effect. 
#If M1 is your experimental group, and M2 is your control group, then a negative effect size 
#indicates the effect decreases your mean, and a positive effect size 
#indicates that the effect increases your mean.


