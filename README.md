# SumarizeNibabies
 A script to generate a session summary from a nibabies (fmriprep-babies) analysis


## Canonical form of a *nibabies* output

Documentation for nibabies output can be found [here](https://fmriprep.org/en/latest/outputs.html)





## A functional run's derived variables

Each functional run generates a file called: 
sub\-XXXX\_ses\-Y\_task\-{rest, other\_task\_name}\_run\-ZZ\_desc\-confounds\_timeseries.tsv

(or specifically, for example:
sub\-BB06601\_ses\-1\_task\-rest\_run\-02\_desc\-confounds\_timeseries.tsv)

While this *confound* file contains a large number of metrics, we have specific interest in sumarising the following metrics:

* Estimated **head-motion parameters** - the 6 rigid-body motion parameters (3 translations and 3 rotation), estimated relative to a reference image: 

	* trans_x 
	* trans_y 
	* trans_z 
	* rot_x 
	* rot_y 
	* rot_z

* **bulk-head motion** calculated using formula proposed by [[Power2012](https://www.sciencedirect.com/science/article/abs/pii/S1053811911011815?via%3Dihub)]
	* framewise_displacement (FD)

* **Global signals**:

	* csf - the average signal within anatomically-derived eroded CSF mask;
	
	* white_matter - the average signal within the anatomically-derived eroded WM masks;
	
	* global_signal - the average signal within the brain mask.

* **Count of motion outliers** - Scans occuring at times of particularly high motion are flagged by the motion\_outlierXX column. For summary, we want the count of 'motion_outliers' (or equally, the largest XX).  

# The Summariser Tool
Given a pointer to a nibabies result directory, find each functional run, and create a table that aggregates the following content:

| Subj    | Session | Task | Run | FD\_AVG | FD\_STD | trans\_x\_AVG | trans\_x\_STD | trans\_y\_AVG | trans\_y\_STD | trans\_z\_AVG | trans\_z\_STD | rot\_x\_AVG | rot\_x\_STD | rot\_y\_AVG | rot\_y\_STD |rot\_z\_AVG | rot\_z\_STD |  CSF | WM | Global | Outliers |
| ------- | ------- | ----| ----| ----| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BB06601 | 1       | rest | 02 |
| BB06601 | 1       | rest | 03 |


**Note:** We can debate if the STD values are useful or not...

Example Script call (on DNK's system locally):

> \> ./SumarizeNibabies.sh ~/Data/Sohye/Infants/CHBabies/BB066_01/nibabies/ ExampleOutput/OutputFile.csv


  
See the example real output [here](ExampleOutput/OutputFile.csv).          


**Still TODO: Outlier Count!**

The example file: /Users/kennedyd/Data/Sohye/Infants/CHBabies/BB066\_01/nibabies//sub-BB06601/ses\-1/func/sub\-BB06601\_ses\-1\_task-stories3\_run-06\_desc-confounds\_timeseries.tsv

has the following outliers identified:
> motion\_outlier00	motion\_outlier01	motion\_outlier02	motion\_outlier03	motion\_outlier04	motion\_outlier05	motion\_outlier06	motion\_outlier07

We can get the complete header line with:

> \> head -1 /Users/kennedyd/Data/Sohye/Infants/CHBabies/BB066_01/nibabies//sub-BB06601/ses-1/func/sub-BB06601_ses-1_task-stories3_run-06_desc-confounds_timeseries.tsv

**IF** we assume that the motion\_outlier fields are last, and in numeric order, perhaps we can just extract the last two digits of the line... This is fragile (assums < 100, and that there is at least one outlier, for example as well as other things), so it really should be upgraded...

But, we can put the headerline in a string:

header=`head -1 $inpt_file`

and grab the last two digits:

oct=${header: -2}






