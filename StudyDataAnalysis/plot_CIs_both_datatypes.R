library(ggplot2)
library(reshape2)

dualChart <- function(resultTable, techniques, nbTechs = -1, ymin, ymax, xAxisLabel = "I am the X axis", yAxisLabel = "I am the Y Label", vLineVal = 0){
  #tr <- t(resultTable)
  if(nbTechs <= 0){
    stop('Please give a positive number of Techniques, nbTechs');
  }
  
  tr <- as.data.frame(resultTable)
  nbTechs <- nbTechs - 1 ; # seq will generate nb+1
  
  #now need to calculate one number for the width of the interval
  tr$CI2 <- tr$upperBound_CI - tr$mean
  tr$CI1 <- tr$mean - tr$lowerBound_CI
  
  #add a technique column
  tr$technique <- factor(seq.int(0, nbTechs, 1));
  
  breaks <- c(as.character(tr$technique));
  # print(tr)
  g <- ggplot(tr, aes(x=technique, y=mean))

  g <- g + geom_errorbar(aes(ymin=mean-CI1, ymax=mean+CI2, color=datatype),
                         width=0,                    # Width of the error bars
                         size = 0.5,
                         show.legend = F, 
                         position=position_dodge(width=0.5))
  
  g <- g + geom_point(aes(color=datatype), size=2, show.legend = F, position=position_dodge(width=0.5))
  
  if (vLineVal >= ymin & vLineVal <= ymax){
    g <- g + geom_hline(aes(yintercept=vLineVal), colour="#666666", linetype = 2, size=0.5)
  }
  
  g <- g + scale_color_manual(values = c("#1F77B4", "#FF7F0E")) +
    labs(x = xAxisLabel, y = yAxisLabel) + 
    scale_y_continuous(limits = c(ymin,ymax)) +
    scale_x_discrete(name="",breaks,techniques)+
    coord_flip() +
    theme(panel.background = element_rect(fill = '#F5F5DC', colour = 'white'),
          axis.title=element_blank(),
          axis.text.y=element_text(colour = "black",face = "italic"),
          legend.title = element_blank(),
          legend.position = 'bottom',
          panel.grid.major = element_line(colour = "#DDDDDD"),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(), 
          axis.ticks.length = unit(0, "lines"),
          panel.spacing = unit(0.5, "lines"),
          strip.background = element_rect(fill = "NA"),
          strip.placement = "outside",
          strip.text = element_text(face = "bold",size=8),
          strip.text.y = element_text(angle = 180))

    if (length(unique(resultTable$facet)) > 1 ) {
      g <- g + facet_grid(task_name ~ facet, switch='y')
    }
    else {
    g <- g + facet_grid(task_name ~ ., switch='y')
    }
    
  
  return(g)
}