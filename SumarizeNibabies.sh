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
for f in `ls -R $inpt_dir | grep confounds_timeseries.tsv` ; do
    let COUNTER=COUNTER+1
    echo "Processing $f"

    #Decode Subject
    subj=`awk '{ sub(/.*sub-/, ""); sub(/_.*/, ""); print }' <<< $f `
    #Decode Session
    sess=`awk '{ sub(/.*ses-/, ""); sub(/_.*/, ""); print }' <<< $f `
    #Decode Task
    task=`awk '{ sub(/.*task-/, ""); sub(/_.*/, ""); print }' <<< $f `
    #Decode Run
    run=`awk '{ sub(/.*run-/, ""); sub(/_.*/, ""); print }' <<< $f `

    echo "Subject = $subj, Session = $sess, Task = $task, Run = $run"
done

# Display number of results proessed
echo "We pocessed $COUNTER files, hooray!"






exit
