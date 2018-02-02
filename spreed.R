
# Load the data 
#resultsDir<-"/home/ehabqadah/hdd2/Data/BDMA_paper/pattern1/ALL/100_2.0_0.8_200/"
#fullSyncDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE/old/1_2.0_0.8_old/"
resultsDir <- "/opt/datAcron/ref_experiments/msi_new_exps/msi_19/summary/ALL_SAME_TYPE_N/100_2.0_0.8_25/"

isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
#full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")

# normalize the spread
# isolated$averageSpread=isolated$averageSpread/isolated$numberOfPredictors
# static$averageSpread=static$averageSpread/static$numberOfPredictors
# dynamic$averageSpread=dynamic$averageSpread/dynamic$numberOfPredictors
# full_sync$averageSpread=full_sync$averageSpread/full_sync$numberOfPredictors

# isolatedSmapled <-  rbind(isolated[1:3,], isolated[seq(4, nrow(isolated),1000),])
# staticSampled <-  rbind(static[1:3,], static[seq(4, nrow(static),1000),])
# dynamicSmapled <- rbind(dynamic[1:3,], dynamic[seq(4, nrow(dynamic),1000),])
# full_syncSampled <- rbind(full_sync[1:1000,], full_sync[seq(1001, nrow(full_sync),150000),])

#models<-list(staticSampled,dynamicSmapled,isolatedSmapled,full_syncSampled)
models<-list(static,dynamic,isolated)

modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <-c("gray10","skyblue2","tomato4","tan3")
lineTypes <- c(1,3,4,6)
lineWidths<- c(1.5,1.5,1.5,1.5)
plotChars <- c(3,1,8,17)

png(file="spread_p1.png",width=450,height=450,pointsize = 11)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")




xrange<-range(c(0,max(isolated$numberOfInputEvents)))

yrange<-range(c(0,20))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.8),ylab = list("average spread",font=2,cex=1.8),font.axis=2,font=2,cex.axis=1.2)


for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents, models[[i]]$averageSpread, type="l", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
}


# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)

#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(3000000, yrange[2] -2, modelNames,text.font=2, cex=1.2, col=colors, lty=lineTypes,lwd=2.5,pch=plotChars)

options(opt)
par(opar)          # restore original settings
dev.off()

