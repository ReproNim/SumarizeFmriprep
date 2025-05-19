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

# Check for existence of input directory
if [ -d $inpt_dir ]; then
    echo 'Input Directory exists, let us forge ahead'
else
    echo 'Input Directory does not exist, we can no longer go on like this...'
    exit 20
fi

# Check for nonexistence of output file
if [ -f $outpt_file ]; then
    echo 'Output file exists, let us stop'
	exit 30
else
    echo 'Output file does not exist, we can proceed without doing damage...'
fi

# Write output file header
echo "Subject, Session, Task, Run, FD_AVG, FD_STD, XTrans_AVG, XTrans_STD, YTrans_AVG, YTrans_STD, ZTrans_AVG, ZTrans_STD, \
	XRot_AVG, XRot_STD, YRot_AVG, YRot_STD, ZRot_AVG, ZRot_STD, CSF_AVG, WhiteMatter_AVG, Global_AVG, Outliers" >> $outpt_file

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
	fdavg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	fdstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "trans_x"
	col="trans_x"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	xtavg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	xtstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "trans_y"
	col="trans_y"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	ytavg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	ytstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "trans_z"
	col="trans_z"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	ztavg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	ztstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "rot_x"
	col="rot_x"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	xravg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	xrstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "rot_y"
	col="rot_y"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	yravg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	yrstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "rot_z"
	col="rot_z"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	zravg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	zrstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "csf"
	col="csf"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	csfavg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	csfstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "white_matter"
	col="white_matter"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	wmavg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	wmstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# "global_signal"
	col="global_signal"
	awk -v column_val="$col" '{ if (NR==1) {val=-1; for(i=1;i<=NF;i++) { if ($i == column_val) {val=i;}}} if(val != -1) print $val} ' $f  > file1.txt
	gsavg=`awk 'NR>2 {s+=$1}END{print s/(NR-2)}' RS="\n"  file1.txt`
	#echo "fdavg = $fdavg"
	gsstd=$(
	    tail -n +3 file1.txt |
	        awk 'NR>2 {sum+=$1; sumsq+=$1*$1}END{print sqrt(sumsq/(NR-1) - (sum/(NR-1))**2)}'
	)
	#echo " FD std = $fdstd"
	rm file1.txt
	
	# Outlier Count
	header=$(head -1 $f)
	#echo "Header = $header"
	oct=${header: -2}
	#echo "Outlier Count = $oct"
	
	# Write output file
	echo "$subj, $sess, $task, $run, $fdavg, $fdstd, $xtavg, $xtstd, $ytavg, $ytstd, $ztavg, $ztstd, \
		$xravg, $xrstd, $yravg, $yrstd, $zravg, $zrstd, $csfavg, $wmavg, $gsavg, $oct" >> $outpt_file
	
done

# Display number of results proessed
echo "We processed $COUNTER files, hooray!"






exit
