
## Note down something quckly while googling, enter following into browser

data:text/html, <html contenteditable>

#### SHORTEN terminal prompt length

# Extract filename - bash scripting

http://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash

# All the commands of *nix are not working (i.e. ls, cat, vi...etc) ?
# Do the following

export PATH=$PATH:/bin:/usr/local/bin
or
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# for current terminal

PS1='\u:\W\$ '

# Cahnge it completely, add to ~./bashrc file
http://askubuntu.com/questions/145618/how-can-i-shorten-my-command-line-bash-prompt

### Create a figure of a directory structure with pdf

tree -C -h Directory | aha > foo.html
wkhtmltopdf foo.html foo.pdf

# Reverese complementary sequence with bash

cat bio_185191.fa | paste - - | awk -F'\t' -vOFS='\t' '{gsub("A", "T", $2); gsub("T", "A", $2); gsub("G", "C", $2); gsub("C", "G", $2); print}' | tr '\t' '\n'

## Basic One liners which are most useful

#Download files from SRA (NCBI) with wget

wget "ftp://ftp-trace.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByStudy/sra/SRP%2FSRP003%2FSRP003475/SRR065223/"

# Extract fasta sequences from MSA based on ids from other file

# SAM tools

cut -c 2- ids.txt | xargs -n 1 samtools faidx file.fasta > out.fasta

# faSomeRecords   # faOneRecord (extract one sequence with one id) (http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/)

./faSomeRecords in.faa ids.txt out.faa

# Split MSA into individual fasta files CSPLIT

csplit -z -q -n 4 -f sequence_ in.faa /\>/ {*}

# Find all files with some extension and keep them in a new directory

find . -name "*.pdb" -type f -exec cp {} ./newdirectory \;

#DO something with all the files in dir. and subdire.

