require(multcomp)
require(reshape2)
require(utils)
require(ggplot2)
require(plyr)
theme_303 <- function(size_base= 16, size_tit= 20, position_leg= "right", border=c(0.25,0.25,0.25,0.25)) {
  theme(
    text =              element_text(size=size_base, colour="black"),
    axis.line =         element_line(colour="black"),
    axis.text =         element_text(size=size_base, colour="gray50"),
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

#Let's start by reading in the tables 

dfs <- read.table("seed_ant.dat", header = T, sep = ",")
levels(dfs$Worker.class) <- c("<37","37-38","39-40",">40")
dfs$Distance <- as.factor(dfs$Distance) # changed to factors

dft <- read.table("thatch_ant.dat", header = T, sep = ",")
levels(dft$Size.class) <- c("<30","30-34","35-39","40-43",">43") #Clean up levels
dft$Distance <- as.factor(dft$Distance) # changed to factors
dft$Colony <- as.factor(dft$Colony) # changed to factors

dfs <- cbind(dfs, c(rep("Seed", 577))) # create Seed Column
colnames(dfs) <- c("Colony", "Distance", "Mass", "Headwidth", "Headwidth..mm.", "Class", "Type")
dft <- cbind(dft, c(rep("Thatch", 1195))) # create Thatch Column
colnames(dft) <- c("Colony", "Distance", "Mass", "Headwidth", "Headwidth..mm.", "Class", "Type")
df <- rbind(dft, dfs) #combined dfs and dfs to faciliate the use of ggplot2




#A.1.a
ggplot(df, aes(x= Mass, fill=Type)) + geom_histogram(binwidth = 5, alpha = 0.7, position = "identity") + theme_303() + labs(y = "Count", x= "Mass (mg)") + labs(title = "Histogram of Thatch & Seed Ants by Mass")


#A.1.b
t.test(dft$Mass, dfs$Mass)

#A.1.c
ggplot(df, aes(x= Headwidth..mm., fill=Type)) + geom_histogram(binwidth = .05, alpha = 0.7, position = "identity") + theme_303() + labs(y = "Count") + labs(x = "Headwidth (mm)", title = "Histogram of Thatch & Seed Ants by Headwidth")
t.test(dft$Headwidth..mm. , dfs$Headwidth..mm.)

#A.2.a
ggplot(dft, aes(Distance, Mass)) + geom_boxplot() + theme_303() + labs(title = "Boxplot of Thatch Ant Mass by Distance", x = "Distance (m)", y= "Mass (mg)")
anova(lm(Mass~ Distance, data = dft))
#TukeyHSD(aov(lm(Mass ~ Distance, data= dft)), conf.level = 0.95) #no need because one-way ANOVA already states that they are not significantly different 

#A.2.b
ggplot(dft, aes(Colony, Mass)) + geom_boxplot() + theme_303() + labs(title = "Boxplot of Thatch Ant Mass by Colony", y= "Mass (mg)")
anova(lm(Mass~ Colony, data = dft))
#TukeyHSD(aov(lm(Mass ~ Colony, data= dft)), conf.level = 0.95) #no need...

#A.2.c
ggplot(dfs, aes(Distance, Mass)) + geom_boxplot() + theme_303() + labs(title = "Boxplot of Seed Ant Mass by Distance", y="Mass (mg)", x = "Distance (m)")
anova(lm(Mass ~ Distance, data = dfs))
TukeyHSD(aov(lm(Mass ~ Distance, data= dfs)), conf.level = 0.95)

anova(lm(Mass ~ Colony, data = dfs))
ggplot(dfs, aes(Colony, Mass)) + geom_boxplot() + theme_303() + labs(title = "Boxplot of Seed Ant Mass by Colony", y= "Mass (mg)", x = "Colony")
TukeyHSD(aov(lm(Mass ~ Colony, data= dfs)), conf.level = 0.95)

#A.3.a 

ggplot(ddply(dfs, .(Distance, Colony), summarise, V1 = mean(Mass), .drop= F), aes(x= Distance, y= V1, fill= Colony)) + geom_bar(position= "dodge",
stat= "identity") + theme_303() + labs(y = "Mean Mass (mg)") + labs(title = "Mean Mass of Seed Ants by Distance and Colony")

with(dfs, interaction.plot(Distance, Colony, Mass,
                           col=c("red", "blue", "green", "purple", "black", "grey", "violet", "magenta"),
                           main="Interaction Plot for Seed Ants",
                           lwd = 3,
                           xlab="Distance (m)", ylab="Mass (mg)")) 

#trouble exporting with label cut


#A.3.b

agg.data <- ddply(dfs, .(Distance, Colony), summarize, mean = round(mean(Mass),1))
colnames(agg.data) <- c("Distance","Colony","Mass")
agg.data.wide <- as.data.frame(dcast(agg.data, Colony ~ Distance, value.var = "Mass"))
write.csv(agg.data.wide, file ="2.csv")


#A.3.c



with(dfs, interaction.plot(Distance, Colony, Mass,
                           col=c("red", "blue", "green"),
                           main="Interaction Plot",
                           xlab="Distance (m)", ylab="Mass"))


fit1 <-lm(Mass ~ Distance*Colony, data = dfs)
anova(fit1)

# p value low enough, all signifcant 

#conclude to keep colony, distance and the interaction term


#4. Focus on Thatch Ant Colonies 2 and 11 ONLY 
dft.sub <- dft[dft$Colony %in% c(2,11),] #subset dft for just colony 2 and 11
dft.sub$Distance <- as.numeric(as.character(dft.sub$Distance))
dft.sub$Colony <-  droplevels(dft.sub$Colony)
dft.sub1 <- dft.sub[!dft.sub$Class == "<30",]
dft.sub2 <- dft.sub[dft.sub$Class == "<30",]

#2 cat 2 num
ggplot(dft.sub2, aes(x= Distance, y= Mass, colour= Colony)) + geom_point(color = "skyblue") + geom_smooth(method= "lm", se=F, color = "skyblue") + facet_wrap(~ Class) + theme_303() + labs(title ="Thatch Ant Mass by Distance for Colony 11 by Size", x="Distance (m)", y= "Mass (mg)")

#4 cat
ggplot(dft.sub1, aes(x= Distance, fill= Colony)) + geom_bar(position= "dodge") + facet_wrap(~ Class) + theme_303() + labs(title="Histogram of Thatch Ants by Distance for Colony 11by Size", x = "Distance (m)")


dft.sub2 <- dft.sub[dft.sub$Class == "30-34",]
dft.sub3 <- dft.sub[dft.sub$Class == ">43",]

