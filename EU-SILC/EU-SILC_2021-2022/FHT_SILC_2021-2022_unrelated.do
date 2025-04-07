***********************************************
*** 	identify UNRELATED members of HH 	***
***********************************************

/*
		This code identifies people who are not related to anyone in the household.
		
		Unrelated person is a person who does not live alone, but does not co-reside
		with their mother, father, partner or a child. 
		
		Limitations: 
		The number of unrelated persons in EU-SILC is likely to be overestimated.
		Some people can still be related but this relationship couldn't be detected
		with the data. For example, siblings can only be detected if they share the 
		household with at least one of their parents. 
		
		This code merely flags individuals who cannot be related to the other household members. 
		It does not create their unique ID variable as we did with children's IDs.
		
*/


foreach x of global wave {

use "$DATA/silc20`x'_parents.dta", clear

gen unrel = (mother_id == . & father_id == . & partner_id == . & child1_id == . & hx040 != 1)

egen unrelated = max(unrel), by(country year hid)

save "$DATA/silc20`x'_unrelated.dta", replace

}
