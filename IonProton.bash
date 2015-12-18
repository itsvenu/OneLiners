# Ion proton workflow, WES, wiki will be created later on for entire pipeline

# QC'ing of short reads, trimming and processing to good quality reads
Fastqc, prinseq 

#Align short reads to Reference, hg19
# Aligners used

1. Novoalign
2. BWA-MEM
3. BBmap

#Variant callers used
1. GATK
2. freebayes
3. platypus

# Annotator use
1. ANNOVAR

# These aligners give output in 'sam' format
# Convert SAM to BAM (use SAMtools)

samtools view -b -S aligned.sam > aligned.bam

#sort and index above created BAM file (SAMtools)

samtools sort aligned.bam sorted_align  # sorted_align.bam will be created 
samtools index sample6_new.bam          # sorted_align.bam.bai will be created

# Separate mapped reads and unmapped reads into two separate files and store unmapped for any future study
# Get unmapped

samtools view -b -f 4 sorted_aligned.bam > unamapped.bam

# Get Mapped reads

samtools view -b F 4 sorted_aligned.bam > mapped.bam

#Consider this mapped reads for further analysis
#Identify target regions for realignment (GATK)

# create sequence dictionary and hg19.faa.fai of hg19 with picard CreateSequenceDictionary and samtools faidx respectively

java -jar GenomeAnalysisTK.jar -T RealignerTargetCreator -R hg19.faa -I mapped.bam -o Realign.intervals

#Realign BAM with above got intervals (for better InDel calling)

java -jar GenomeAnalysisTK.jar -T IndelRealigner -R hg19.faa -I mapped.bam -targetIntervals RealignerTargetCreator -output mapped_realigned.bam

# To improve the SNP specificity do 'samtools calmd' 

samtools calmd -Abr mapped_realigned.bam  hg19.faa > mapped_realigned_calmd.bam

#Call SNPs and Indels (GATK) include '-glm BOTH' option 
#UnifiedGenotyper 

java -jar GenomeAnalysisTK.jar -T UnifiedGenotyper -R hg19.faa -I mapped_realigned_calmd.bam -glm BOTH -o RawVari.vcf

