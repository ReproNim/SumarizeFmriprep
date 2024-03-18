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

| Subj    | Session | Task | Run | FD | trans_x |trans\_y | trans\_z | rot\_x | rot\_y | rot\_z | CSF | WM | Global | Outliers |
| ------- | ------- | ----| ----| ----| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| BB06601 | 1       | rest | 02 |
| BB06601 | 1       | rest | 03 |



Example Script call:

> \> SumarizeNibabies.sh ~/Data/Sohye/Infants/CHBabies/BB066_01/nibabies/ OutputFile.csv


             




