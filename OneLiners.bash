## Basic One liners which are most useful

# Extract fasta sequences from MSA based on ids from other file

# SAM tools

cut -c 2- ids.txt | xargs -n 1 samtools faidx file.fasta > out.fasta

# faSomeRecords   # faOneRecord (extract one sequence with one id) (http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/)

./faSomeRecords in.faa ids.txt out.faa

# Split MSA into individual fasta files CSPLIT

csplit -z -q -n 4 -f sequence_ in.faa /\>/ {*}

# Find all files with some extension and keep them in a new directory

find . -name "*.pdb" -type f -exec cp {} ./newdirectory \;

#--------------
#     sed     -
#--------------
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

#-----------
#   grep   -
#-----------

# Common elements in 2 files

grep -f file1 file2 #numeric

grep -Fwf file1 file2 # text

# Unique elements in a file (compare 2 files)

grep -Fvf file1 file2

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

#-----------
#   awk    -
#-----------

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

#Extract text lines between 2 specific patterns

nawk '/line1/, /line2/' inFile.txt

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