for f in ./**/*/*.txt; do awk '{if($4<0.05) print $1"\t"$2"\t"$7}' $f > $f.sig; done

#--------------
#     sed     -
#--------------
# print 1st and last line of a text file

sed -e 1b -e '$!d' file


# Modifying headers of MSA

sed 's/[^\s>]*\s//' input > output # pfam MSA

# Extracting specific number of rows in a files

sed -n 1,100p input.txt > output.txt

# Write at the beginning of the file

sed -i '1s/^/beginning\n\n' in.txt

# Split a word into space separated charecters

sed 's/./& /' in.txt

# Extract NMR models from PDB file

sed -n '/MODEL         1/,/ENDMDL/p' in.pdb > out.pdb

#change format of text file for every 2 lines

sed "N;s/\n/\t/" InFile.txt

#write at the beginning of the file, i.e before first line

sed '1i header1\theader2\theader3' file.tsv > newFile.tsv

#-----------
#   grep   -
#-----------

# Common elements in 2 files

grep -f file1 file2 #numeric

grep -Fwf file1 file2 # text

# Unique elements in a file (compare 2 files)

grep -Fvf file1 file2

grep -F -x -v -f file1 file2 #for text files, prints uniq lines from file2

# print exact number of lines after matching a pattern

grep -A 4 'PATTERN' file.txt # after matching
grep -B 4 'PATTERN' file.txt # before matching
grep -c 2 5 'PATTERN' file.txt # 2 lines before & 5 lines after matching

grep -B1 '^[[:digit:]]' file.txt # print 1 line before of the line that starts with a digit

# Remove rows in a file with a list in another file

grep -v -f list.txt file.txt

# Find which residue is present in a particular postion in FASTA sequence

grep -v '^>' in.faa | tr -d "\n" | cut -c10 # residue in 10th postion ( -c1,10)--> 1 and 10th position

#index of a charecter in a string

grep -aob '\.' stringFile.txt # returns index and charecter in colors Ex: 14:.
grep -aob '\.' stringFile.txt --color=never | \grep -oE '[0-9]+' #returns simple index

# Extract only words

grep -oP "AF1=[0-9]\.[0-9]+" snvs_XI034_ICN-MB34_somatic_snvs_conf_8_to_10.vcf

#-----------
#   awk    -
#-----------

# Print the longest line in quotes.txt

awk 'length > max { max=length;maxline=$0 } END { print maxline; }' quotes.txt 

# Remove repeated elements(duplicates)

awk '!a[$1]++' input > output

# parsing pdb file

awk '$1=="ATOM" && $3=="CA"' file.pdb

# Count how many times a value is repeated in a column

awk '{h[$1]++};END{for(k in h)print k,h[k]}' in.txt

# Sum the values in a column

awk '{s+=$1}END{print s}' in.txt

# Average of a column

awk '{s+=$1}END{print s/NR}' in.txt

# Percentage of each value in a column

awk '{b[$1]=$2;sum=sum+$2}END{for(i in b)print i,b[i], (b[i]/sum)*100}' in.txt

# print with a condition on 1st column

awk -F "\t" '$1>4000{print$1"\t"$2"\t"...}' in.txt

# Convert a column into a comma separated row

awk -VORS=, '{print$1}' input.txt | sed 's/, $/\n/' > out.txt

#print rows of a file matching the values in particular column.

awk 'FNR==NR{a[$4,$5]=$0;next}{if(b=a[$4,$5]){print b}}' file1 file2

#Match first two columns and print entire row from a file if it matches

awk -F'\t' 'NR==FNR{c[$1$2]++;next};c[$1$2] > 0' file1.txt file2.txt #prints from file2

#Compare column1 from 2 files and print all the columns from both files

awk -F '\t' -v OFS='\t' 'NR==FNR{a[$1]=$1 OFS $2; next} $1 in a{print $2, a[$1]}' file1 file2 | awk '{print$2"\t"$1"\t"$3}'

#Match first column in 2 files and print all the columns from 2 files

join <(sort file1.txt) <(sort file2.txt) >out.txt

#Extract text lines between 2 specific patterns

nawk '/line1/, /line2/' inFile.txt

#skip first field and print from second column from a multi column text file

awk '{print substr($0, index($0,$2))}' infile.txt

# Match empty feild with awk

awk 'BEGIN {FS="\t"} $2="" {print}' file.txt

#absolute value of columns

awk -F'\t' 'function abs(x){return ((x < 0.0) ? -x : x)} {if (abs($9) < 500) print $0}' file.txt

# --- PERL

# Modyfying HMM db(pfam) PF00012.3 --> PF00012

perl -pe 's/(?<=PF\d{5}\.\d{2})//' in.hmm

perl -pe 's/|\..+//' input > output # pdb fasta MSA

# Remove files in a directory with a list in another file

for f in $(cat list.txt);
do
 rm $f
done

# Bulk rename

rename 's/.txt/.fasta/' *.txt

# Line count in a file

wc -l *.fasta 
ls -l *.fasta | wc -l # number of files with fasta extension

# Remove duplicates

uniq -d file.txt

#--------------------------------------------------------------------------------------------

# loop a MATLAB function over each file in a directory
fls = dir( fullfile( 'path', 'to', 'my', 'folder', '*.txt' ) ); 
for ii = 1: numel(fls)
    infile = fullfile( 'path', 'to', 'my', 'folder', fls(ii).name );
    outfile = fullfile( 'path', 'to', 'my', 'folder', [fls(ii).name(1:end-4),'.DL'] ); 
    myFunction( infile, outfile );
end

#--------------------------------------------------------------------------------------------

#parsing each '.pdb' in a directory
for f in *.pdb
do

awk '$1=="ATOM"&&$3=="CA"&&$5=="A"' $f > ""$f".atom"                      #extract CA file
perl sele.pl ""$f".atom" | awk '{print$1"\t"$4"\t"$6}' >> sizes.txt;      #size of each pdb in one file(first & last atom), sele.pl -> perl script
perl sele20.pl ""$f".atom" | awk '{print$1"\t"$4"\t"$6}' >> first20.txt;  #first 20 positions and AA -> sele20.pl -> perl script

done

# awk Onliner for extracting true positive and the contacts which are below the specified level

 awk '{print "fgrep -xf "$1"  "$2 "  >  " $2".tp\n\n""awk $1 < && $2< "$2".tp > "$2".fh\n" "awk $1 < && $2> "$2".tp > "$2".fsh\n""awk $1> && $2> "$2".tp > "$2".sh\n"}' pctop > split.bash

# append sequnce of a file in one dir. to a similar named file in other dir.

for fasta in `python -c 'import os; dir1=[fasta for fasta in os.listdir("dir1")]; dir2=[fasta for fasta in os.listdir("dir2") ]; print " ".join(list(set(dir1).intersection(dir2)))'`
do
tail -n +2 dir2/$fasta >> dir1/$fasta
done

# Convert .xls file to text file in UNIX

ssconvert infile.xls outfile.txt #generates CSV file
sed -i 's/,/\t/g' outfile.txt # CSV --> TSV file

## Heatmap in R without clustering (For Gene expression)
#http://r.789695.n4.nabble.com/Heatmap-2-eliminate-cluster-and-dendrogram-td857723.html

heatmap.2(matrix, col = greenred(100), dendrogram = "none", Rowv = FALSE)

# R
# Find column number given the column name
# Column name 'b' , df-data.frame
which( colnames(df)=="b" ) #or

match("b",names(df))





