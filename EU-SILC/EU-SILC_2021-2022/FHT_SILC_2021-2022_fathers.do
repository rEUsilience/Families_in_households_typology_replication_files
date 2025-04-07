***********************************************
*** 	CHILD ID variables for FATHERS 		***
***********************************************

/* 		EU-SILC only includes ID variables of parents and partners. This means that if a HH member has a co-residing child, we don't know
		which HH member it is.
		
		This code creates a sub-dataset of fathers with their children's ID variables in a wide format 
		(child1_id for the first child, child2_id for the second child, etc.) that is then
		merged with the original dataset. 
		
		The code includes all children regardless their age (including adult children). 
*/


foreach x of global wave {
use "$DATA/silc20`x'_hhcomp", clear


keep country year hid pid partner_id father_id father_id age sex inactive // keep only the necessary variables 


**# 		Rank Children

/* 	All children in the HH are ranked from oldest to the youngest by father_id. 
	The rank number will be then used in numbering children's ID variables.
	Example: rank = 1 => child1_id = ID number of the woman's first child who co-reside with her in the HH
*/

egen childrank = rank(-age) if father_id != ., by(father_id hid country year) unique // rank all the children in the HH who have the same "father_id" by age from the oldest to the youngest



**#			Dependent children

/* 		This code identifies individuals who can be classified as dependent children based on the following rules:
		- age < 18
		- age 18-24, economically inactive, living with their parents
		- number of dependent children = under 18 & 18-24 if inactive and living with their parent/s
*/


* flag the children who can be classified as dependent
gen dep = inrange(age,0,17) 
replace dep = 1 if dep == 0 & inrange(age,18,24) & inactive == 1 & father_id != .


**# 		Create children's IDs

/* 		The ID numbers of HH members who are children in the HH (i.e. live with their father) 
		will be turned into child ID variables. Eventually, "father_id" will be renamed to 
		"pid" and linked the original dataset. 
		
		This will produce a set of child ID variables for those respondents who are men 
		and live with their children. 
*/

sort country year hid
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variation in the number of children per father in each wave
	by country year hid: gen double c`i'_id = pid if childrank == `i' // create temporary child ID variables
	egen double f_child`i'_id = max(c`i'_id), by(father_id country year hid) // this code stretches the temporary child ID variables across the household (i.e. long); this way the child ID variable will be added to the line of the father's ID.
	format f_child`i'_id %12.0g
	drop c`i'_id
	
	* identifying individual children as dependent or adult
	by country year hid: gen double c`i'_dep = dep if childrank == `i'
	egen double f_child`i'_dep = max(c`i'_dep), by (father_id country year hid)
	format f_child`i'_dep %12.0g
	drop c`i'_dep
}


* to link the children's information to father, drop the child's pid and turn father_id into a pid 
drop pid
rename father_id pid // renames father_id into pid so it can be merged with the original dataset

egen po = tag(country year hid pid) // tags one observation per pid (formerly father_id), household, country and year

keep if po == 1 // keeps only the selected observarvations
keep pid hid country year f_child*_id f_child*_dep // keep only the important variables


save "$DATA/silc20`x'_father", replace // creates dataset of fathers, which will be merged with the "silc`wave'_mother.dta" in "REU_SILC_CS_hhcomp_parents.do"

**# 		Merge the father's dataset with the previously merged dataset from FHT_SILC_2021-2022_mothers

use "$DATA/silc20`x'_mother.dta", clear

merge 1:1 pid hid country year using "$DATA/silc20`x'_father.dta", keep(1 3) // this dataset was created in "REU_SILC_CS_hhcomp_fathers.do"
drop _merge 

sort country hid pid

**# 		Rename child's variables for fathers

	/* 		NOTE: 	the prefix "f_" was created for child's indicators among fathers. Without it, the information doesn't merge and the child ID values
					remain "." for fathers. The prefix makes sure that the information is merged properly. 
					I'm not sure why this is happening but using the prefix was an easy and quick solution. OPEN TO SUGGESTIONS !! 		
					
					This code is replacing the missing values on child's information among fathers with the values on variables 
					with prefix "f_" created in "REU_SILC_CS_hhcomp_fathers" */
					
					
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variable number of children per parent in each HH
	
	replace child`i'_id = f_child`i'_id if sex == 1 // replace the missing values of child*_id with f_child*_id for fathers
	drop f_child`i'_id
	
	replace child`i'_dep = f_child`i'_dep if sex == 1 
	drop f_child`i'_dep
	}

**# 	Save the dataset
save "$DATA/silc20`x'_parents.dta", replace

}


