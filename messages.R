
# Load the data 
resultsDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE/old/100_2.0_0.8_old/"
fullSyncDir<-"/opt/datAcron/experiments/msi_19/summary/ALL_SAME_TYPE/old/1_2.0_0.8_old/"

isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
static <- read.csv(paste0(resultsDir,"distributedStatic.csv"), header = TRUE, sep = ",")
full_sync <- read.csv(paste0(fullSyncDir,"distributedStatic.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")


isolatedSmapled <-  rbind(isolated[1:3,], isolated[seq(4, nrow(isolated),1000),])
staticSampled <-  rbind(static[1:2,], static[seq(4, nrow(static),1000),])
dynamicSmapled <- rbind(dynamic[1:3,], dynamic[seq(4, nrow(dynamic),1000),])
full_syncSampled <- rbind(full_sync[1:10,], full_sync[seq(10, nrow(full_sync),150000),])

models<-list(staticSampled,dynamicSmapled,isolatedSmapled,full_syncSampled)
modelNames<-c("static","dynamic","isolated","full-sync")
numberOfModels<-length(models)
colors <- c("gray10","skyblue2","tomato4","tan3")

lineTypes <- c(1,3,4,6)
lineWidths<- c(4.2,4.2,4.2,4.2)
plotChars <- c(0,1,8,25)
#bg = "transparent"
png(file="messages_new.png",bg = "transparent",width=750,height=750,pointsize = 14)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")
         

xrange<-range(c(0,max(static$numberOfInputEvents)))

yrange<-range(c(1,max(log10(full_sync$numberOfMessages))))

# Define the layout 
plot(xrange,yrange,type="n",yaxt="n",xlab = list("# events",font=2,cex=2.3),ylab = list("# messages",font=2,cex=2.3),font.axis=2,font=2,cex.axis=1.2)
aty <- axTicks(2)
labels <- sapply(aty,function(i)
  as.expression(bquote(10^ .(i)))
)
axis(2,at=aty,labels=labels)

for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents, log10(models[[i]]$numberOfMessages), type="b", lwd=3.2,
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
settings<- paste0("batch size =",batchS,", varinace threshold=",varinaceThreshold, ", and  prediction threshold=",predictionThreshold)

#title(main=list("Preceision Scores",font=3,cex=2.5),sub= "" )
legend(2400000, yrange[2] -6, modelNames,text.font=2, cex=1.8, col=colors, lty=lineTypes,lwd=3.2,pch=plotChars)

options(opt)
par(opar)          # restore original settings
dev.off()

