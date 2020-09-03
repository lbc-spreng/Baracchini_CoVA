rm(list=ls())

# use devtools to install superheat
#devtools::install_github("rlbarter/superheat")
devtools::install_github("mychan24/superheat")
library(superheat)
library(R.matlab)
library(RColorBrewer)

setwd("/Users/giulia/Desktop")
data <- readMat("Rearranged_correlation_matrix_fc_zmssd_run1_young_reversed.mat")
label <- read.csv("Network_order_rearranged.csv",header = FALSE, sep = ,)

mat <- data$rearranged.corr
mat <- as.data.frame(mat)

colnames(mat) <- t(label)
rownames(mat) <- t(label)

#assign 1 perf correlation to diagonal
diag(mat) <- 1

networks <- c(rep("Visual",29), rep("Somatomotor",35), rep("Dan",26), rep("Van",22), rep("Limbic",12), rep("Control",30), rep("Default",46)) 
networks <- as.factor(networks)
networks <- factor(networks, levels = unique(networks))

# average r in each gear cluster
#TOT FC pos and neg
within <- c(0.0804,0.1356,0.1170,0.0951,0.0753,0.0508,0.0837)
between <- c(0.00017,0.0274,0.0212,0.0328,0.0218,0.0188,0.0236)

pal <- rev(brewer.pal(5,"RdBu"))

png("superheat_unperm_corr_FC-MSSD_run1_young_reversed.png", height = 900, width = 800, units='mm', res=500)
superheat(mat, membership.rows = networks, membership.cols = networks, heat.lim = c(-0.2,0.2),
          yr = within, yr.plot.type = 'bar', yr.lim = c(0, 0.14),
          yt = between, yt.plot.type = 'bar', yt.lim = c(0, 0.14),
          extreme.values.na = F,
          grid.hline.col = "white", 
          grid.vline.col = "white",bottom.label.text.angle = 90,
          heat.pal = pal, heat.pal.values = c(0, 0.5, 1),
          left.label.text.size = 20,
          bottom.label.text.size = 20,
          yt.axis.size = 40,
          yt.axis.name.size = 40,
          yr.axis.size = 40,
          yr.axis.name.size = 40)
dev.off()

## Only significant
only_sign <- readMat("only_sign_rearr_corr_fc_mssd_run1_young_reversed.mat")
only_sign <- only_sign$only.sign.rearr.corr.fc.mssd
only_sign <- as.matrix(only_sign)

colnames(only_sign) <- t(label)
rownames(only_sign) <- t(label)

#assign 1 perf correlation to diagonal
diag(only_sign) <- 1

#TOT FC
within_significant <- c(0.0595,0.1052,0.0837, 0.0736, 0.0536, 0.0409, 0.0600)
between_significant <- c(0.0053, 0.0208, 0.0170, 0.0221, 0.0151, 0.0158, 0.0154)

png("superheat_onlysign_corr_FC-MSSD_run1_young_reversed.png", height = 900, width = 800, units='mm', res=500)
superheat(only_sign, membership.rows = networks, membership.cols = networks, heat.lim = c(-0.2,0.2),
          yr = within_significant, yr.plot.type = 'bar', yr.lim = c(0, 0.14), 
          yt = between_significant, yt.plot.type = 'bar', yt.lim = c(0, 0.14),
          extreme.values.na = F,
          grid.hline.col = "white", 
          grid.vline.col = "white",bottom.label.text.angle = 90,
          heat.pal = pal, heat.pal.values = c(0, 0.5, 1),
          left.label.text.size = 20,
          bottom.label.text.size = 20,
          yt.axis.size = 40,
          yt.axis.name.size = 40,
          yr.axis.size = 40,
          yr.axis.name.size = 40)
dev.off()
