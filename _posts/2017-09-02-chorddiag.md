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

![Screenshot](http://www.justinsjlee.com/chordiag.png "Chord Diagram")

### Interperting the diagram:
The chords in the graph show the inter-relationships between the groups. In our case, the data is based on the movement of customers accross Canadian telecommunications companies at the time of a device upgrade.

![Screenshot](http://www.justinsjlee.com/chordiag_arc.png "Chord Diagram Arc")

Hovering over the arc of a brand gives information about the share of the customer base before the upgrade. Rogers' arc shows that 33% of customers had Roger's as the service provider before the upgrade.

![Screenshot](http://www.justinsjlee.com/chordiag_chord.png "Chord Diagram Chord Grey")

Hovering over one arc gives information about the relationship between the two brands. The width of the arc corresponds to the magnitude of the flow.

![Screenshot](http://www.justinsjlee.com/chordiag_chordred.png "Chord Diagram Chord Red")

The color of the chord is determined by the net positive brand in the relationship. You can see how Rogers has a 3% gain in its chord with Bell.

![Screenshot](http://www.justinsjlee.com/chordiag_internal.png "Chord Diagram Internal")

The internal flow shows the percentage of customers staying at the same brand when upgrading their device.

### How to & the data:

The data is in a matrix as seen below. The row names represent the names of the brands pre-upgrade and the column names represent the brands post-upgrade. As a result, the diagonal shows the percentage of customers upgrading while sticking to the same provider.

| From\To |Rogers | Bell | Telus| Other|
|:-------:|:---:|:----:|:----:|:----:|
|  Rogers |  24%  |  2%  |  2%  |  5%  |
|  Bell   |  5%   |  23% |  2%  |  2%  |
|  Telus  |  3%   |  3%  |  18% |  3%  |
|  Other  |  2%   |  3%  |  1%  |  2%  |



Sources & credits:
