## Reviewer 3 Dominance analysis hierarchical regression
rm(list=ls())

library("R.matlab")
setwd("/Users/giulia/Desktop")

fc <- readMat("Hierarchregr_input_fc_young.mat")
fc <- fc$fc

mssd <- readMat("Hierarchregr_input_zscoredmssd_young.mat")
mssd <- mssd$zscored.mssd

ms <- readMat("Hierarchregr_input_zscoredms_young.mat")
ms <- ms$zscored.ms

distance <- readMat("Hierarchregr_input_zscoredist_young.mat")
distance <- distance$zscored.dist

#install.packages("dominanceanalysis")
library("dominanceanalysis")

n <- 200

#fc = dist
set.seed(5)
lm_dist <- lapply(1:n, function(x) lm(fc[-x,x] ~ distance[-x,x])) #-x='Exclude' node itself
summaries_dist <- lapply(lm_dist, summary)
#fstatistics
fstats_dist <- lapply(summaries_dist, function(x) x$fstatistic)
#r-squared values
rsq_dist <- sapply(summaries_dist, function(x) c(r_sq = x$r.squared, 
                                                 adj_r_sq = x$adj.r.squared))

#fc = dist+ms
set.seed(14)
lm_1 <- lapply(1:n, function(y) lm(fc[-y,y] ~ distance[-y,y]+ms[-y,y]))
summaries_distms <- lapply(lm_1, summary)
#fstatistics
fstats_distms <- lapply(summaries_distms, function(y) y$fstatistic)
#r-squared values
rsq_distms <- sapply(summaries_distms, function(y) c(r_sq = y$r.squared, 
                                                     adj_r_sq = y$adj.r.squared))

#fc = dist+ms+mssd
set.seed(27)
lm_2 <- lapply(1:n, function(z) lm(fc[-z,z] ~ distance[-z,z]+ms[-z,z]+mssd[-z,z]))
summaries_distmsvar <- lapply(lm_2, summary)
#fstatistics
fstats_distmsvar <- lapply(summaries_distmsvar, function(z) z$fstatistic)
#r-squared values
rsq_distmsvar <- sapply(summaries_distmsvar, function(z) c(r_sq = z$r.squared, 
                                                           adj_r_sq = z$adj.r.squared))

#ANOVA
set.seed(11)
model_comparison <- lapply(1:n, function(a) 
  anova(lm(fc[-a,a] ~ distance[-a,a]), lm(fc[-a,a] ~ distance[-a,a]+ms[-a,a]), 
        lm(fc[-a,a] ~ distance[-a,a]+ms[-a,a]+mssd[-a,a])))


#Dominance Analysis
set.seed(23)
da_final <- lapply(1:n, function(w) dominanceAnalysis(lm(fc[-w,w] ~ distance[-w,w]+ms[-w,w]+mssd[-w,w]))) 
###calculate percentage relative importance
#sum across the average contributions
contrib_distance <- lapply(1:n, function(b)
  da_final[[b]]$contribution.average$r2[1]*100/sum(da_final[[b]]$contribution.average$r2))
contrib_distance <- as.data.frame(contrib_distance)
contrib_distance <- t(contrib_distance)
rownames(contrib_distance) <- c(1:200)
colnames(contrib_distance) <- "Distance_RelativeContributionPercent"

contrib_ms <- lapply(1:n, function(c)
  da_final[[c]]$contribution.average$r2[2]*100/sum(da_final[[c]]$contribution.average$r2))
contrib_ms <- as.data.frame(contrib_ms)
contrib_ms <- t(contrib_ms)
rownames(contrib_ms) <- c(1:200)
colnames(contrib_ms) <- "Structure_RelativeContributionPercent"

contrib_mssd <- lapply(1:n, function(d)
  da_final[[d]]$contribution.average$r2[3]*100/sum(da_final[[d]]$contribution.average$r2))
