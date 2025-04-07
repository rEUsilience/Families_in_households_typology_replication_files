*******************************
*** HOUSEHOLD BUDGET SURVEY ***
*******************************


/*
		
		Author: 		Alzbeta Bartova
						Research Group on Social Policy, Social Work, Public Opinion and Population Dynamics (ReSPOND)
						Center for Sociological Research (CESO)
						KU Leuven, Belgium
		
		Contact: 		alzbeta.bartova@kuleuven.be
		
		Description: 	The Household Budget Survey (HBS) was released twice (2010 & 2015). 
						It contains two files - household file (hh) and a file with the household members (hm).

						The code prepares the dataset for the Families in Households typology (FHT).
		
		License: 		
		
		
		Data: 			HBS 	
		
		Link: 					
		
 
*/


/*

Due to anonymisation, Malta has different categories than most of the countries in the sample.   
Due to possible issues caused by different categorisation, Malta is excluded in this version of the code.
 
*/

clear all

global DATA "[YOUR DIRECTORY]"
global CODE "[YOUR DIRECTORY]"

cd "$DATA"

clear

*** transform into Stata files
	/* 	HBS is distributed as a collection of XLS files. 
		The following code transforms the XLS files into DTA files 
		and saves them as temp files. */
foreach x in "BE" "BG" "CY" "CZ" "DE" "DK" "EE" "EL" "ES" "FI" "FR" "HR" "HU" "IE" "IT" "LT" "LU" "LV" "PL" "PT" "RO" "SE" "SI" "SK" "UK" {
	
		import excel using "$DATA/2016-09-02-SUF-ALL/`x'_HBS_hh.xlsx", firstrow clear 
		save `x'_HBS_hh_temp.dta, replace
		
		import excel using "$DATA/2016-09-02-SUF-ALL/`x'_HBS_hm.xlsx", firstrow clear
		save `x'_HBS_hm_temp.dta, replace
}


* replace "NA" values with ".a" 
	/* 	The original XLS files contain variables with both numerical and non-numerical 
		values. The transformation into DTA turned all these variables into strings. 
		The following code:
			-> identifies string variables
			-> changes non-numerical values into numerical
			-> turns string variables into numerical 
			-> deletes temporary files created in the previous step 
			-> this is done on both HH and HM files */

foreach x in "BE" "BG" "CY" "CZ" "DE" "DK" "EE" "EL" "ES" "FI" "FR" "HR" "HU" "IE" "IT" "LT" "LU" "LV" "PL" "PT" "RO" "SE" "SI" "SK" "UK" {
	
	use `x'_HBS_hh_temp.dta, clear
	drop if HA04 == .
	findname, type(string) local(strings) // identify string variables, place them in local
	
		foreach var of local strings { // changes non-numerical values into numerical form
	
			replace `var' = ".a" if `var' == "NA"
			
			replace `var' = "1" if `var' == "Z1"
			replace `var' = "2" if `var' == "Z2"
			replace `var' = "3" if `var' == "Z3"
			replace `var' = "4" if `var' == "Z4"
			replace `var' = "5" if `var' == "Z5"
			replace `var' = "6" if `var' == "Z6"
			replace `var' = "7" if `var' == "Z7"
			replace `var' = "8" if `var' == "Z8"
			replace `var' = "9" if `var' == "Z9"
			
			destring `var', replace // turns string variables into numerical
						
	}
	
	save `x'_HBS_hh.dta, replace
	
	erase "$DATA/`x'_HBS_hh_temp.dta" // deletes temporary files
}


foreach x in "BE" "BG" "CY" "CZ" "DE" "DK" "EE" "EL" "ES" "FI" "FR" "HR" "HU" "IE" "IT" "LT" "LU" "LV" "PL" "PT" "RO" "SE" "SI" "SK" "UK" {
	
	use `x'_HBS_hm_temp.dta, clear
	drop if MA04 == .
	gen long HA04 = MA04 // specify long to match the HA04 in hh file otherwise observations won't be matched in some datasets
	findname, type(string) local(strings2)
	
		foreach var of local strings2 {
	
			replace `var' = ".a" if `var' == "NA"
			
			replace `var' = "1" if `var' == "Z1"
			replace `var' = "2" if `var' == "Z2"
			replace `var' = "3" if `var' == "Z3"
			replace `var' = "4" if `var' == "Z4"
			replace `var' = "5" if `var' == "Z5"
			replace `var' = "6" if `var' == "Z6"
			replace `var' = "7" if `var' == "Z7"
			replace `var' = "8" if `var' == "Z8"
			replace `var' = "9" if `var' == "Z9"
	
			destring `var', replace
			
	}
	
	save `x'_HBS_hm.dta, replace
	
	erase `x'_HBS_hm_temp.dta
}


* merge hm with hh files and label crucial variables
	/*	This code merges the household files with the household members' files.
		It also adds labels to some of the crucial variables and their values */

foreach x in "BE" "BG" "CY" "CZ" "DE" "DK" "EE" "EL" "ES" "FI" "FR" "HR" "HU" "IE" "IT" "LT" "LU" "LV" "PL" "PT" "RO" "SE" "SI" "SK" "UK" {
	
	use `x'_HBS_hh, clear
	mer 1:m HA04 YEAR COUNTRY using `x'_HBS_hm 
	
	run "$CODE/REU_HBS/REU_HBS_labels_members" // labels for HM file
	run "$CODE/REU_HBS/REU_HBS_labels_hh" // labels for HH files

	save `x'_HBS_merged, replace	
}



* append files

use BE_HBS_merged.dta, clear 
	
foreach x in "BG" "CY" "CZ" "DE" "DK" "EE" "EL" "ES" "FI" "FR" "HR" "HU" "IE" "IT" "LT" "LU" "LV" "PL" "PT" "RO" "SE" "SI" "SK" "UK" {
			
		append using `x'_HBS_merged.dta, force
		
}

* create unique IDs
run "$CODE/REU_HBS/REU_UID"


save HBS_complete, replace



foreach x in "BE" "BG" "CY" "CZ" "DE" "DK" "EE" "EL" "ES" "FI" "FR" "HR" "HU" "IE" "IT" "LT" "LU" "LV" "PL" "PT" "RO" "SE" "SI" "SK" "UK" {
			
		erase `x'_HBS_merged.dta
		erase `x'_HBS_hh.dta
		erase `x'_HBS_hm.dta
		
}
