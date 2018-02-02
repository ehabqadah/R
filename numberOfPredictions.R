
# Load the data 
#resultsDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE/old/100_2.0_0.8_old/"
#fullSyncDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE/old/1_2.0_0.8_old/"
resultsDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE_N/100_2.0_0.8_20/"
fullSyncDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE_N/100_2.0_0.8_20/"

isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")

#full_sync<-subset(full_sync,full_sync$numberOfPredictors > 660)
#dynamic <- subset(dynamic,dynamic$numberOfPredictors > 600)
#static <- subset(static,static$numberOfPredictors > 600)
#isolated <- subset(isolated,isolated$numberOfPredictors > 600)
summary(static$totalNumberOfPredictions)
sampleStep<-1000

isolatedSmapled <- isolated[seq(1, nrow(isolated), sampleStep),]
staticSampled <- static[seq(1, nrow(static), sampleStep),]
dynamicSmapled <- dynamic[seq(1, nrow(dynamic), sampleStep),]
full_syncSampled <- full_sync[seq(1, nrow(full_sync), 100*sampleStep),]

models<-list(staticSampled,dynamicSmapled,isolatedSmapled,full_syncSampled)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- rainbow(numberOfModels)

lineTypes <- c(1,3,4,6)
lineWidths<- c(1.5,1.5,1.5,1.5)
plotChars <- c(3,1,8,17)

png(file="graphic.png",width=450,height=450,pointsize = 11)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,0,5))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,max(full_sync$numberOfInputEvents)))
yrange<-range(c(0,max(full_sync$totalNumberOfPredictions)))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.8),ylab = list("precision",font=2,cex=1.8),font.axis=2,font=2,cex.axis=1.2)


for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents, models[[i]]$totalNumberOfPredictions , type="l", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
  print(modelNames[i])
  print(summary(models[[i]]$recall))
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)
settings
#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(140000, yrange[2] , c("static","dynamic","isolated","full-sync"),text.font=2, cex=1.2, col=colors, lty=lineTypes,lwd=2.5,pch=plotChars)

options(opt)

par(opar)          # restore original settings
dev.off()


