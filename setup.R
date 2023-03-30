library(tidyverse) 
library(ggpmisc)
library(ggstance)
library(huxtable)
# library(patchwork)
library(lme4)
library(nlme)
library(emmeans)
library(multcomp)
library(performance)

conflicted::conflicts_prefer(ggplot2::annotate)
conflicted::conflicts_prefer(dplyr::filter)
conflicted::conflict_prefer("select", "dplyr")

theme_set(theme_bw(base_size = 12)) 

knitr::opts_chunk$set(echo = F, warning = FALSE, message = FALSE)

asin_tran <- make.tran("asin.sqrt", 100)

# quarto::quarto_render("document.qmd") # defaults to html
# usethis::browse_github()
# tinytex::install_tinytex(repository = "http://mirrors.tuna.tsinghua.edu.cn/CTAN/", version = "latest")
