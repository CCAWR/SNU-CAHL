SNU-CAHL
========

Seoul National University - Climate Change Impact Assessment for Hydrology Library (SNU-CAHL) is a collection of tools for climate change impact assessment in hydrology. The tool has three main goals:

-   Automation of hydrologic modelling in climate change scenarios.

-   Easily import and integrate climate data with hydrology data for multi-model analysis.

-   Provide the resources for informed decisions and conclusions through performance indexes.

This tool was made by the Research Group for [Climate Change Adaptation in Water Resources](http://ccawr.snu.ac.kr) at Seoul National University.

Installation
------------

`snucahl` package requires the [hydromad package](http://hydromad.catchment.org/), which is a required dependency but is not available on CRAN. Install `hydromad` with the following commands:

    install.packages(c("zoo", "latticeExtra", "polynom", "car", "Hmisc","reshape"))
    install.packages("hydromad", repos = "http://hydromad.catchment.org")

`snucahl` can be installed and loaded using the following commands:

    library("hydromad")
    devtools::install_github("CCAWR/SNU-CAHL")
    library("snucahl")

Using SNU-CAHL
--------------

Will be updated soon.

Data Sources
------------

Will be updated soon.

References
----------

Will be updated soon.