contrib_mssd <- as.data.frame(contrib_mssd)
contrib_mssd <- t(contrib_mssd)
rownames(contrib_mssd) <- c(1:200)
colnames(contrib_mssd) <- "Variability_RelativeContributionPercent"

### Now create dataframes for da percent relative contribution and for Fstats per node
da_percentcontrib <- cbind(contrib_distance,contrib_ms, contrib_mssd)
da_percentcontrib <- as.data.frame(da_percentcontrib)

fstats_dist <- as.data.frame(fstats_dist)
fstats_dist <- t(fstats_dist)
rownames(fstats_dist) <- c(1:200)
colnames(fstats_dist)[1] <- "Fstats_Distance"
fstats_dist <- fstats_dist[,1]

fstats_distms <- as.data.frame(fstats_distms)
fstats_distms <- t(fstats_distms)
rownames(fstats_distms) <- c(1:200)
colnames(fstats_distms)[1] <- "Fstats_DistStru"
fstats_distms <- fstats_distms[,1]

fstats_distmsvar <- as.data.frame(fstats_distmsvar)
fstats_distmsvar <- t(fstats_distmsvar)
rownames(fstats_distmsvar) <- c(1:200)
colnames(fstats_distmsvar)[1] <- "Fstats_DistStruVar"
fstats_distmsvar <- fstats_distmsvar[,1]

fstats_node <- cbind(fstats_dist, fstats_distms, fstats_distmsvar)
fstats_node <- as.data.frame(fstats_node)

###### Ok now plot the results!!!
##First rearrange nodes 
index <- read.csv("Schaefer200_index.csv", header = TRUE, sep = ,)

rearranged_fstats <- fstats_node[index$index,]
rearranged_dapercentcontrib <- da_percentcontrib[index$index,]

## Plotting F statistics 
library(ggplot2)
networks <- c(rep("Visual",29), rep("Somatomotor",35), rep("Dan",26), rep("Van",22), rep("Limbic",12), rep("Control",30), rep("Default",46))
networks <- as.factor(networks)
networks <- factor(networks, levels(networks)[c(7,5,2,6,4,1,3)])
fstats <- cbind(rearranged_fstats$fstats_dist,rearranged_fstats$fstats_distms,rearranged_fstats$fstats_distmsvar, networks)
fstats <- as.data.frame(fstats)
colnames(fstats)[1] <- "Rearr_Fstats_dist"
colnames(fstats)[2] <- "Rearr_Fstats_distms"
colnames(fstats)[3] <- "Rearr_Fstats_distmsvar"

p1<-ggplot(fstats, aes(x=as.factor(networks), y=Rearr_Fstats_dist, fill=as.factor(networks))) +
  geom_violin(trim = FALSE) + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7")) +
  #geom_dotplot(binaxis='y', stackdir='center',  binwidth=10, dotsize=0.2) + ylim(c(-100,430)) +
  stat_summary(fun.data = "mean_sdl", mult=1, geom="pointrange") +
  theme(text = element_text(size=16)) + ylim(c(-100,430))
p1 + labs(x="Schaefer Networks", y="Fstats distance") + scale_x_discrete(labels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) + theme(legend.position = "none") 
ggsave("Fstats_dist_networks.png",width = 11, height = 6, dpi = 300)

p2<-ggplot(fstats, aes(x=as.factor(networks), y=Rearr_Fstats_distms, fill=as.factor(networks))) +
  geom_violin(trim = FALSE) + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7")) +
  #geom_dotplot(binaxis='y', stackdir='center', binwidth=10, dotsize=0.2) + ylim(c(-100,430)) +
  stat_summary(fun.data = "mean_sdl", mult=1, geom="pointrange") +
  theme(text = element_text(size=16)) + ylim(c(-100,430))
p2 + labs(x="Schaefer Networks", y="Fstats distance-structure") + scale_x_discrete(labels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) + theme(legend.position = "none") 
ggsave("Fstats_diststr_networks.png",width = 11, height = 6, dpi = 300)

