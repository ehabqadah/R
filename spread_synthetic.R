
# Load the data 

resultsDir <- "/opt/datAcron/ref_experiments/msi_new_exps/adc/summary/SyntheticEvents/20_1.0E-4_0.5_10/"

isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
#full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")

models<-list(static,dynamic,isolated)

modelNames<-c("static","dynamic","isolated")
numberOfModels<-length(models)
colors <-c("gray10","skyblue2","tomato4","tan3")
lineTypes <- c(1,3,4,6)
lineWidths<- c(1.5,2.9,1.5,1.5)
plotChars <- c(3,1,8,17)

png(file="spread_synthetic.png",width=450,height=450,pointsize = 12)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,0,5))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")




xrange<-range(c(0, 5000))#max(static$numberOfInputEvents)))

yrange<-range(c(0,10))

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
settings<- paste0("b = ",batchS,", varinace = ",varinaceThreshold, ",  p_c=",predictionThreshold, " max_sp = ")
title(main=list("Preceision Scores",font=3,cex=1.5),sub= settings )
legend(20000, yrange[2] -60, modelNames,text.font=2, cex=1.2, col=colors, lty=lineTypes,lwd=2.5,pch=plotChars)

options(opt)
par(opar)          # restore original settings
dev.off()

