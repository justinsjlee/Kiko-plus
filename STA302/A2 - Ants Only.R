require(gdata)
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
levels(dfs$Worker.class) <- c("<37","37-38","39-40",">40")
seed.ant <- c(rep(1, 577))
thatch.ant <- c(rep(0, 577))
dfs <- cbind(dfs, seed.ant, thatch.ant)

dft <- read.table("thatch_ant.dat", header = T, sep = ",")
levels(dft$Size.class) <- c("<30","30-34","35-39","40-43",">43") #Clean up levels
dft$Colony <- as.factor(dft$Colony) # changed to factors
seed.ant <- c(rep(0, 1195))
thatch.ant <- c(rep(1, 1195))
dft <- cbind(dft, seed.ant, thatch.ant)
names(dft) <- c("Colony","Distance","Mass","Headwidth","Headwidth..mm.","Worker.class","seed.ant","thatch.ant")

df <- rbind(dfs, dft)
df$seed.ant <- as.factor(df$seed.ant)

#1.a
plot(dft$Mass ~ dft$Headwidth..mm., xlab = "Headwidth (mm)", ylab = "Mass (mg)")
#1.b
Headwidth..mm.sq <- (dft$Headwidth..mm.)^2
dft <- cbind(dft, Headwidth..mm.sq)
fit1 <- lm(Mass ~ Headwidth..mm.sq, data = dft)
plot(dft$Mass ~ dft$Headwidth..mm.sq, main = "Mass vs Headwidth^2", xlab= "Headwidth^2 (mm^2)", ylab = "Mass (mg)")
abline(fit1)
plot(fit1)


#1.c
e  <- abs(fit1$residuals)
fit1.w <- lm(e ~ Headwidth..mm.sq, data = dft)
fit1.wf <-lm(Mass ~ Headwidth..mm.sq, data = dft, weights = 1/fit1.w$fitted.values^2)
summary(fit1.wf)

#1.d

predict(fit1, data.frame(Headwidth..mm.sq = 4), interval = "prediction") #unweighted
predict(fit1.wf, data.frame(Headwidth..mm.sq = 4), interval = "prediction") #weighted

#2
#Perform a logistics regression with 1 = seed  0 = thatch ants as the binary response variable. 
fit <- glm(seed.ant ~ Mass, family = binomial, data = df)
100*(exp(coef(fit)) -1)
100*(exp(confint(fit)) -1)
#Perform a logistics regression with 1 = thatch  0 = seed ants as the binary response variable. 
fit <- glm(thatch.ant ~ Mass, family = binomial, data = df)
100*(exp(coef(fit))-1)
100*(exp(confint(fit))-1)
#We are 95% confident that for each additional incrase in unit mass, the odds of being a seed ant increase is by a number in the interval (9.05%, 7.46%)




