
#Generate a vcf.gz along with its tabix indexed file

bgzip -c file.vcf > file.vcf.gz
tabix -p vcf file.vcf.gz

