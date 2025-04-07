*******************************************
*** 	ESS - HOUSEHOLD COMPOSITION 	***
*******************************************

/* 
		ESS is a cross-sectional survey of individuals (i.e. not a household survey).
		Respondents (R) answer basic household questions:
			- number of persons in the household occupied by R
			- relationship of each HH member to R
			- year of birth of each HH member
			
		We use the information on relationship of HH members to the respondent (rshipa#)
		to construct the household typology. 
		
		It is important to point out that ESS respondents are 15 years old and older. 
		This is important for understanding the relationship dynamic when constructing
		the code for the household typology - we need to take into consideration the 
		different perspectives of the respondents (e.g. respondent is a parent living 
		in a household with their children and respondent who is living in a household 
		with their parents and a sibling are both living in the same type of household. 
		However, they will need to be coded differently to reflect their position in 
		the household and identify the correct household type).
		
		
*/

*** 	Preparing the data	***
*******************************

*** Dealing with missing data

/*	Respondents can refuse to answer any question so we first deal with missing data on relationships between HH members */

foreach x of numlist 2/12 {
	
	drop if rshipa`x' == .b | rshipa`x' == .c | rshipa`x' == .d // delete respondents with refusals, don't know and no answers on questions about relationships between HH members
}


*** Identify relations within households 	***
***********************************************

	/* 	-> based on categories of rshipa* variables 
		-> identifies relationship with each member of the household */ 
	

* create a variable for each category of rshipa# - a value of 1 or 0 is assigned to the variable if this relation is part of the HH
gen partner = .
gen parent = .
gen child_own = .
gen sibling = .
gen other_rel = .
gen other_nonrel = .

gen hh_depchild = . // dependent child in the HH

foreach x of numlist 2/12 { // numlist is based on the number of rshipa# variables
	
 	replace rshipa`x' = 0 	if rshipa`x' == .a // recode to 0 if the response is not applicable

	replace partner = 1 if rshipa`x' == 1 // code partners
	replace partner = 0 if partner == . 

	replace child_own = 1 if rshipa`x' == 2 // code children (also includes step, adopted and foster)
	replace child_own = 0 if child_own == . 
	
	replace parent = 1 if rshipa`x' == 3 //  code parent
	replace parent = 0 if parent == . 
	
	replace sibling = 1 if rshipa`x' == 4 //  code sibling
	replace sibling = 0 if sibling == . 
	
	replace other_rel = 1 if rshipa`x' == 5 // code other relative
	replace other_rel = 0 if other_rel == . 
	
	replace other_nonrel = 1 if rshipa`x' == 6 // code other non-related HH member
	replace other_nonrel = 0 if other_nonrel == . 
	
	
	gen partner_`x' = 1 if rshipa`x' == 1 // marks HH member `x' as R's partner 
	
	gen child_own_`x' = 1 if rshipa`x' == 2 // marks HH member `x' as a R's child
	
	gen parent_`x'= 1 if rshipa`x' == 3 //  marks HH member `x' as R's parent 
	
	gen sibling_`x' = 1 if rshipa`x' == 4 //  marks HH member `x' as R's sibling
	
	gen other_rel_`x' = 1 if rshipa`x' == 5 //  marks HH member `x' as R's other relative
	
	gen other_nonrel_`x' = 1 if rshipa`x' == 6 //  marks HH member `x' as R's non-relative
	
	replace hh_depchild = 1 if rshipa`x' == 4 & (year - yrbrn`x') < 18 // marks presence of a depedent child in the HH

}

* Calculate the number of each relation in the HH - this is used mainly when R is a child to identify whether they live with one or two parents
egen partner_n = rowtotal(partner_*)
egen child_n = rowtotal(child_own_*)
egen parent_n = rowtotal(parent_*)
egen sibling_n = rowtotal(sibling_*)
egen other_rel_n = rowtotal(other_rel_*)
egen other_nonrel_n = rowtotal(other_nonrel_*)



*** 	Typology 	***
***********************

/*	The categories of the FHT are based on the categories we identified using EU-SILC data (see codes for EU-SILC for more detail) */

gen fht = .

