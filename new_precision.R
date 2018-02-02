
# Load the data 

#resultsDir<-"/home/ehabqadah/hdd2/Data/BDMA_paper/pattern1/ALL/100_2.0_0.8_200/"
#fullSyncDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE/old/1_2.0_0.8_old/"
#resultsDir <- "/opt/datAcron/ref_experiments/msi_19/summary/ALL_SAME_TYPE_N/100_2.0_0.8_200/"
#resultsDir <- "/opt/datAcron/ref_experiments/msi_new_exps/msi_19/summary/ALL_SAME_TYPE_N/100_2.0_0.8_200/"
resultsDir<-"/home/ehabqadah/hdd2/Data/BDMA_paper/pattern1/ALL/100_2.0_0.8_200/"

isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")

 isolated$averageSpread=isolated$averageSpread/isolated$numberOfPredictors
 static$averageSpread=static$averageSpread/static$numberOfPredictors
 dynamic$averageSpread=dynamic$averageSpread/dynamic$numberOfPredictors
 full_sync$averageSpread=full_sync$averageSpread/full_sync$numberOfPredictors

isolatedSmapled <-  rbind(isolated[1:3,], isolated[seq(4, nrow(isolated),10),])
# staticSampled <-  rbind(static[1:3,], static[seq(4, nrow(static),1000),])
# dynamicSmapled <- rbind(dynamic[1:3,], dynamic[seq(4, nrow(dynamic),1000),])
# 
# full_syncSampled <- rbind(full_sync[1:1000,], full_sync[seq(1001, nrow(full_sync),150000),])
# 
# models<-list(staticSampled,dynamicSmapled,isolatedSmapled,full_syncSampled)
models<-list(static,dynamic,isolated)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- c("gray10","skyblue2","tomato4","tan3")

lineTypes <- c(1,3,4,6)
lineWidths<- c(2.5,2.5,2.5,2.5)
plotChars <- c(3,1,8,17)
#bg = "transparent"
png(file="new_precision.png",width=850,height=850,pointsize = 11)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,600000))#max(static$numberOfInputEvents)))
yrange<-range(c(0,1))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.8),ylab = list("precision",font=2,cex=1.8),font.axis=2,font=2,cex.axis=1.2)

max(isolated$totalNumberOfPredictions)
alph <- .5
maxSpread <- 1/100.0

for (i in 1:numberOfModels) {
  spreadFactor <- 1- ( models[[i]]$averageSpread * maxSpread)
  newScore <- alph  * models[[i]]$averagePrecision + (1- alph) * spreadFactor
    
  lines(models[[i]]$numberOfInputEvents, newScore , type="l", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
  
}
#points(isolatedSmapled$numberOfInputEvents,isolatedSmapled$averagePrecision, bg='tomato2', pch=8, cex=1.5, lwd=1.5)
# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)
settings
#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(2000000, yrange[2] , c("static","dynamic","isolated","full-sync"),text.font=2, cex=1.2, col=colors, lty=lineTypes,lwd=2.5,pch=plotChars)

options(opt)

par(opar)          # restore original settings
dev.off()

