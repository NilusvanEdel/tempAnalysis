#!/bin/bash

Rscript -e "install.packages(c('knitr', 'memisc', 'lme4', 'afex', 'cowplot', 'DHARMa', 'xtable', 'rockchalk', 'tikzDevice', 'parallel', 'fifer', 'multcomp', 'vcdExtra'), repos='https://cran.uni-muenster.de/')"