p3<-ggplot(fstats, aes(x=as.factor(networks), y=Rearr_Fstats_distmsvar, fill=as.factor(networks))) +
  geom_violin(trim = FALSE) + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7")) +
  #geom_dotplot(binaxis='y', stackdir='center',  binwidth=10, dotsize=0.2) + ylim(c(-100,430)) +
  stat_summary(fun.data = "mean_sdl", mult=1, geom="pointrange") +
  theme(text = element_text(size=16)) + ylim(c(-100,430))
p3 + labs(x="Schaefer Networks", y="Fstats distance-structure-irsMSSD") + scale_x_discrete(labels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) + theme(legend.position = "none") 
ggsave("Fstats_diststrirsMSSD_networks.png",width = 11, height = 6, dpi = 300)

## Plotting DA Percent Contribution
da_contrib <- cbind(rearranged_dapercentcontrib$Distance_RelativeContributionPercent,rearranged_dapercentcontrib$Structure_RelativeContributionPercent,rearranged_dapercentcontrib$Variability_RelativeContributionPercent, networks)
da_contrib <- as.data.frame(da_contrib)
colnames(da_contrib)[1] <- "Distance"
colnames(da_contrib)[2] <- "Structure"
colnames(da_contrib)[3] <- "irsMSSD"

p4<-ggplot(da_contrib, aes(x=as.factor(networks), y=Distance, fill=as.factor(networks))) +
  geom_violin(trim = FALSE) + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7")) +
  #geom_dotplot(binaxis='y', stackdir='center',  binwidth=5, dotsize=0.15) + ylim(c(-20,150)) +
  stat_summary(fun.data = "mean_sdl", mult=1, geom="pointrange") +
  theme(text = element_text(size=16)) + ylim(c(-20,150)) 
p4 + labs(x="Schaefer Networks", y="Distance Relative % Contribution") + scale_x_discrete(labels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) + theme(legend.position = "none") 
ggsave("Distance_RelativeContributionPercent.png",width = 11, height = 6, dpi = 300)

p5<-ggplot(da_contrib, aes(x=as.factor(networks), y=Structure, fill=as.factor(networks))) +
  geom_violin(trim = FALSE) + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7")) +
  #geom_dotplot(binaxis='y', stackdir='center',  binwidth=5, dotsize=0.15) + ylim(c(-20,150)) +
  stat_summary(fun.data = "mean_sdl", mult=1, geom="pointrange") +
  theme(text = element_text(size=16)) + ylim(c(-20,150)) 
p5 + labs(x="Schaefer Networks", y="Structure Relative % Contribution") + scale_x_discrete(labels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) + theme(legend.position = "none") 
ggsave("Structure_RelativeContributionPercent.png",width = 11, height = 6, dpi = 300)

p6<-ggplot(da_contrib, aes(x=as.factor(networks), y=irsMSSD, fill=as.factor(networks))) +
  geom_violin(trim = FALSE) + scale_color_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7")) +
  #geom_dotplot(binaxis='y', stackdir='center',  binwidth=5, dotsize=0.15) + ylim(c(-20,150)) +
  stat_summary(fun.data = "mean_sdl", mult=1, geom="pointrange") +
  theme(text = element_text(size=16)) + ylim(c(-20,150)) 
p6 + labs(x="Schaefer Networks", y="irsMSSD Relative % Contribution") + scale_x_discrete(labels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) + theme(legend.position = "none") 
ggsave("irsMSSD_RelativeContributionPercent.png",width = 11, height = 6, dpi = 300)

## Write csv
rearranged_fstats <- round(rearranged_fstats,2)
write.csv(rearranged_fstats, file = "Rearr_Fstats_pernode.csv")

rearranged_dapercentcontrib <- round(rearranged_dapercentcontrib,2)
write.csv(rearranged_dapercentcontrib, file = "Rearr_DApercentcontrib_pernode.csv")