
png(file="intervals.png",bg = "transparent",width = 4000, height = 4000, units = "px", res = 800)

df <- data.frame(id=c(0,1,2,3,4,5), min=c(4,2,3,3,4,1), max=c(15,5,14,14,15,1))


#xrange<-range(c(0,5))
#yrange<-range(c(0,16))
#plot(xrange,yrange,type="n",xlab = list("# of future events",font=2,cex=.6),ylab = list("Completion probability",font=2,cex=.6),font.axis=2,font=2,cex.axis=1.2)


library(ggplot2)
ggplot(df, aes(x=id))+
  geom_linerange(aes(ymin=min,ymax=max),linetype=2,color="blue")+
  geom_point(aes(y=min),size=3,color="black")+
  geom_point(aes(y=max),size=3,color="black")+
  theme_bw()+
  theme(plot.margin = unit(c(.8, .8, .8, .8), "cm"),axis.text=element_text(size=10,color = "black",face = "bold"),axis.title = element_text(size=10,color = "black",face = "bold"))+xlab("State #")+ylab(" Prediction interval (I)")

dev.off()