
colors <- colors <-c("skyblue2","tomato4")

lineTypes <- c(1,4)
lineWidths<- c(4.5,1.5)
plotChars <- c(1,8)

png(file = "temp.png", width = 4000, height = 4000, units = "px", res = 800)

par()              # view current settings
opar <- par()      # make a copy of current settings
par(mar=c(5,5,2,2))
getOption("scipen")

opt <- options("scipen" = 20)
getOption("scipen")

xrange<-range(c(0,90))


x<-c(8,16,24,32,40,48,56,72,80)
y<- 4684445.0 / c(190*60,69*60,59*60,49*60,46*60,44*60,42.5*60,39*60,37*60)
#y<-c(0)
#x<-c(0)
yrange<-range(c(0,max(y)+100))

#yrange <-range(c(0,20000,40000,60000,80000,100000,12000,140000))

# Define the layout 
plot(xrange,yrange,type="n",yaxt = "n",mgp = c(3.5, 1, 0),xlab = list("parallelism",font=2,cex=1.2),ylab = list("throughput (event/second)",font=2,cex=1.2),font.axis=2,font=2,cex.axis=.8)

yrange <-c(0,200,400,600,800,1000,1200,1400,1600,1800,2000,2200)
axis(2, at = yrange, labels = formatC(yrange, big.mark = ",", format = "d"),
     las = 2,font.axis=1.2,font=2,cex.axis=.8)

i<-1

lines(x , y , type="b", lwd=lineWidths[i],
      lty=lineTypes[i], col=colors[i], pch=plotChars[i])


options(opt)

par(opar)          # restore original settings
dev.off()
