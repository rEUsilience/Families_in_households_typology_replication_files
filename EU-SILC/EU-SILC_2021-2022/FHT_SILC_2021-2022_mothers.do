***********************************************
*** 	CHILD ID variables for MOTHERS 		***
***********************************************


/* 
		EU-SILC only includes ID variables of parents and partners. This means that if a HH member has a co-residing child, we don't know
		which HH member it is.
		
		This code creates a sub-dataset of mothers with their children's ID variables in a wide format 
		(child1_id for the first child, child2_id for the second child, etc.) that is then
		merged with the original dataset. 
		
		The code includes all children regardless their age (including adult children). 
		
*/

foreach x of global wave {
use "$DATA/silc20`x'_hhcomp", clear


keep country year hid pid partner_id mother_id father_id age sex inactive // keep only the necessary variables 


**# 		Rank Children

/* 	All children in the HH are ranked from oldest to the youngest by mother_id. 
	The rank number will be then used in numbering children's ID variables.
	Example: rank = 1 => child1_id = ID number of the woman's first child who co-reside with her in the HH
*/

egen childrank = rank(-age) if mother_id != ., by(mother_id hid country year) unique // rank all the children in the HH who have the same "mother_id" by age from the oldest to the youngest
//fre childrank



**#			Dependent children

/* 		This code identifies individuals who can be classified as dependent children based on the following rules:
		- age < 18
		- age 18-24, economically inactive, living with their parents
		- number of dependent children = under 18 & 18-24 if inactive and living with their parent/s
*/

* flag the children who can be classified as dependent
gen dep = inrange(age,0,17) // <18
replace dep = 1 if dep == 0 & inrange(age,18,24) & inactive == 1 & mother_id != . // 18-24, economically inactive & living with mother


**# 		Create children's IDs

/* 		The ID numbers of HH members who are children in the HH (i.e. live with their mother) 
		will be turned into child ID variables. Eventually, "mother_id" will be renamed to 
		"pid" and linked the original dataset. 
		
		This will produce a set of child ID variables for those respondents who are women 
		and live with their children. 
*/

sort country year hid
foreach i of numlist 1/30 { // 1/30 refers to the childrank. It's deliberately chosen high to account for the variation in the number of children per mother in each wave
	by country year hid: gen double c`i'_id = pid if childrank == `i' // creates a temporary child ID variables
	egen double child`i'_id = max(c`i'_id), by(mother_id country year hid) // this code stretches the temporary child ID variables across the household (i.e. long); this way the child ID variable will be added to the line of the mother's ID.
	format child`i'_id %12.0g
	drop c`i'_id
	
	* identifying individual children as dependent or adult
	by country year hid: gen double c`i'_dep = dep if childrank == `i'
	egen double child`i'_dep = max(c`i'_dep), by (mother_id country year hid)
	format child`i'_dep %12.0g
	drop c`i'_dep
}


* to link the children's information to mother, drop the child's pid and turn mother_id into a pid 
drop pid
rename mother_id pid // renames mother_id into pid so it can be merged with the original dataset

egen po = tag(country year hid pid) // tags one observation per pid (formerly mother_id), household, country and year

keep if po == 1 // keeps only the selected observarvations
keep pid hid country year child*_id child*_dep // keep only the linking variables (pid hid country year) and the ID variables for each child

save "$DATA/mother_20`x'", replace // save temporary file only containing mothers for merging purposes


**# 		Merge the mother's dataset with the SILC dataset

*** merge the children with the mothers in the main dataset
use "$DATA/silc20`x'_hhcomp", clear
drop _merge

merge 1:1 pid hid country year using "$DATA/mother_20`x'", keep(1 3)
drop _merge


**# 		Save dataset
save "$DATA/silc20`x'_mother", replace // dataset containing original data and basic information about children who live with their mother


erase "$DATA/mother_20`x'.dta" // delete useless files
}

