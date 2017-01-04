require(epitools)
require(plyr)
require(nlme)
require(ggplot2)
theme_303 <- function(size_base= 16, size_tit= 20, position_leg= "right", border=c(0.25,0.25,0.25,0.25)) {
  theme(
    text =              element_text(size=size_base, colour="black"),
    axis.line =         element_line(colour="black"),
    axis.text =         element_text(size=size_base, colour="gray40"),
    axis.ticks =        element_line(colour="black"),
    
    legend.key =        element_blank(),
    legend.position =   position_leg,
    
    panel.background =  element_blank(),
    panel.border =      element_blank(),
    panel.grid.major.x= element_blank(),
    panel.grid.major.y= element_line(colour="grey"),
    panel.grid.minor =  element_blank(),
    
    plot.title =        element_text(size = size_tit, colour = "black"),
    plot.margin =       unit(border, "cm")
    # margin unit is (top, right, bottom, left)
  )
}


dfs <- read.table("seed_ant.dat", header = T, sep = ",")
levels(dfs$Worker.class) <- c("<37","37-38","39-40",">40") #Clean up levels
dfs$Colony <- as.factor(dfs$Colony)
#(a)
ggplot(dfs, aes(x=Distance , y= Mass, colour= Worker.class)) + geom_smooth(method="lm", se = F) +scale_colour_grey(start = 0, end = 0.86) + theme_303() + xlab("Distance (m)") + ylab("Mass (mg)") + ggtitle("Mass by Distance grouped by Size Class for Seed Ants")
#(b) 
fit <- lm(Mass ~ Distance*Worker.class , data = dfs);
#(c)
fit <- lme(Mass ~ Distance*Worker.class, random= ~ 1|Colony, dfs);anova(fit)
AIC(fit)
#(d)
dfs.d <- dfs
dfs.d$Distance <- as.factor(dfs.d$Distance)
fit <- lme(Mass ~ Distance*Worker.class, random= ~ 1|Colony, dfs.d);anova(fit)
AIC(fit)
#2.
dft <- read.table("thatch_ant.dat", header = T, sep = ",")
levels(dft$Size.class) <- c("<30","30-34","35-39","40-43",">43") #Clean up levels
dft$Colony <- as.factor(dft$Colony) # changed to factors
#(a)
ggplot(dft, aes(x=Distance , y= Mass, colour= Size.class)) +scale_colour_grey(start = 0, end = 0.86)+ geom_smooth(method = "lm", se=F) + theme_303() + xlab("Distance (m)") + ylab("Mass (mg)") + ggtitle("Mass by Distance grouped by Size Class for Thatch Ants")
#(b)
fit <- lm(Mass ~ Distance*Size.class , data = dft)
#(c)
fit <- lme(Mass ~ Distance*Size.class, random= ~ 1|Colony, dft) ;anova(fit)
#(d)
dft.d <- dft
dft.d$Distance <- as.factor(dft.d$Distance)
fit <- lme(Mass ~ Distance*Size.class, random= ~ 1|Colony, dft.d) ;anova(fit)
tab <- with(dft, table(Distance, Size.class));tab
