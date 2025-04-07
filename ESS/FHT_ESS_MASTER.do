******************************
*** EUROPEAN SOCIAL SURVEY ***
******************************

/*
		
		Author: 		Alzbeta Bartova
						Research Group on Social Policy, Social Work, Public Opinion and Population Dynamics (ReSPOND)
						Center for Sociological Research (CESO)
						KU Leuven, Belgium
		
		Contact: 		alzbeta.bartova@kuleuven.be
		
		Description: 	This code creates household typology based on familial relations (FHT)
						using data from ESS Round 11. 
		
		License: 		
		
		
		Data: 			ESS Round 11, DOI: 10.21338/ess11e02_0

		
		Link: 			https://ess.sikt.no/en/datafile/242aaa39-3bbb-40f5-98bf-bfb1ce53d8ef		
		
 
*/


clear all
log close _all // closes all open logs
version 17.0 // The code was written in Stata 17.0. This line sets Stata to that version.    

* Set directories
global DATA "/Users/alzbeta/Documents/Data/ESS/ESS11" // directory for for a folder where the data is stored
global CODE "/Users/alzbeta/Library/CloudStorage/Box-Box/WORK/_PAPERS/rEUsilience publications/REU_WP2_research note/Families_in_households_typology_replication_files/ESS" // directory for a folder where the code is stored


* Stata commands used:
//ssc install fre
//ssc install iscogen

use "$DATA/ESS11.dta", clear // opens the downloaded ESS data. For information on the content of the data se README. The original DTA file was renamed to "ESS_5_10".

run "$CODE/FHT_ESS_year"

run "$CODE/FHT_ESS_depchildren"

run "$CODE/FHT_ESS_typology"


save "$DATA/FHT_ESS11.dta", replace
