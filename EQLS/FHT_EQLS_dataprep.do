***************************************
*** 	EQLS: Data preparation 		***
***************************************



*** 	Rename variables

rename Y16_uniqueid pid
rename Y16_HH1 hhsize
rename Y16_HH2a sex
rename Y16_HH2b age
rename Y16_HH2d empstatus
rename Y16_Country country
rename Wave wave

foreach x of numlist 2/10 {
	
	rename Y16_HH3a_`x' sex_p`x'
	rename Y16_HH3b_`x' age_p`x'
	rename Y16_HH3c_`x' rlshp_p`x'
	rename Y16_HH3d_`x' empstat_p`x'
}



*** Dealing with missing data

/* Delete Respondents who have 'unknown' values on relationship with other HH members */

foreach x of numlist 2/10 {
	
	drop if rlshp_p`x' == 998 | rlshp_p`x' == 998 | rlshp_p`x' == 998 
}
