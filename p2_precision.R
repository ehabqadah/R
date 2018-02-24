
# Load the data 
resultsDir<-"/home/ehabqadah/hdd2/Data/BDMA_paper/pattern2/Pleasure_craft/100_2.0_0.8_200/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")


isolatedSmapled <- rbind(isolated[1:2,], isolated[seq(4, nrow(isolated),25),])
dynamicSmapled <-rbind(dynamic[1:3,], dynamic[seq(4, nrow(dynamic),25),])
models<-list(dynamicSmapled,isolatedSmapled)

modelNames<-c("dynamic","isolated")
numberOfModels<-length(models)
colors <- colors <-c("skyblue2","tomato4")

lineTypes <- c(3,4)
lineWidths<- c(4.2,4.2,4.2,4.2)
plotChars <- c(1,8)
#bg = "transparent"
png(file="precision_p2.png",bg = "transparent",width=750,height=750,pointsize = 14)

par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")

opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,100000))
yrange<-range(c(0,1))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=2.3),ylab = list("precision",font=2,cex=2.3),font.axis=2,font=2,cex.axis=1.2)


for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents , models[[i]]$averagePrecision , type="b", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
  print(modelNames[i])
  print(summary(models[[i]]$recall))
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
maxSpread<-strsplit(resultsDir, "_")[[1]]
maxSpread<-maxSpread[[length(maxSpread)]]
settings<- paste0("b = ",batchS,", varinace = ",varinaceThreshold, ",  p_c=",predictionThreshold, " max_sp = ",maxSpread)
#title(main=list("Preceision Scores",font=3,cex=1.5),sub= settings )
legend(55000, yrange[2] , c("dynamic","isolated"),text.font=2, cex=1.8, col=colors, lty=lineTypes,lwd=3.2,pch=plotChars)

options(opt)

par(opar)          # restore original settings
dev.off()

