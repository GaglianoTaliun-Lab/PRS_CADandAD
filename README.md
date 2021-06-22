# Computing PRS for coronary artery disease and late-onset Alzheimer’s disease 
A polygenic risk score (PRS) estimates the individual-level genetic risk for a trait of interest in the form of a weighted count of the number of risk alleles the person carries. This tutorial will show you how to compute genetic risk scores for late-onset Alzheimer’s disease (LOAD) and coronary artery disease (CAD) in a target data from pre-existing PRS models, using [PLINK](https://www.cog-genomics.org/plink/2.0/). 

## Base Data and Target Data
1.	Download the PRS for your phenotype of interest from the PGS Catalog: 
[PRS for CAD](https://www.pgscatalog.org/score/PGS000018/) / [PRS for LOAD](https://www.pgscatalog.org/score/PGS000334/), for example.
Your base data should contain the PRS variants as well as their effect alleles and effect sizes. If this information is lacking, collect it from a recent GWAS study and append to the PRS variants. GWAS summary statistics are available for download from the [GWAS Catalog](https://www.ebi.ac.uk/gwas/home).
 
2.	**Genomic builds** for the base and target data must match. [LiftOver](https://genome.ucsc.edu/cgi-bin/hgLiftOver/) easily converts your data’s build if needed. It is possible that a couple variants cannot be lifted over and are dropped during conversion. Find LiftOver documentation [here](https://genome.sph.umich.edu/wiki/LiftOver/). 

3. The target data’s genetic ancestry should match that of the population your PRS model was trained on. PRS lack transferability between populations.

4.	The genotype data must be converted to **PLINK format** if it isn’t already. However, if the file is very large, consider only converting a subset of it: simply convert the variants needed for the PRS. bcftools’s [view method](http://samtools.github.io/bcftools/bcftools.html#view) offers an easy way to subset large vcf files. 

## Compute Scores
1.	Run PLINK’s `--score` command for [allelic scoring](https://www.cog-genomics.org/plink/1.9/score)
```
plink 
- - bfile <target data>        
- - score <base data> 1 6 9 header center         
- - out <output>
```
- `1` = column containing the variant names (1st column in this example)
- `6` = column containing the effect allele (6th here)
- `9` = column containing the effect allele weight (9th here)
- `header` informs PLINK that your base data contains a header
- `center` informs PLINK to shift all scores to mean zero

2.	The results will be written out to a `.profile` file which will contain each individual’s personal polygenic risk score. 

## Visualize the data
1.	Histogram
Example: simple R script to visualize the coronary artery disease PRS results as a histogram. Complete [script for AD and CAD PRS histograms](https://github.com/GaglianoTaliun-Lab/PRS_CADandAD/blob/main/PRS-Histogram.R)
```
# Read in results for CAD risk scores
CAD_prs <- read.table("CAD_PRS.profile", as.is=T, h=T)

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

# Give individuals their CAD scores
CAD_dat <- merge(CAD_prs, pop, by.x="IID", by.y="IID")

# Simple histogram for CAD PRS results
hist(CAD_dat$SCORE,
     main="PRS for Coronary Artery Disease",
     xlab="Polygenic Risk Scores",
     xlim=c(-0.00006,0.00007),
     col="darkmagenta",
     freq=FALSE
)
```
##### Output: PRS for Coronary Artery Disease in the MHI Biobank
<img src="https://github.com/GaglianoTaliun-Lab/PRS_CADandAD/blob/main/Histogram-CAD-PRS.PNG" width="400" height="400">

2.	Boxplots
Example: simple R script to observe the CAD PRS results as boxplots. Complete [CAD and AD boxplot script](https://github.com/GaglianoTaliun-Lab/PRS_CADandAD/blob/main/PRS-Boxplots.R)
```
# Using previous CAD_data which contains the CAD scores for all cases and controls

# Simple boxplot for CAD PRS
ggplot(CAD_dat,aes(x=PHENO.y, y=SCORE, group=PHENO.y)) + geom_boxplot()
```


3.	Boxplots with highlighted points 
ggplot allows you to highlight certain points on the boxplots. For example, highlight the scores of individuals carrying the APOE e3/e4 alleles, or e4/e4. [Complete example script here](https://github.com/GaglianoTaliun-Lab/PRS_CADandAD/blob/main/PRS_Boxplots_APOE.R)
```
# Example: read in file containing individuals who carry APOE e4/e4
e4_e4 <- read.table("e4-e4.txt", as.is = T, h=T)

# Categorize these individuals as cases or controls
e4_cases <- merge(pop, e4_e4, by.x="IID", by.y="IID")

# Merge with prs file to obtain their individual risk scores
e4_prs <-merge(AD_prs, e4_cases, by.x="IID", by.y="IID")

# Very simple boxplots with highlighted scores of individuals carrying APOE e4/e4
ggplot(AD_dat,aes(x=PHENO.y, y=SCORE, group=PHENO.y)) +
  geom_boxplot() +
  geom_point(data=e4_prs, aes(x=PHENO, y=SCORE), color="red", size=1)
```
##### Output: PRS for CAD in individuals in the MHI Biobank, red scores represent samples carrying APOE e4/e4 alleles
<img src="https://github.com/GaglianoTaliun-Lab/PRS_CADandAD/blob/main/Boxplot_APOE_e4-e4.png" width="500" height="300">
