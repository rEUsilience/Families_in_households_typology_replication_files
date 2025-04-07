***************************************************
*** 	Families in Households Typology (FHT) 	***
***************************************************


/*		In this script, the identification of family relations between household members
		that was executed in the previous scripts is combined and used in identification 
		of household types. 
		
		We define three basic family units:
		
		1. a single adult 
		2. a couple
		3. a nuclear family (couple or a single adult with at least one child)
		
		We used these three basic types of family unit in our household classification. 
		We first classified households occupied solely by either of these three basic 
		family units.
		In the next step, we identified household that contain more than one of these 
		family units. If the relation between the family unites was vertical (i.e. grandparent, 
		parent, grandchild), we classified the household as a multigenerational household. 
		If the relationship between the family units was horizontal (i.e. a nuclear family 
		co-residing with a sibling of one of the parents), we classified the household as "other".
		We decided not to create a special category for this type of households due to their 
		relatively low prevalence. 
		
		We also decided to break down some of the categories with children depending on whether 
		the household contains a dependent child (i.e. <18 or 18-24 if they are economically inactive)
		or adult children (i.e. >18 or 18-24 who are economically active).
		
	
*/


foreach x of global wave {

use "$DATA/silc20`x'_grandparent.dta", clear


browse country year hid pid mother_id father_id partner_id child1_id child2_id hx040 siblings grandparent

egen po = tag(country hid) // to select a representative of each HH


*** Identify single parents (with dependent and adult children)
gen sp = (child1_id != . & partner_id == .) // finds single parents 

egen single_parents = total(sp), by(country year hid) // calculates the number of single parents in a HH
lab var single_parents "Number of single parents in the HH"

*** Identify couples
gen prtnr = (partner_id != .) // finds persons who cohabit with their partner

egen partners = total(prtnr), by(country year hid) // calculates the number of couples in a HH
lab var partners "Number of persons with partners in the HH"

*** Identify dependent children
egen dc = rowtotal(child*_dep) // dependent children were identified in 'FHT_SILC_2021-2022_mothers' and 'FHT_SILC_2021-2022_fathers'. Those variables are used here. 
egen depchild = max(dc), by(country year hid)
lab var depchild "Number of dependent children in the HH"

*** Siblings 
egen sibs = max(siblings), by(country year hid) // siblings were identified for each respondent. This code spreads the sibling values for the whole household. If sibs = 1 => there is one paid of siblings in the HH, if sibs = 2, there are 3 siblings in the HH, etc.

*** Identify parents
gen parent = (child1_id != .)
lab var parent "R is a parent"

*** Identify potentially complex HH (apart from vertical family units - e.g. child, parent/s, grandparent - also contains horizontal family units - single sibling)
gen complex = (parent == 1 & siblings != 0) // when R is a parent and lives with their sibling
egen complex_hh = max(complex), by(country year hid)
lab var complex_hh "Potentially complex HH"


*** Families in Households Typology (FHT)

/*		The household types are coded from the simplest to the most complex households.
		An individual that fulfills the conditions is used as marking the household for a specific household type.
		At the end, the highest value (i.e. most complex) is used to identify the whole household. 
*/

* single person HH
gen hh_type = 1 			if hx040 == 1 // all HH with only one person 

* couples
replace hh_type = 2 		if hx040 == 2 & partner_id != . // all HH with only two persons who identify as partners

* single parent w/dependent children (i.e. at least one dependent child in the HH)
replace hh_type = 3 		if child1_id != . & partner_id == . & mother_id == . & father_id == . ///
							& unrelated == 0 & depchild != 0 & single_parents == 1 & partners == 0  // person who lives with at least one of their children who is identified as a dependent child, but without a partner, parents or unrelated person, and in a household that only contains one single parent and no couples (this is to avoid classification of complex households as single parent households)

							
* single parent w/adult children (i.e. all children in the HH are non-dependent)
replace hh_type = 4 		if child1_id != . & partner_id == . & mother_id == . & father_id == . /// 
							& unrelated == 0 & depchild == 0 & single_parents == 1 & partners == 0 // person who lives with at least one of their children who is but without a partner, parents

* couple w/dependent children (i.e. at least one dependent child in the HH)
replace hh_type = 5 		if child1_id != . & partner_id != . & mother_id == . & father_id == . /// 
							& unrelated == 0 & depchild != 0 & partners == 2 & grandparent == 0 // person who lives with a partner and at least one of their children who are dependent, doesn't live with either of their parent, unrelated person, there is only one couple in the HH and no grandparents
							

* couple w/adult children (i.e. all children in the HH are non-dependent)
replace hh_type = 6 		if child1_id != . & partner_id != . & mother_id == . & father_id == . /// 
							& unrelated == 0 & depchild == 0 & partners == 2 & grandparent == 0 // person who lives with a partner and child/ren who are adult/s, doesn't live with either of their parent, unrelated person, there is only one couple in the HH and no grandparents
							
* single parent w/dependent children & grandparents
replace hh_type = 7			if child1_id != . & partner_id == . & (mother_id != . | father_id != .) /// 
							& unrelated == 0 & depchild != 0 & grandparent == 1 & complex_hh == 0 // person who lives without a partner, at least one child who are all adults, and at least one of their parents, and with no sibling, in a HH that does not contain unrelated person, contains at least one grandparents

* single parent w/adult children & grandparents
replace hh_type = 8			if child1_id != . & partner_id == . & (mother_id != . | father_id != .) /// 
							& unrelated == 0 & depchild == 0 & grandparent == 1 & complex_hh == 0 // person who lives without a partner, at least one child who are all adults, and at least one of their parents, and with no sibling, in a HH that does not contain unrelated person, contains at least one grandparents
							

* couple w/dependent children & grandparents
replace hh_type = 9 		if child1_id != . & partner_id != . & (mother_id != . | father_id != .) /// 
							& unrelated == 0 & depchild != 0 & grandparent == 1 & complex_hh == 0 // person who lives with a partner, at least one child who are all adults, and at least one of their parents, and with no sibling, in a HH that does not contain unrelated person, contains at least one grandparents
							
* couple w/adult children & grandparent
replace hh_type = 10 		if child1_id != . & partner_id != . & (mother_id != . | father_id != .) ///
							& unrelated == 0 & depchild == 0 & grandparent == 1 & complex_hh == 0 // person who lives with a partner, at least one child who are all adults, and at least one of their parents, and with no sibling, in a HH that does not contain unrelated person, contains at least one grandparents

* couples with parents
replace hh_type = 11		if child1_id == . & partner_id != . & (mother_id != . | father_id != .) ///
							& unrelated == 0  & siblings == 0	// person who doesn't live with their child, with a partner and with at least one of their parents, without a sibling and an unrelated person		

		
/* 		Use the highest value to identify the whole household. 	*/
egen fht = max(hh_type), by(country year hid)


* other types of households (all remaining households)
replace fht = 12		if fht == .




lab var fht "Families in Household Typology (12 categories)" 
lab def fht_l 1 "Single adult HH" 2 "Couples" 3 "Single parents with dependent child" 4 "Single parents with adult child" 5 "Couples with dependent children" 6 "Couples with adult children" 7 "Single parents with dependent children, grandparents" 8 "Single parents with adult children, grandparents" 9 "Couples with dependent children, grandparents" 10 "Couples with adult children, grandparents" 11 "Couples with parents" 12 "Other"  
lab val fht fht_l 


save "$DATA/silc20`x'_FHT.dta", replace

}
