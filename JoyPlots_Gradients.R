rm(list=ls())

# install.packages("ggridges")
# install.packages("cowplot")
# install.packages("colormap")
# install.packages("plotrix")

library("ggplot2")
library("ggridges")
library("viridis")
library("cowplot")
library("colormap")
library("plotrix")

library(R.matlab)

cmap <- c( "#781286", "#4682B4", "#00760E", "#C43AFA", "#DCF8A4", "#E69422", "#CD3E4E")

# Produce plots for principle gradient   
# Young Subjects
data <- readMat("Rearr_Gradient1_young_fcmssd.mat")
GradientScore <- data$rearranged.gradient1

networks <- c(rep("Visual",29), rep("Somatomotor",35), rep("Dan",26), rep("Van",22), rep("Limbic",12), rep("Control",30), rep("Default",46)) 
networks <- as.factor(networks)

young_principalgradient_yeo <- cbind(GradientScore,networks)
young_principalgradient_yeo <- as.data.frame(young_principalgradient_yeo)

colnames(young_principalgradient_yeo) <- c("GradientScore", "Network")
young_principalgradient_yeo$Network <- as.factor(young_principalgradient_yeo$Network)

levels(young_principalgradient_yeo$Network) <- c("Control", "Dan", "Default", "Limbic", "Somatomotor", "Van", "Visual")
young_principalgradient_yeo$Network <- factor(young_principalgradient_yeo$Network, levels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default"))


ggplot(young_principalgradient_yeo, aes(x=GradientScore, y=Network, fill=Network)) +
  geom_density_ridges_gradient(quantile_lines = TRUE, quantiles = 2, scale=1.5, rel_min_height=0.01, show.legend = TRUE) +
  scale_fill_manual(aesthetics = "fill", values = cmap) +
  scale_x_continuous(limits=c(-0.09, 0.09)) +
  scale_y_discrete(expand = c(0.01, 0)) +
  theme_minimal() + 
  theme(axis.line = element_line(colour = 'black'),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text = element_text(size=20, family="Times New Roman"),
        text = element_text(size = 20))

###########################################################################################

rm(list=ls())

# install.packages("ggridges")
# install.packages("cowplot")
# install.packages("colormap")
# install.packages("plotrix")

library("ggplot2")
library("ggridges")
library("viridis")
library("cowplot")
library("colormap")
library("plotrix")

library(R.matlab)

cmap <- c( "#781286", "#4682B4", "#00760E", "#C43AFA", "#DCF8A4", "#E69422", "#CD3E4E")

# Produce plots for principle gradient   
# Young Subjects
data <- readMat("Rearr_Gradient2_young_fcmssd.mat")
GradientScore <- data$rearranged.gradient2

networks <- c(rep("Visual",29), rep("Somatomotor",35), rep("Dan",26), rep("Van",22), rep("Limbic",12), rep("Control",30), rep("Default",46)) 
networks <- as.factor(networks)

young_principalgradient_yeo <- cbind(GradientScore,networks)
young_principalgradient_yeo <- as.data.frame(young_principalgradient_yeo)

colnames(young_principalgradient_yeo) <- c("GradientScore", "Network")
young_principalgradient_yeo$Network <- as.factor(young_principalgradient_yeo$Network)

levels(young_principalgradient_yeo$Network) <- c("Control", "Dan", "Default", "Limbic", "Somatomotor", "Van", "Visual")
young_principalgradient_yeo$Network <- factor(young_principalgradient_yeo$Network, levels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default"))


ggplot(young_principalgradient_yeo, aes(x=GradientScore, y=Network, fill=Network)) +
  geom_density_ridges_gradient(quantile_lines = TRUE, quantiles = 2, scale=1.5, rel_min_height=0.01, show.legend = TRUE) +
  scale_fill_manual(aesthetics = "fill", values = cmap) +
  scale_x_continuous(limits=c(-0.09, 0.09)) +
  scale_y_discrete(expand = c(0.01, 0)) +
  theme_minimal() + 
  theme(axis.line = element_line(colour = 'black'),
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text = element_text(size=20, family="Times New Roman"),
        text = element_text(size = 20))

