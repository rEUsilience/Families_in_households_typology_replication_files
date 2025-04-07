*******************************************************************
*** 	Families in Households Typology (FHT): MASTER file 		***
*******************************************************************


/*
		
		Author: 		Alzbeta Bartova
						Research Group on Social Policy, Social Work, Public Opinion and Population Dynamics (ReSPOND)
						Center for Sociological Research (CESO)
						KU Leuven, Belgium
		
		Contact: 		alzbeta.bartova@kuleuven.be
		
		Description: 	This code creates household typology based on familial relations (FHT)
						using the EU-SILC cross-sectional files. 
						We use the ID variables of respondents, their mothers, fathers and partners
						to identify familial relations of all household members to each other. 
		
		License: 		
		
		
		Data: 			EU-SILC 2023 release 2, DOI: 10.2907/EUSILC2004-2022V1	
		
		Link: 			https://ec.europa.eu/eurostat/documents/203647/16993001/EUSILC_DOI_2023_release_2.pdf		
		
		
 
*/


clear all
version 17.0 // set Stata version


* install if needed
//ssc install egenmore
//ssc install fre
//ssc install confirmdir


**#		 Macros

global SILC "/Users/alzbeta/Documents/Data/EU-SILC_merged" // to call the original SILC data
global DATA "/Users/alzbeta/Documents/Data/EU-SILC/SILC_replication" // to save the created dta files
global CODE "/Users/alzbeta/Library/CloudStorage/Box-Box/WORK/_PAPERS/rEUsilience publications/REU_WP2_research note/Families_in_households_typology_replication_files/EU-SILC/EU-SILC_2010-2020" // folder where the code is stored


**# 	PREPARATION AND CONSTRUCTION OF FHT

global wave "11 12 13 14 15 16 17 18 19 20" // to switch between waves

* The following code can only be used once! It makes changes to the source data files. 

foreach x of global wave {
	use "$SILC/SILC20`x'_ver_2023_release2", clear 
	gen inactive = inrange(pl031,6,11) 
	save "$SILC/SILC20`x'_ver_2023_release2", replace
}


foreach x of global wave {
**# 	Data Input
use "$SILC/SILC20`x'_ver_2023_release2", clear 


**# 	Country selection & rename key variables

		/* 		NOTE: 	Due to anonymisation, Malta doesn't use some of the crucial variables (age) and
						categorises others (year of birth).
						Malta is excluded from the analysis until we decide what to do with this issue. 	
		*/

		* drop Malta
		drop if country == "MT"


	** rename ID & crucial variables 

		rename rb220 father_id
		replace father_id = . 		if rb220_f == -1 
		rename rb230 mother_id
		replace mother_id = . 		if rb230_f == -1
		rename rb240 partner_id
		replace partner_id = . 		if rb240_f == -1

		rename rx010 age
		rename rb090 sex
		
	** missing values on "age" => replace missing values with estimate based on year of birth
		replace age = (year - rb080) if age == .
		replace age = 0 if age == (-1)
	
**# 	HOUSEHOLD COMPOSITION

sort country year hid pid

save "$DATA/silc20`x'_hhcomp", replace // Save before identifying the relationships within HH 
}



**# 	FAMILY RELATIONS within HOUSEHOLDS ***

/*		This part of the code identifies family relations within households based on the combination of mother, 
		father and partner ID variables. 
		By default, each household member has their own ID variable, the ID variable of their mother, father and 
		a partner. These ID variables correspond with the ID variables of the household members. 
		Our goal is to expand the series of ID variables (personal ID, mother ID, father ID, partner ID) of ID 
		variables of the other household members depending on their relationship to each person. 
		
		To identify the type of household, we then scanned each household for specific family relations. 
		
		
*/

	* create child ID variables for mothers - creates a dataset
run "$CODE/FHT_SILC_2010-2020_mothers.do"

	* create child ID variables for fathers - creates a dataset
run "$CODE/FHT_SILC_2010-2020_fathers.do"

	* identify unrelated individuals
run "$CODE/FHT_SILC_2010-2020_unrelated.do"
	
	* identify siblings
run "$CODE/FHT_SILC_2010-2020_siblings.do"

	* identify grandparents
run "$CODE/FHT_SILC_2010-2020_grandparents.do"

**# 	Families in Households Typology (FHT) ***
run "$CODE/FHT_SILC_2010-2020_typology.do"




**# 	Delete irrelevant datasets

foreach x of global wave {

	erase "$DATA/silc20`x'_mother.dta"
	erase "$DATA/silc20`x'_father.dta"
	erase "$DATA/silc20`x'_parents.dta"
	erase "$DATA/silc20`x'_unrelated.dta"
	erase "$DATA/silc20`x'_siblings.dta"
	erase "$DATA/silc20`x'_grandparent.dta"
	erase "$DATA/silc20`x'_hhcomp.dta" 
}
