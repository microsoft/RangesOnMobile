# Study Data + Analysis Scripts

Analyzing the results of our experiment focusing on visualizing ranges on mobile devices.

Maintained by [Matthew Brehmer](https://github.com/mattbrehmer).

## Usage

1. Open a terminal and navigate to this directory.

2. Ensure that [R](https://www.r-project.org/) is installed.

3. processLogCSVs.R will ingest log files as exported from [Azure Application Insights](https://azure.microsoft.com/en-us/services/application-insights/). If you did not use appInsights and wrote your own custom logging protocol for the StudyApp, you will need to modify processLogCSVs.R to match the format of your log files. 

4. In the R terminal, `> source(main.R)`, which will process the log files, compute (bootstrap) CIs for time and error, and export plots. Depending on how powerful your machine is, the bootstrap CI calculations may take a few minutes.

5. All of the .pdf and .png charts will appear in this directory.

## 3rd party package dependencies:

- [reshape2](https://cran.r-project.org/web/packages/reshape2/index.html) ([MIT license](https://cran.r-project.org/web/packages/reshape2/LICENSE))
- [ggplot2](https://cran.r-project.org/web/packages/ggplot2/index.html) ([GPL-2 license](https://cran.r-project.org/web/packages/ggplot2/LICENSE))
- [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html) ([MIT license](https://cran.r-project.org/web/packages/dplyr/LICENSE))
- [plyr](https://cran.r-project.org/web/packages/plyr/index.html) ([MIT license](https://cran.r-project.org/web/packages/plyr/LICENSE))
- [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html) ([MIT license](https://cran.r-project.org/web/packages/jsonlite/LICENSE))
- [boot](https://cran.r-project.org/web/packages/boot/index.html) ([Unlimited license](https://cran.r-project.org/web/packages/boot/index.html))
- [PropCIs](https://cran.r-project.org/web/packages/PropCIs/index.html) ([GPL-3](https://cran.r-project.org/web/licenses/GPL-3))

## Additional attribution:

Bootstrap CI calculation (`bootCIs.R`) and plotting (`plot_CIs.R`) helper functions were adapted from [an R Markdown tutorial by Pierre Dragicevic](http://www.aviz.fr/ci/), a companion to the paper "[La Différence Significative entre Valeurs p et Intervalles de Confiance](https://hal.inria.fr/hal-01562281/document)" by Lonni Besançon and Pierre Dragicevic, AFIHM. 29ème conférence francophone sur l’Interaction Homme-Machine, Aug 2017, Poitiers, France. IHM-2017, pp.10, 2017
