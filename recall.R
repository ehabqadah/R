
# Load the data 
resultsDir<-"/opt/datAcron/experiments/p1/summary/ALL_SAME_TYPE/101_2.0_0.8/"
fullSyncDir<-"/opt/datAcron/experiments/p1/summary/ALL_SAME_TYPE/101_2.0_0.8/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")

# Create list of the models
models<-list(static,dynamic,isolated,full_sync)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- rainbow(numberOfModels)
lineTypes <- c(1,3,4,6)
lineWidths<- c(1.5,1.5,1.5,1.5)
plotChars <- c(16,18,15,17)

png(file="graphic.png",width=390,height=390,bg = "transparent")
par()              # view current settings
opar <- par()      # make a copy of current settings
#par(mar=c(5,5,5,5))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xxrange<-range(full_sync$numberOfInputEvents)
yrange<-range(c(0,1))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# predictions",font=3,cex=1.5),ylab = list("commutative error",font=3,cex=1.5))


for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents, models[[i]]$recall , type="l", lwd=lineWidths[i],
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
legend(140000, yrange[2] , modelNames,text.font=2, cex=.8, col=colors, lty=lineTypes,lwd=2.5)

options(opt)

par(opar)          # restore original settings
dev.off()
