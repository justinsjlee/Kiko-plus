---
title: Show Flows With The Chord Diagram
date: 2017-09-02 00:00:00 -04:00
tags:
- dataviz
- r
layout: post
description: An example of the chord diagram visualizing consumers switching accross Canadian telco brands using d3.js via R.
comments: false
share: false
category: projects
---

![Screenshot](http://www.justinsjlee.com/chordiag_wlabels.png "Chord Diagram with Labels")

One interesting method of data visualization I learned about during my co-op term is the chord diagram. I found this graph to be very useful in displaying flows between multiple groups in a concise manner. You can view the interactive graph [here](http://www.justinsjlee.com/telco_ex.html).

Note: The numbers from the examples are solely for the purpose of this post.

### Interperting the diagram

![Screenshot](http://www.justinsjlee.com/chordiag.png "Chord Diagram")

The chords in the graph show the inter-relationships between the groups. In our case, the data is based on the movement of customers accross Canadian telecommunications companies at the time of a device upgrade.

![Screenshot](http://www.justinsjlee.com/chordiag_arc.png "Chord Diagram Arc")

Hovering over the arc of a brand gives information about the share of the customer base before the upgrade. Rogers' arc shows that 33% of customers had Roger's as the service provider before the upgrade.

![Screenshot](http://www.justinsjlee.com/chordiag_chord.png "Chord Diagram Chord Grey")

Hovering over one arc gives information about the relationship between the two brands. The width of the arc corresponds to the magnitude of the flow.

![Screenshot](http://www.justinsjlee.com/chordiag_chordred.png "Chord Diagram Chord Red")

The color of the chord is determined by the net positive brand in the relationship. You can see how Rogers has a 3% gain in its chord with Bell.

![Screenshot](http://www.justinsjlee.com/chordiag_internal.png "Chord Diagram Internal")

The internal flow shows the percentage of customers staying at the same brand when upgrading their device.

### How to & the data

The data is in a matrix as seen below. The row names represent the names of the brands pre-upgrade and the column names represent the brands post-upgrade. Naturally, the diagonal shows the customers upgrading without switching providers and the sum of the matrix is 100%.

| From\To |Rogers | Bell | Telus| Other|
|:-------:|:---:|:----:|:----:|:----:|
|  **Rogers** |  24%  |  2%  |  2%  |  5%  |
|  **Bell**   |  5%   |  23% |  2%  |  2%  |
|  **Telus**  |  3%   |  3%  |  18% |  3%  |
|  **Other**  |  2%   |  3%  |  1%  |  2%  |

You can read the table as shown below.

Rogers → Rogers: 24%, Rogers → Bell: 2%,  Rogers → Telus: 2%,  Rogers → Other: 5%

The diagram is made with the ```chorddiag``` package in R. The package uses the Javascript visualization library [D3.js](http://d3js.org) and the ```htmlwidgets``` package. Here is the R script for creating the sample dataset and rendering the chord diagram.

```
# Install chorddiag package from github
devtools::install_github("mattflor/chorddiag")

# Load package
require(chorddiag)

# Create an example dataset 
telco_ex <- c(24, 2, 2, 5,
              5, 23, 2, 2,
              3, 3, 18, 3,
              2, 3, 1, 2) 

# Store the data as a matrix
telco_ex <- matrix(telco_ex,
            byrow = TRUE,
            nrow = 4, ncol = 4)

# Label rows and columns of matrix
arcs <- c("Rogers", "Bell", "Telus", "Other")
dimnames(telco_ex) <- list(from = arcs, to = arcs)

# Create a list of colors with HEX codes to match the brands.
# Bell: #0066a4, Rogers: #e1292f, Telus: #6cbf44, Other: #a6a6a6
groupColors <- c("#e1292f", "#0066a4", "#6cbf44", "#a6a6a6")

# Render chord diagram. 
chorddiag(telco_ex, 
          groupColors = groupColors, 
          groupnamePadding = 20, 
          showTicks = F, 
          tooltipFontsize = 16, 
          tooltipUnit = "%")
```

To export the diagram as a web page I'm using the Export function built into the Viewer tab in RStudio. Opening the resulting web page should give you [this](http://www.justinsjlee.com/telco_ex.html).

### Sources & credits

Read more about the ```chorddiag``` R package by [Matt Flor](https://github.com/mattflor/chorddiag).

This article was inspired by [Visual Cinnamon's](https://www.visualcinnamon.com/2014/12/using-data-storytelling-with-chord.html) article on the chord diagram.

Special thanks to the folks at [Clickinsight](https://www.clickinsight.ca) for giving me the oppurtunity to learn and apply these new techniques.



