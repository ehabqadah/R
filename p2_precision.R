
# Load the data 
resultsDir<-"/home/ehabqadah/hdd2/Data/BDMA_paper/pattern2/Pleasure_craft/100_2.0_0.8_200/"
isolated <- read.csv(paste0(resultsDir,"isolated.csv"), header = TRUE, sep = ",")
dynamic <- read.csv(paste0(resultsDir,"distributedDynamic.csv"), header = TRUE, sep = ",")


isolatedSmapled <- rbind(isolated[1:2,], isolated[seq(4, nrow(isolated),100),])
dynamicSmapled <-rbind(dynamic[1:3,], dynamic[seq(4, nrow(dynamic),100),])
sampledModels<-list(dynamicSmapled,isolatedSmapled)

models<-list(dynamic,isolated)

modelNames<-c("dynamic","isolated")
numberOfModels<-length(models)
colors <- colors <-c("skyblue2","tomato4")

lineTypes <- c(3,1)
lineWidths<- c(1.8,1.8,1.8,1.8)
plotChars <- c(1,8)

#bg = "transparent"
png(file="precision_p2.png",width = 4000, height = 4000, units = "px", res = 800)

par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")

opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,100000))
yrange<-range(c(0,1))

yTitle <-"precision"
# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.2),ylab = list(yTitle,font=2,cex=1.2),font.axis=2,font=2,cex.axis=.7)


for (i in 1:numberOfModels) {
  
  lines(models[[i]]$numberOfInputEvents , models[[i]]$averagePrecision , type="l", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
  points(sampledModels[[i]]$numberOfInputEvents,  sampledModels[[i]]$averagePrecision , lwd=1.8,
         lty=lineTypes[i], col=colors[i], pch=plotChars[i])
  
}

# Add the legend for the plot 
batchS<- models[[1]]$batchSize[[1]]
varinaceThreshold<- models[[1]]$varianceThreshold[[1]]
predictionThreshold<- models[[1]]$predictionThreshold[[1]]
maxSpread<-strsplit(resultsDir, "_")[[1]]
maxSpread<-maxSpread[[length(maxSpread)]]
settings<- paste0("b = ",batchS,", varinace = ",varinaceThreshold, ",  p_c=",predictionThreshold, " max_sp = ",maxSpread)
#title(main=list("Preceision Scores",font=3,cex=1.5),sub= settings )
legend(55000, yrange[2] , c("dynamic","isolated"),text.font=2, cex=.8, col=colors, lty=lineTypes,lwd=2.2,pch=plotChars)

options(opt)

par(opar)          # restore original settings
dev.off()

