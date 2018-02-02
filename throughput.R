


colors <- colors <-c("skyblue2","tomato4")

lineTypes <- c(1,4)
lineWidths<- c(2.5,1.5)
plotChars <- c(1,8)

png(file="throughput.png",width=450,height=420,bg = "transparent",pointsize = 13)
par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,4))
getOption("scipen")

opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,85))



x<-c(8,16,24,32,40,48,56,72,80)
y<- 8651176.0 / c(45,25,21,17.5,16,15,14,12,11)

yrange<-range(c(0,max(y)+1000))





# Define the layout 
plot(xrange,yrange,type="n",yaxt = "n",xlab = list("parallelism",font=2,cex=1.8),ylab = list("messages/minute",font=2,cex=1.8),font.axis=2,font=2,cex.axis=1.2)

yrange<-c(0,200000,400000,600000,800000)
axis(2, at = yrange, labels = formatC(yrange, big.mark = ",", format = "d"),
     las = 3,font.axis=2,font=2,cex.axis=1.2)

  i<-1
  
  lines(x , y , type="b", lwd=lineWidths[i],
        lty=lineTypes[i], col=colors[i], pch=plotChars[i])




options(opt)

par(opar)          # restore original settings
dev.off()

