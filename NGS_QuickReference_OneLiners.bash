
#Generate a vcf.gz along with its tabix indexed file
#To use with vcftools

bgzip -c file.vcf > file.vcf.gz
tabix -p vcf file.vcf.gz

tabix -h vcf_file.vcf.gz chr1:1000-1000 # make a subset of VCF file along with header

#Compare two VCF files and list out variants present in file1 only

vcf-isec -c file1.vcf.gz file2.vcf.gz file3.vcf.gz | bgzip -c > file1_only.vcf.gz

# Common variants in 2 VCF files

vcf-isec -n +2 file1.vcf.gz file2.vcf.gz | bgzip -c > CommonVar.vcf.gz

#Average depth from a VCF file

zcat file.vcf.gz | grep -v '^#' | grep -oP "DP=\w+" | sed 's/DP=//' | awk '{s += $1}END{print s/NR}'

# FIlter any VCF file based on arbitrary terms, snpsift.jar

java -jar ~/seq-tools/snpEff/SnpSift.jar filter "(QUAL>30) & (AF > 0.15) & (AO > 4) & (DP > 10) & (STB < 0.95)" in.vcf 

#VCF processing for SciClone input (Tumor heterogeneity)
#VCF V4.1, Ion Proton variant caller generated vcf 

cut -f 1,2,8 vcf_file.vcf | sed 's/;/\t/g' | cut -f 1,2,4,5 | awk '{print $1"\t"$2"\t"$4"\t"$3}' | sed 's/DP=//' | sed 's/AO=//' | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$3-$4"\t"$4"\t"$4/$3*100}' | cut -f 1,2,5-7 > sciclone_input.txt

