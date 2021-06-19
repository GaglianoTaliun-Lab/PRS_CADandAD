# Computing PRS for coronary artery disease and late-onset Alzheimer’s disease 
A polygenic risk score (PRS) estimates the individual-level genetic risk for a trait of interest in the form of a weighted count of the number of risk alleles the person carries. This tutorial will show you how to compute genetic risk scores for late-onset Alzheimer’s disease (LOAD) and coronary artery disease (CAD) in a target data from pre-existing PRS models, using [PLINK](https://www.cog-genomics.org/plink/2.0/). 

## Base Data and Target Data
1.	Download the PRS for your phenotype of interest from the PGS Catalog: 
[PRS for CAD](https://www.pgscatalog.org/score/PGS000018/) / [PRS for LOAD](https://www.pgscatalog.org/score/PGS000334/), for example.
Your base data should contain the PRS variants as well as their effect alleles and effect sizes. If this information is lacking, collect it from a recent GWAS study and append to the PRS variants. GWAS summary statistics are available for download from the [GWAS Catalog](https://www.ebi.ac.uk/gwas/home).
 
2.	**Genomic builds** for the base and target data must match. [LiftOver](https://genome.ucsc.edu/cgi-bin/hgLiftOver/) easily converts your data’s build if needed. It is possible that a couple variants cannot be lifted over and are dropped during conversion. Find LiftOver documentation [here](https://genome.sph.umich.edu/wiki/LiftOver/). 

3.	The genotype data must be converted to **PLINK format** if it isn’t already. However, if the file is very large, consider only converting a subset of it: simply convert the variants needed for the PRS. bcftools’s [view method](http://samtools.github.io/bcftools/bcftools.html#view) offers an easy way to subset large vcf files. 

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
