library(devtools)
suppressPackageStartupMessages(require(ggplot2))


# Read results for AD risk scores
AD_prs<-read.table("ALZ_PRS.profile", as.is=T, h=T)


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


# Example: read files containing individuals carrying APOE e4/e4 and e3/e4

e4_e4 <- read.table("e4-e4.txt", as.is = T, h=T)
e3_e4 <- read.table("e3-e4.txt", as.is = T, h=T)

# Categorize individuals as cases or controls
e4_cases <- merge(pop, e4_e4, by.x="IID", by.y="IID")
e3_cases <- merge(pop, e3_e4, by.x="IID", by.y="IID")

# Merge with prs file to obtain their individual risk scores
e4_prs <-merge(AD_prs, e4_cases, by.x="IID", by.y="IID")
e3_prs <-merge(AD_prs, e3_cases, by.x="IID", by.y="IID")


# Very simple boxplots with highlighted scores of individuals carrying APOE e4/e4

ggplot(AD_dat,aes(x=PHENO.y, y=SCORE, group=PHENO.y)) +
  geom_boxplot() +
  geom_point(data=e4_prs, aes(x=PHENO, y=SCORE), color="red", size=1)


# Boxplots with hightlighted scores for individuals carrying APOE e3/e4

ggplot(AD_dat,aes(x=PHENO.y, y=SCORE, group=PHENO.y)) +
  geom_boxplot() +
  geom_point(data=e3_prs, aes(x=PHENO, y=SCORE), color="red", size=1)


dev.off()