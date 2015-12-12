#!/bin/bash

# Extract HP length < 3 sites from allels file

# SOMATIC

awk '$38 <=3' ~/Tumor_data/VCF_files_67_HS_Somatic/Exome-6/alleles_IonXpress_006.xls | cut -f 2 > S6_somatic_HP3_sites.txt

while read -r site
do
grep "$site" -w ~/Tumor_data/VCF_files_67_HS_Somatic/Exome-6/TSVC_variants_IonXpress_006.vcf >> S6_Som_HP3.vcf
done < S6_somatic_HP3_sites.txt

# GERMLINE

awk '$38 <=3' ~/Tumor_data/VCF_files_67_HS_Germline/Exome-6/alleles_IonXpress_006.xls | cut -f 2 > S6_Germ_HP3_sites.txt

while read -r siite
do
grep "$siite" -w ~/Tumor_data/VCF_files_67_HS_Germline/Exome-6/TSVC_variants_IonXpress_006.vcf >> S6_Germ_HP3.vcf
done < S6_Germ_HP3_sites.txt

# Add VCF headder to both files for further filtration with SnpSift.jar

grep '^#' ~/Tumor_data/VCF_files_67_HS_Somatic/Exome-6/TSVC_variants_IonXpress_006.vcf > S6_SomVar.vcf
grep '^#' ~/Tumor_data/VCF_files_67_HS_Germline/Exome-6/TSVC_variants_IonXpress_006.vcf > S6_GemVar.vcf

cat S6_Som_HP3.vcf >> S6_SomVar.vcf
cat S6_Germ_HP3.vcf >> S6_GemVar.vcf

# Flter with SNPsift DP>10, AF>0.15, AO>4

java -jar ~/seq-tools/snpEff/SnpSift.jar filter "(AF>0.15) & (AO>4) & (DP>10)" S6_SomVar.vcf > S6_SomVar_filtered.vcf
java -jar ~/seq-tools/snpEff/SnpSift.jar filter "(AF>0.15) & (AO>4) & (DP>10)" S6_GemVar.vcf > S6_GermVar_filtered.vcf

# bgzip and tabix following VCFs
# 1. S6_SomVar_filtered.vcf
# 2. S6_GermVar_filtered.vcf

bgzip -c S6_SomVar_filtered.vcf > S6_SomVar_filtered.vcf.gz
bgzip -c S6_GermVar_filtered.vcf > S6_GermVar_filtered.vcf.gz

# tabix

tabix -p vcf S6_SomVar_filtered.vcf.gz
tabix -p vcf S6_GermVar_filtered.vcf.gz

# compare above 2 VCFs and add Germ. specific variants to Somatic file

vcf-isec -c S6_GermVar_filtered.vcf.gz S6_SomVar_filtered.vcf.gz > S6_germ_only.vcf

# Create ANNOVAR input files for above somatic and germline files

./convert2annovar.pl -format vcf4 S6_SomVar_filtered.vcf > S6_Somatic_AnnIn.vcf
./convert2annovar.pl -format vcf4 S6_germ_only.vcf > S6_GermOnly_AnnIn.vcf

# Add germ to somatic 

cat S6_GermOnly_AnnIn.vcf >> S6_Somatic_AnnIn.vcf

./annotate_variation.pl -buildver hg19 S6_Somatic_AnnIn.vcf humandb/
cut -f 1 S6_Somatic_AnnIn.vcf.variant_function | sort | uniq -c | sort -n -r -k1 > S6_Var_Distri.txt
