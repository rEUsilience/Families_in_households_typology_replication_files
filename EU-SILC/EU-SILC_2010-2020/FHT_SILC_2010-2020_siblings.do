*******************************
*** 	SIBLINGS ID 		***
*******************************


/*	Siblings can only be identified if they are sharing HH with at least one
	of their parents! Siblings who do not live with their parents don't have
	any ID links with their real siblings. 
	
	This code creates ID variables for all siblings. 
*/


foreach x of global wave {
use "$DATA/silc20`x'_unrelated.dta", clear


/* count siblings by mother_id. Use father_id if mother is not part of the HH. */


* number of maternal siblings (i.e. share a mother)
egen sib = rank(pid) if mother_id != ., by(mother_id hid country year)

* number of paternal siblings (i.e. share a father and were not coded in "sib" above)
egen sib2 = rank(pid) if mother_id == . & father_id != ., by(country year hid father_id)


**# Number of siblings in the HH
egen siblings = max(sib) if mother_id != ., by(mother_id hid country year)
egen siblings2 = max(sib2) if mother_id == . & father_id != ., by(country year hid father_id)

replace siblings = siblings2 if siblings == . & siblings2 != .
replace siblings = siblings - 1 if siblings != . // to indicate how many siblings R has in the HH
replace siblings = 0 if siblings == .

lab var siblings "Number of siblings R has in the HH"

drop sib sib2 siblings2


* rank the siblings to create their ID
egen sibrank = rank(pid) if siblings != 0 & mother_id != ., by(country year hid mother_id)
egen sibrank2 = rank(pid) if siblings != 0 & mother_id == ., by(country year hid father_id)

replace sibrank = sibrank2 if sibrank == . & sibrank2 != . // create one rank of siblings from sibrank and sibrank2
drop sibrank2



* create each sibling's ID 
sort country year hid mother_id 
foreach i of numlist 1/12 {
	
	by country year hid mother_id: gen long sib`i'_id = pid if sibrank == `i' 
	
	egen long sibling`i'_id = max(sib`i'_id), by(mother_id country year hid) // creates sibling ID for those who share a mother
	egen long sibling`i'_id2 = max(sib`i'_id), by(father_id country year hid) // creates sibling ID for those who share a father but not mother
	
	replace sibling`i'_id = sibling`i'_id2 if mother_id == . & father_id != . & sibling`i'_id == . // create one sibling ID
	
	replace sibling`i'_id = . if sibling`i'_id == pid // creates a missing value for sibling ID if that is identical with the personal ID
	
	drop sib`i'_id sibling`i'_id2
}

sort country year hid pid


/* 	NOTE: 	if siblings are present in the HH, missing values on SIBLING ID indicates the position 
			of the R among their siblings (e.g. 'sibling2_id == .' => R is the 2nd sibling) 
*/ 


save "$DATA/silc20`x'_siblings.dta", replace
}
