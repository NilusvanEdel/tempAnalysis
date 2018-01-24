#!/bin/bash

Rscript -e "library(knitr); knit('vr_accept_analysis.Rnw')"
latexmk -pdf vr_accept_analysis.tex
