library(ggplot2)
library(reshape2)

barChart <- function(resultTable, techniques, nbTechs = -1, ymin, ymax, xAxisLabel = "I am the X axis", yAxisLabel = "I am the Y Label"){
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
  # if (nbTechs > 0 && ymin >= 0) {
  #   g <- g + geom_bar(aes(fill=technique),stat="identity",show.legend = F, color="NA")
  #   g <- g + scale_fill_manual(values = c("#DDDDDD", "#CCCCCC","#EEEEEE"))
  # }
  
  g <- g + geom_errorbar(aes(ymin=mean-CI1, ymax=mean+CI2),
                         width=0,                    # Width of the error bars
                         size = 1.1,
                         show.legend = F
  ) +
    labs(x = xAxisLabel, y = yAxisLabel) + 
    scale_y_continuous(limits = c(ymin,ymax)) +
    scale_x_discrete(name="",breaks,techniques)+
    coord_flip() +
    theme(panel.background = element_rect(fill = '#EEEEEE', colour = 'white'),
          axis.title=element_text(colour = "black"),
          axis.text.y=element_text(colour = "black",face = "italic"),
          panel.grid.major = element_line(colour = "#DDDDDD"),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(), 
          axis.ticks.length = unit(0, "lines"),
          panel.spacing = unit(0.5, "lines"),
          strip.background = element_rect(fill = "NA"),
          strip.placement = "outside",
          strip.text = element_text(face = "bold"),
          strip.text.y = element_text(angle = 180))

    g <- g + geom_point(size=3, show.legend = F) + scale_colour_manual(name = '', values = setNames(c('black','NA'),c(T, F)))

    
    if (length(unique(resultTable$facet)) > 1 ) {
      g <- g + facet_grid(task_name ~ facet, switch='y')
    }
    else {
    g <- g + facet_grid(task_name ~ ., switch='y')
    }
    
  
  return(g)
}