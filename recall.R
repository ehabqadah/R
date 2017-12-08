
# Load the data 
resultsDir<-"./data/msi_19/100_2.0_0.8_part"
fullSyncDir<-"./data/msi_19/100_2.0_0.8_part/100_2.0_0.8_part/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")

# Create list of the models
models<-list(static,dynamic,isolated,full_sync)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- rainbow(numberOfModels)
lineTypes <- c(1,1,1,1)
lineWidths<- c(2.5,2.5,2.5,2.5)
plotChars <- c(16,18,15,17)

png(file="graphic.png",width=390,height=390,bg = "transparent")
par()              # view current settings
opar <- par()      # make a copy of current settings
#par(mar=c(5,5,5,5))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(1,1000000))
yrange<-range(isolated$cumulativeError/isolated$numberOfPredictors)

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# predictions",font=3,cex=1.5),ylab = list("commutative error",font=3,cex=1.5))


for (i in 1:numberOfModels) {
  
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
