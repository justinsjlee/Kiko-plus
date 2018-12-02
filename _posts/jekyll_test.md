---
title: Ecological Study of Lizard Dewlap Colour and Area
date: 2017-12-02 00:00:00 -04:00
tags:
- r
layout: post
description: My script from class
comments: false
share: false
category: projects
---

#### *by Justin Seongjun Lee, April 6<sup>th</sup> 2018*

### Introduction

This notebook composes of the analysis of data collected by Ben Downer-Bartholomewben and his research team to (i) investigate the relationship between colour of lizards’ dewlaps and the environment in which they inhabit and (ii) investigate the relationship between abundance levels of lizards and their dewlap sizes. The data was collected on multiple sites on the island of Hispaniola by Ben and his fellow researchers over the summer of 2016 and 2017.

Both questions are answered using the same lizards, but as the datasets were provided by Ben to me separately, I will import each dataset separately; definitions apply to both datasets. The data is filtered for male adult lizards who belong to the cybotes and semilineatus species as per the collabarator's request.

### Variable Definitions

-   **mahler**: Lizard identification code.
-   **gen\_local**: General localities where lizard was found.
-   **species**: Species the lizard belongs to.
-   **sex**: Gender of student, male or female.
-   **temp**: Degrees Celcius, Mean annual temperature where lizard was found.<sup>1</sup>
-   **prep**: Milimeters, Mean annual precipitation where lizard was found. <sup>2</sup>
-   **tree**: % Cover, Mean tree coverage where lizard was found. <sup>3</sup>
-   **elev**: Meters, Elevation measured where lizard was found. <sup>4</sup>
-   **abundance**: Number of lizards estimated to be a 15m radius. <sup>5</sup>
-   **hue**: Value of Hue scaled to be between 0 and 1. <sup>6</sup>
-   **sat**: Value of Saturation scaled to be between 0 and 1. <sup>6</sup>
-   **val**: Value of Brightness scaled to be between 0 and 1. <sup>6</sup>
-   **SVL**: Milimeters, Snout to Vent length.
-   **area**: Milimeters^2, Area of dewlap.

Data was either scarped from the web using coordinates from the following sites, outputted from mentioned software and collected manully by Ben and his team.

-   \[1\] <http://chelsa-climate.org/>
-   \[2\] <http://chelsa-climate.org/>
-   \[3\] <https://landcover.usgs.gov/glc/TreeCoverDescriptionAndDownloads.php>
-   \[4\] <http://www.worldclim.org/>
-   \[5\] Output from mark recapture model developed by Luke Frishkoff.
-   \[6\] Output from ImageJ software in conjunction with Colourhistogram plugin.

### Data Cleansing & Evaluation

After cleaning and reformatting the data, we look at the summary statistics to evaluate the s

``` r
require(tidyr)
```

    ## Loading required package: tidyr

``` r
require(dplyr)
```

    ## Loading required package: dplyr

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
# read in data and use clean column names
colour_wide <- read.csv("hsvmasterdataset.csv")
colnames(colour_wide) <- c("mahler", "hue", "sat", "val", "locality", "gen_local",
                       "genus", "species", "mass", "sex", "lat", "long", "elevation",
                       "temp", "prep", "elev", "tree")

# code mahler id as a factor
colour_wide$mahler <- as.factor(colour_wide$mahler)

# change wide format data into long format data
colour <- gather(colour_wide , hsb, value, hue:val, factor_key=TRUE)

# clean up general locality for duplicates
colour$gen_local[colour$gen_local == "del Este (East)"] <- "del Este East"
colour$gen_local[colour$gen_local == "Manabao (general region)"] <- "Manabao"
colour$gen_local <- droplevels(colour$gen_local)

# filter for only relevant species and male lizards.
colour <- filter(colour, species %in% c("cybotes", "semilineatus"));
colour$species <- droplevels(colour$species)
colour <- filter(colour, sex == "M")

# filter for relevant variables and summarize
colour <- select(colour, c("mahler", "hsb", "value", "gen_local", "species", "sex",
                           "temp", "prep", "elev", "tree"))
```

We do the same thing for the abundance dataset and evaluate the summary.

``` r
# Import data for abundance question
abundance <- read.csv("abundance.csv")
colnames(abundance) <- c("mahler", "locality", "gen_local", "genus", "species", "mass",
                         "sex", "SVL", "lat", "long", "elevation", "area", "lon2",
                         "lat2", "temp", "prep", "elev", "tree", "site", "abundance")

# clean up general locality for duplicates 
abundance$gen_local[abundance$gen_local == "del Este (East)"] <- "del Este East"
abundance$gen_local[abundance$gen_local == "Manabao (general region)"] <- "Manabao"
abundance$gen_local <- droplevels(abundance$gen_local)

# turn on after asking Ben, filters from other question
abundance <- filter(abundance, species %in% c("cybotes", "semilineatus"))
abundance <- filter(abundance, sex == "M")

# filter for relevant variables and summarize
abundance <- select(abundance, c("mahler", "area", "abundance", "gen_local", "SVL",
                                 "species", "sex", "temp", "prep", "elev", "tree", "site"))

# we can see that we have +3 observations in the abundnace dataset
nrow(colour)/3; nrow(abundance)
```

    ## [1] 184

    ## [1] 187

``` r
# find mahler ids and note in report
abundance$mahler[!abundance$mahler %in% colour$mahler]
```

    ## [1] 2064 2110 2536

``` r
# 2064 2110 2536
```

After filtering for relevant species and males, we are left with 184 observations for the colour dataset with 10 rows of missing values for environemntal variables. These are due to the website not having the data for the given coordinates.

We have 181 observations for the abundance dataset when filtered; In adition to the same 10 rows of missing values for the environemntal data, the abundance dataset has 81 missing values for the abundance, as the mark recapture model wasn't suiteable for certain coordinates. There are also 8 values of SVL missing.
