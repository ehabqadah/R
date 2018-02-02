
# Load the data 
resultsDir<-"/opt/datAcron/experiments/p1/summary/ALL_SAME_TYPE_UNIFORM/100_2.0_0.8_200/"
fullSyncDir<-"/opt/datAcron/experiments/p1/summary/ALL_SAME_TYPE_UNIFORM/100_2.0_0.8_200/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")

#Filter only records with modelSynced vaule is true
static<-subset(static, static$modelSynced=="true")
dynamic<-subset(dynamic, dynamic$modelSynced=="true")
full_sync<-subset(full_sync, full_sync$modelSynced=="true")

sampleStep<-1000

# isolatedSmapled <- isolated[seq(1, nrow(isolated), sampleStep),]
# staticSampled <- rbind(static[1:99,], static[seq(100, nrow(static), 100),])
# dynamicSmapled <-rbind(dynamic[1:99,], dynamic[seq(100, nrow(dynamic),sampleStep),])
# full_syncSampled <-rbind(full_sync[1:20,], full_sync[seq(20, nrow(full_sync), 100*sampleStep),])

models<-list(static,dynamic,isolated,full_sync)

modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <-c("gray10","skyblue2","tomato4","tan3")
lineTypes <- c(1,3,4,6)
lineWidths<- c(1.5,1.5,1.5,1.5)
plotChars <- c(3,1,8,17)

png(file="graphic.png",width=450,height=450,bg = "transparent",pointsize = 11)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,0,5))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")


xrange<-range(c(0,max(full_sync$numberOfInputEvents)))

yrange<-range(c(0,max(full_sync$numberOfMessages/full_sync$numberOfPredictors)))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.8),ylab = list("# messages",font=2,cex=1.8),font.axis=2,font=2,cex.axis=1.2)


for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents, models[[i]]$numberOfMessages/models[[i]]$numberOfPredictors , type="b", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)

#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(2400, yrange[2] -6, modelNames,text.font=2, cex=1.2, col=colors, lty=lineTypes,lwd=2.5,pch=plotChars)

options(opt)
par(opar)          # restore original settings
dev.off()

