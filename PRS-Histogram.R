library(devtools)
suppressPackageStartupMessages(require(ggplot2))


# Read results for AD risk scores
AD_prs<-read.table("ALZ_PRS.profile", as.is=T, h=T)

# Read results for CAD risk scores
CAD_prs<-read.table("CAD_PRS.profile", as.is=T, h=T)


# Read the files containing cases and controls and join together
# Note: in this example, all AD cases have CAD
# Each file has a 'PHENO' column for phenotype
# 'PHENO' = 0 for controls
# 'PHENO' = 1 for CAD cases (without AD)
# 'PHENO' = 2 for AD cases (with CAD)

cas_ADCAD<-read.table("CADandAD.txt", as.is=T, h=T)
cas_CAD<-read.table("CAD.txt", as.is = T, h=T)
controls<-read.table("Controls.txt", h=T, as.is = T)

pop <- rbind(cas_ADCAD,cas_CAD)
pop <- rbind(pop, controls)


# Merge cases and controls with their individual prs scores

# Give individuals their AD risk scores
AD_dat <- merge(AD_prs, pop, by.x="IID", by.y="IID")

# Give individuals their CAD scores
CAD_dat <- merge(CAD_prs, pop, by.x="IID", by.y="IID")


# Simple histogram for AD PRS results
hist(AD_dat$SCORE,
     main="PRS for Alzheimer's Disease",
     xlab="Polygenic Risk Scores",
     xlim=c(-0.01,0.015),
     col="darkmagenta",
     freq=FALSE
)

# Simple histogram for CAD PRS results
hist(CAD_dat$SCORE,
     main="PRS for Coronary Artery Disease",
     xlab="Polygenic Risk Scores",
     xlim=c(-0.00006,0.00007),
     col="darkmagenta",
     freq=FALSE
)


# Simple boxplots for AD and CAD results

ggplot(AD_dat,aes(x=PHENO.y, y=SCORE, group=PHENO.y)) + geom_boxplot()

ggplot(CAD_dat,aes(x=PHENO.y, y=SCORE, group=PHENO.y)) + geom_boxplot()


dev.off()