replace fht = 1 		if partner == 0 & parent == 0 & child_own == 0 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 0 // single-person hh


replace fht = 2			if hhmmb == 2 & partner == 1 & fht == . // couple


replace fht = 3			if partner == 0 & parent == 0 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 1 & fht == . // single parent with at least one dependent child 
replace fht = 3			if partner == 0 & parent == 1 & child_own == 0 & other_rel == 0 & other_nonrel == 0 & fht == . & parent_n == 1 & agea < 18 // R is less than 18 years old, lives with one parent. Siblings can be present in the HH, no other relatives and non-related HH members. 
replace fht = 3			if partner == 0 & parent == 1 & child_own == 0 & sibling == 1 & other_rel == 0 & other_nonrel == 0 & parent_n == 1 & agea > 18 & hh_depchild == 1 // R is 18+ years old, lives with one parent BUT has at least one sibling who is less than 18 years old



replace fht = 4 		if partner == 0 & parent == 0 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 0 & fht == . // single parent with adult child/ren 
replace fht = 4 		if partner == 0 & parent == 1 & child_own == 0 & other_rel == 0 & other_nonrel == 0 & fht == . & parent_n == 1 & agea >= 18 // R is 18+ years old and lives with one parent. Siblings can be present in the HH, no other relatives and non-related HH members. 
replace fht = 4 		if partner == 0 & parent == 1 & child_own == 0 & other_rel == 0 & other_nonrel == 0 & fht == . & parent_n == 1 & agea >=18 & hh_depchild != 1 // R is 18+ years old, lives with one parent and if they have siblings, they are all more than 18 years old



replace fht = 5			if partner == 1 & parent == 0 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 1 & fht == . // couple with at least one dependent child 
replace fht = 5			if partner == 0 & parent == 1 & child_own == 0 & other_rel == 0 & other_nonrel == 0 & fht == . & parent_n == 2 & agea < 18 // R is less than 18 years old, lives with two parents, siblings can be present in the HH, no other relatives and non-related HH members.
replace fht = 5			if partner == 0 & parent == 1 & child_own == 0 & sibling == 1 & other_rel == 0 & other_nonrel == 0 & fht == . & parent_n == 2 & agea >= 18 & hh_depchild == 1 // R is 18+ years old, lives with two parents BUT has a sibling who is less than 18 years old



replace fht = 6 		if partner == 1 & parent == 0 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 0 & fht == . // couple with adult child/ren 
replace fht = 6 		if partner == 0 & parent == 1 & child_own == 0 & other_rel == 0 & other_nonrel == 0 & fht == . & parent_n == 2 & agea >= 18 // R is 18+ years old, lives with two parents, siblings can be present in the HH, no other relatives and non-related HH members.
replace fht = 6			if partner == 0 & parent == 1 & child_own == 0 & sibling == 1 & other_rel == 0 & other_nonrel == 0 & parent_n == 2 & agea >= 18 & hh_depchild != 1 // R is 18+ years old, lives with 2 parents and if they have a sibling, they are all more than 18 years old 



replace fht = 7 		if partner == 0 & parent == 1 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 1 & fht == . // single parent with dependent child/ren and grandparent


replace fht = 8 		if partner == 0 & parent == 1 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 0 & fht == . // single parent with adult child/ren and grandparent



replace fht = 9 		if partner == 1 & parent == 1 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 1 & fht == . // couple with dependent child/ren and grandparent



replace fht = 10 		if partner == 1 & parent == 1 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 0 & fht == . // couple with adult child/ren and grandparent



replace fht = 11 		if partner == 1 & parent == 1 & child_own == 0 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & depchild == 0 & fht == . // couple with parent/s 



replace fht = 12 		if fht == .



lab var fht "Families in Households Typology (FHT)"
lab def fht_l 1 "Single adult HH" 2 "Couples" 3 "Single parents with dependent child" 4 "Single parents with adult child" 5 "Couples with dependent children" 6 "Couples with adult children" 7 "Single parents with dependent children, grandparents" 8 "Single parents with adult children, grandparents" 9 "Couples with dependent children, grandparents" 10 "Couples with adult children, grandparents" 11 "Couples with parents" 12 "Other" 
lab val fht fht_l





