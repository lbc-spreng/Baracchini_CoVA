rm(list=ls())
setwd("/Users/giulia/Desktop")

data <- read.csv("Rchange_hierarchicalregression.csv", header = TRUE, sep = ,) #NOT rearrange cause nii is not

## Generate nii for BrainNet
#install.packages("oro.nifti")
library(oro.nifti)

my.nii <- readNIfTI("Schaefer2018_200Parcels_7Networks_order_FSLMNI152_2mm.nii")

for (i in 1:200){
  my.nii[ my.nii == i ] <- data$Rchange_dist0[i]
}
writeNIfTI(my.nii, 'Schaefer_Rchange_diststr')

###
rm(list=ls()) #now reload in the dataframe above
library(oro.nifti)

my.nii <- readNIfTI("Schaefer2018_200Parcels_7Networks_order_FSLMNI152_2mm.nii")

for (i in 1:200){
  my.nii[ my.nii == i ] <- data$Rchange_01[i]
}
writeNIfTI(my.nii, 'Schaefer_Rchange_diststrmssd')

### Now create plots
rm(list=ls())
setwd("/Users/giulia/Desktop")

data <- read.csv("Rearrang_rchange.csv", header = TRUE, sep = ,) #NOT rearrange cause nii is not

library(ggplot2)
networks <- c(rep("Visual",29), rep("Somatomotor",35), rep("Dan",26), rep("Van",22), rep("Limbic",12), rep("Control",30), rep("Default",46))
networks <- as.factor(networks)
networks <- factor(networks, levels(networks)[c(7,5,2,6,4,1,3)])
index <- 1:200
data <- cbind(index,data$Rearranged_Rsq_dist0,data$Rearranged_Rsq_lm01, networks)
data <- as.data.frame(data)
colnames(data)[2] <- "Rchange_structure"
colnames(data)[3] <- "Rchange_mssd"
colnames(data)[1] <- "Schaefer_200_ROIs"

ggplot(data=data) + geom_point(mapping = aes(x=Schaefer_200_ROIs,y=Rchange_structure, color=as.factor(networks))) + geom_smooth(mapping=aes(x=Schaefer_200_ROIs,y=Rchange_structure)) + scale_colour_manual(values=c("#999999", "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00", "#CC79A7"), name="Networks", labels=c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) +
  xlab("Schaefer 200 nodes") + ylab("Rsquared change distance-structure") +  theme(text = element_text(size = 20)) + theme(axis.title = element_text(size = 20))
ggsave("Rchange_mssd.png",width = 11, height = 6, dpi = 300)

p<-ggplot(data, aes(x=as.factor(networks), y=Rchange_mssd, fill=as.factor(networks))) +
  geom_boxplot(fill="white") +
  geom_dotplot(binaxis='y', stackdir='center',binwidth=0.1, dotsize=0.08) +
  theme(text = element_text(size=16))
p + labs(x="Schaefer Networks", y="Rsquared change distance-structure-irsMSSD") + scale_x_discrete(labels = c("Visual", "Somatomotor", "Dan", "Van", "Limbic", "Control", "Default")) + theme(legend.position = "none")
ggsave("Rchange_mssd_networks.png",width = 11, height = 6, dpi = 300)

