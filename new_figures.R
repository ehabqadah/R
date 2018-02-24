
library(ggplot2)

# Load the data 

resultsDir<-"/home/ehabqadah/hdd2/Data/BDMA_paper/pattern1/ALL/100_2.0_0.8_old/"
fullSyncDir<-"/home/ehabqadah/hdd2/Data/BDMA_paper/pattern1/ALL/1_2.0_0.8_old/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")

static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"new_full_sync.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")

# normalize the spread
isolated$averageSpread=isolated$averageSpread/isolated$numberOfPredictors
static$averageSpread=static$averageSpread/static$numberOfPredictors
dynamic$averageSpread=dynamic$averageSpread/dynamic$numberOfPredictors
full_sync$averageSpread=full_sync$averageSpread/full_sync$numberOfPredictors

sampleSize<- 1000
isolatedSmapled <- isolated[seq(1, nrow(isolated),sampleSize),]
staticSampled <-   static[seq(1, nrow(static),sampleSize),]
dynamicSmapled <-  dynamic[seq(1, nrow(dynamic),sampleSize),]
full_syncSampled <- rbind(full_sync[1:1000,], full_sync[seq(1001, nrow(full_sync),200000),])

sampledModels<-list(staticSampled,dynamicSmapled,isolatedSmapled,full_syncSampled)
models<-list(static,dynamic,isolated,full_sync)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- c("gray10","skyblue2","tomato4","tan3")

lineTypes <- c(1,3,4,6)
lineWidths<- c(4.2,4.2,4.2,4.2)
plotChars <- c(0,1,8,25)
#bg = "transparent"
png(file="precision_new.png",bg = "transparent",width=750,height=750,pointsize = 14)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0, 200000 ))#max(static$numberOfInputEvents)))
yrange<-range(c(.4,.8))


yTitle <- " precision + spread score"
#yTitle <- "average spread"

#yTitle <- " precision"
# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=2.3),ylab = list(yTitle,font=2,cex=2.3),font.axis=2,font=2,cex.axis=1.2)


alph <- .5
maxSpread <- 1/200

for (i in 1:numberOfModels) {
  
  normalScore <- models[[i]]$averagePrecision
  
  spreadFactor <- 1- ( models[[i]]$averageSpread * maxSpread)
  newScore <- alph  * models[[i]]$averagePrecision + (1- alph) * spreadFactor

  
  lines(models[[i]]$numberOfInputEvents, newScore , type="l", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
  #sampled points
  normalScoreSampled <- sampledModels[[i]]$averagePrecision
  spreadFactorSampled <- 1- ( sampledModels[[i]]$averageSpread * maxSpread)
  newScoreSampled <- alph  * sampledModels[[i]]$averagePrecision + (1- alph) * spreadFactorSampled

  
   points(sampledModels[[i]]$numberOfInputEvents,  newScoreSampled , lwd=3.2,
          lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)
settings
#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(3000000, yrange[2] , modelNames,text.font=2, cex=1.8, col=colors, lty=lineTypes,lwd=3.2,pch=plotChars)

options(opt)

par(opar)          # restore original settings
dev.off()

