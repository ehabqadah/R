
# Load the data 
resultsDir<-"./data/msi_19/100_2.0_0.8_part"
fullSyncDir<-"./data/msi_19/100_2.0_0.8_part/100_2.0_0.8_part/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")

# Filter only records with modelSynced vaule is true
static<-subset(static, static$modelSynced=="true")
dynamic<-subset(dynamic, dynamic$modelSynced=="true")
full_sync<-subset(full_sync, full_sync$modelSynced=="true")

# Create list of the models
models<-list(static,dynamic,isolated,full_sync)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <-c("gray10","skyblue2","tomato4","tan3")
lineTypes <- c(1,1,1,1)
lineWidths<- c(1,1,1,1)
plotChars <- c(16,18,15,17)

png(file="graphic.png",width=390,height=390,bg = "transparent")
par()              # view current settings
opar <- par()      # make a copy of current settings
#par(mar=c(5,5,5,5))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(full_sync$numberOfInputEvents)
yrange<-range(log10(full_sync$numberOfMessages))
max(full_sync$numberOfMessages)
# Define the layout 
plot(xrange,yrange,type="n",yaxt="n",xlab = list("# events",font=3,cex=1.5),ylab = list("# messages",font=3,cex=1.5))
aty <- axTicks(2)
labels <- sapply(aty,function(i)
  as.expression(bquote(10^ .(i)))
)
axis(2,at=aty,labels=labels)

for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents, log10(models[[i]]$numberOfMessages), type="b", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)

#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(1400000, yrange[2] -1, modelNames,text.font=2, cex=.8, col=colors, lty=lineTypes,lwd=2.5)

options(opt)
par(opar)          # restore original settings
dev.off()
