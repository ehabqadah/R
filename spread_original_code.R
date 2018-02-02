

# Load the data 

isolated <- read.csv("/home/ehabqadah/scala-workspace/original/Wayeb-orginal/results/validation/res.csv", header = TRUE, sep = ",")
models<-list(isolated)
modelNames<-c("isolated")
numberOfModels<-length(models)
colors <- c("gray10","skyblue2","tomato4","tan3")

lineTypes <- c(1,3,4,6)
lineWidths<- c(2.5,2.5,2.5,2.5)
plotChars <- c(3,1,8,17)
#bg = "transparent"
png(file="precision_scala.png",width=850,height=850,pointsize = 11)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")
opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,3000))#max(isolated$predictionsNo)))
yrange<-range(c(0,max(isolated$avgSpread)))

# Define the layout 
plot(xrange,yrange,type="n",xlab = list("# events",font=2,cex=1.8),ylab = list("precision",font=2,cex=1.8),font.axis=2,font=2,cex.axis=1.2)

i <- 1
for (i in 1:numberOfModels) {
  
  lines(models[[i]]$predictionsNo, models[[i]]$avgSpread , type="l", lwd=lineWidths[i],
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
legend(2000000, yrange[2] , c("static","dynamic","isolated","full-sync"),text.font=2, cex=1.2, col=colors, lty=lineTypes,lwd=2.5,pch=plotChars)

options(opt)

par(opar)          # restore original settings
dev.off()