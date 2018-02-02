df <- data.frame(id=c(0,1,2,3,4,5), min=c(4,2,3,3,4,1), max=c(15,5,14,14,15,1))
library(ggplot2)
ggplot(df, aes(x=id))+
  geom_linerange(aes(ymin=min,ymax=max),linetype=2,color="blue")+
  geom_point(aes(y=min),size=3,color="red")+
  geom_point(aes(y=max),size=3,color="red")+
  theme_bw()+
  theme(plot.margin = unit(c(1, 1, 1, 1), "cm"),axis.text=element_text(size=16,color = "black",face = "bold"),axis.title = element_text(size=23,color = "black",face = "bold"))+xlab("State #")+ylab(" Prediction interval (I)")

