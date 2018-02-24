

# Load the data 

#resultsDir <- "/opt/datAcron/ref_experiments/msi_new_exps/adc/summary/SyntheticEvents/20_1.0E-4_0.5_10/"
resultsDir <- "/opt/datAcron/ref_experiments/msi_new_exps_tmp/synthetic/summary/SyntheticEvents/20_0.001_0.5_10/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")



# models<-list(staticSampled,dynamicSmapled,isolatedSmapled,full_syncSampled)
models<-list(static,dynamic,isolated)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- c("gray10","skyblue2","tomato4","tan3")

lineTypes <- c(1,3,4,6)
lineWidths<- c(2.5,2.5,2.5,2.5)
plotChars <- c(3,1,8,17)
#bg = "transparent"
png(file="variance_synthetic.png",width=850,height=850,pointsize = 11)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,max(static$numberOfInputEvents)))
yrange<-range(c(0,max(isolated$probEstimationError)))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.8),ylab = list("precision",font=2,cex=1.8),font.axis=2,font=2,cex.axis=1.2)


for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents, models[[i]]$probEstimationError , type="l", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
}

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

