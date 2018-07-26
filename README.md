# Visualizing Ranges Over Time on Mobile Phones

This repository contains supplemental material for the [IEEE InfoVis 2018](http://ieeevis.org/year/2018/info/papers) paper **[Visualizing Ranges over Time on Mobile Phones: A Task-Based Crowdsourced Evaluation](https://www.microsoft.com/en-us/research/publication/visualizing-ranges-over-time-on-mobile-phones-a-task-based-crowdsourced-evaluation/)** by [Matthew Brehmer (Microsoft Research)](mailto:mabrehme@microsoft.com), [Bongshin Lee (Microsoft Research)](mailto:bongshin@microsoft.com), [Petra Isenberg (Inria)](mailto:petra.isenberg@inria.fr), and [Eun Kyoung Choe (University of Maryland)](mailto:choe@umd.edu). 

It contains including [source code for software used in an experiment](StudyApp) as well as [experimental data and analysis scripts](StudyDataAnalysis).

This respository also includes [high-resolution versions of the paper figures](PaperFigures); figures 2-12 were generated with [ggplot2](https://ggplot2.tidyverse.org/) (see [plot_paper_figures.R](StudyDataAnalysis/plot_paper_figures.R)). This repository also contains [mobile screen capture videos](SupplementalVideos) of two experimental sessions (one with Temperature data and a second with Sleep data); the videos were recorded using an iPhone 5s running the Chrome mobile browser, with iOS accessibility controls toggled to show the touch point.    

<img src="temperature.png" title="Linear and Radial temperature range charts designed for mobile phone displays, representative of the stimuli used in our crowdsourced experiment. The gradient bars encode observed temperature ranges and are superimposed on gray bars encoding average temperature ranges. Corresponding Week, Month, and Year charts display the same data."  alt="Linear and Radial temperature range charts designed for mobile phone displays, representative of the stimuli used in our crowdsourced experiment. The gradient bars encode observed temperature ranges and are superimposed on gray bars encoding average temperature ranges. Corresponding Week, Month, and Year charts display the same data." style="width: 100%;"/>

**Figure**: Linear and Radial temperature range charts designed for mobile phone displays, representative of the stimuli used in our crowdsourced experiment. The gradient bars encode observed temperature ranges and are superimposed on gray bars encoding average temperature ranges. Corresponding Week, Month, and Year charts display the same data.

This repository is maintained by [Matthew Brehmer](https://github.com/mattbrehmer).

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
