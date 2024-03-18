#!/bin/bash
# Version 1 (initiated 03/08/2024)
#
# SumarizeNibabies Path_to_nibabies_result_directory OutputFile.csv

# Check usage, 2 argument expected.
if [ "$#" -ne 2 ]; then
  echo "Illegal number of parameters provided"
  echo "Expected usage: SumarizeNibabies Path_to_nibabies_result_directory OutputFile.csv"
  echo "I would terminate"
  exit 10
fi
inpt_dir=$1
outpt_file=$2

echo "Processing the $inpt_dir for nibabies summarization and writing the output to $outpt_file"

# Check for existance of input directory
if [ -d $inpt_dir ]; then
    echo 'Input Directory exists, let us forge ahead'
else
    echo 'Input Directory does not exist, we can no longer go on like this...'
    exit 20
fi

# Scan nibabies directory for confounds files
COUNTER=0
fcmd="find ${f} -name \"*confounds_timeseries.tsv\" -print"
#echo "fcmd = $fcmd"
#for f in `$fcmd` ; do	
for f in ` find ${inpt_dir} -iname "*confounds_timeseries.tsv" `  ; do
    let COUNTER=COUNTER+1
    echo "Processing $f"

    # File decoders
    # Decode Subject
    subj=`awk '{ sub(/.*sub-/, ""); sub(/_.*/, ""); print }' <<< $f `
    # Decode Session
    sess=`awk '{ sub(/.*ses-/, ""); sub(/_.*/, ""); print }' <<< $f `
    # Decode Task
    task=`awk '{ sub(/.*task-/, ""); sub(/_.*/, ""); print }' <<< $f `
    # Decode Run
    run=`awk '{ sub(/.*run-/, ""); sub(/_.*/, ""); print }' <<< $f `

    echo "Subject = $subj, Session = $sess, Task = $task, Run = $run"
	

	# For the columns we care about...
	# FD "framewise_displacement"
	col="framewise_displacement"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	#tail -n +3 file1.txt > file1a.txt
	fdavg=`awk 'NR>2 {s+=$1}END{print "ave:",s/(NR-2)}' RS="\n"  file1.txt`
	echo "fdavg = $fdavg"
	# "trans_x"
	#col="trans_x"
	#awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file2.txt
	
	
	
done

# Display number of results proessed
echo "We pocessed $COUNTER files, hooray!"






exit
