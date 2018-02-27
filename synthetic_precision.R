
library(ggplot2)

# Load the data 

#resultsDir <- "/opt/datAcron/ref_experiments/msi_new_exps_tmp/synthetic/summary/SyntheticEvents/15_1.0E-4_0.5_10/"
#fullSyncDir <- "/opt/datAcron/ref_experiments/msi_new_exps_tmp/synthetic/summary/SyntheticEvents/1_1.0E-4_0.5_10/"

resultsDir <- "/opt/datAcron/ref_experiments/msi_new_exps_distance_last/synthetic/summary/SyntheticEvents/20_1.0E-4_0.5_10/"
fullSyncDir <- "/opt/datAcron/ref_experiments/msi_new_exps_distance/synthetic/summary/SyntheticEvents/1_1.0E-4_0.5_10/"

#resultsDir<-"/opt/datAcron/ref_experiments/msi_new_exps_distance/speed/summary/ALL_SAME_TYPE_N/100_2.0_0.8_205/"
#fullSyncDir<-"/opt/datAcron/ref_experiments/msi_new_exps_distance/speed/summary/ALL_SAME_TYPE_N/100_2.0_0.8_205/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")

static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")


sampleSize<- 50
isolatedSmapled <- isolated[seq(1, nrow(isolated),sampleSize),]
staticSampled <-   static[seq(1, nrow(static),sampleSize),]
dynamicSmapled <-  dynamic[seq(1, nrow(dynamic),sampleSize),]
full_syncSampled <- full_sync[seq(1, nrow(full_sync),sampleSize),]

sampledModels<-list(staticSampled,dynamicSmapled,isolatedSmapled,full_syncSampled)
models<-list(static,dynamic,isolated,full_sync)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- c("gray10","skyblue2","tomato4","tan3")

lineTypes <- c(1,3,4,6)
lineWidths<- c(1.8,1.8,1.8,1.8)
plotChars <- c(0,1,8,25)
#bg = "transparent"
png(file="precision_synthetic.png",width = 4000, height = 4000, units = "px", res = 800)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(4.5,4.5,2,2))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,max(static$numberOfInputEvents)))
yrange<-range(c(0,2))

#yrange<-range(c(0,max(isolated$probEstimationError)))

#yTitle <-"precision"
#yTitle <- "PS - score"
#yTitle <- "spread"
#yTitle <- "estimation error of probabilities"
yTitle <-"distance"
# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.2),ylab = list(yTitle,font=2,cex=1.2),font.axis=2,font=2,cex.axis=.7)

alph <- .5
maxSpread <- 1/100

for (i in 1:numberOfModels) {
  
  normalScore <- models[[i]]$averagePrecision
  spreadFactor <-  1- ( models[[i]]$averageSpread * maxSpread)
  newScore <- alph  * models[[i]]$averagePrecision + (1- alph) * spreadFactor 
  error<- models[[i]]$probEstimationError
  
  lines(models[[i]]$numberOfInputEvents,  models[[i]]$averageDistance, type="l", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
  #sampled points
  spreadFactorSampled <- 1- ( sampledModels[[i]]$averageSpread * maxSpread)
  newScoreSampled <- alph  * sampledModels[[i]]$averagePrecision + (1- alph) * spreadFactorSampled
  errorSampled<- sampledModels[[i]]$probEstimationError
  
  points(sampledModels[[i]]$numberOfInputEvents,  sampledModels[[i]]$averageDistance , lwd=1.8,
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)
settings
#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(3200000, yrange[2]-.05 , modelNames,text.font=2, cex=.8, col=colors, lty=lineTypes,lwd=2.2,pch=plotChars)

options(opt)

par(opar)          # restore original settings
dev.off()

