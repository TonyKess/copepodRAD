#!/bin/bash
# demultiplex by running process_radtags on all the lanes

# setup global variables
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
TRIM_LENGTH=$1 # Length to cut reads after process_radtags
ENZYME=$2  # Enzyme


# log info
echo -e "process_radtags run with ... :\n\n\
    $(echo 02_demultiplex.sh $TRIM_LENGTH $ENZYME1)" \
> $LOG_FOLDER/02_demultiplex.log

# Extract reads
grep -vE "^$" $INFO_FILES/sample-summary-info.csv  | \
        grep -v "Barcode" | \
        cut -f 2,3,4 > $INFO_FILES/barcodes.txt

cat $INFO_FILES/lane_info.txt |
while read f
do
#    mkdir 02_demultiplex/$f 2> /dev/null
    $STACKS/process_radtags \
        -i gzfastq \
        -P \
        -1 $TRIMDIR/${f}_R1.trimmed.fastq.gz \
        -2 $TRIMDIR/${f}_R2.trimmed.fastq.gz \
        -o 02_demultiplex/ \
        -b $INFO_FILES/barcodes.txt \
        --barcode_dist_1 2 \
        -E phred33 \
        --inline_index \
        -c -r -q \
        --bestrad \
        -e $ENZYME
done

        
            #-p 01_trim \
             























## Command-line args:
source 000_SetUp.sh

R1=$1
R2=$2
OUTDIR=$3
DIR_STATS=$4
BARCODE_FILE=$5 ## Barcode_File - The barcode file for combinatorial barcodes is a text file with three columns separated by tabs; the first column is the barcode, the second column is the Illumina index, the third is the sample name

for i in {1..}; do mkdir scratch/Halibut_Reads/Lib$i; done


## Run:
$STACKS/process_radtags --paired -r --inline_null $INPUT_COMMAND -e $ENZYME1 \
	-1 $R1 -2 $R2 -o $OUTDIR -b $BARCODE_FILE -y gzfastq > $STATSFILE

# clean-up
rm $OUTDIR/*rem*
