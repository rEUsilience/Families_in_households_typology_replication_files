***************************************************
*** EQLS: Identify relations within households 	***
***************************************************

	/* 	-> based on categories of rlshp_p* variables 
		-> identifies relationship with each member of the household */ 
	

* create a variable for each category of rlshp_p# - a value of 1 or 0 is assigned to the variable if this relation is part of the HH
gen partner = .
gen parent = .
gen child_own = .
gen child_inlaw = .
gen sibling = .
gen grandchild = .
gen grandparent = .
gen other_rel = .
gen other_nonrel = .

gen hh_depchild = . // dependent child in the HH

browse pid country wave hhsize sex age empstatus partner parent child_own child_inlaw sibling grandchild grandparent other_rel other_nonrel hh_depchild rlshp_p* sex_p* age_p* empstat_p*

foreach x of numlist 2/10 { // numlist is based on the number of rlshp_p# variables
	
 	//replace rlshp_p`x' = 0 	if rlshp_p`x' == .a // recode to 0 if the response is not applicable

	replace partner = 1 if rlshp_p`x' == 1 // code partners
	replace partner = 0 if partner == . 
	
	replace child_own = 1 if rlshp_p`x' == 2 | rlshp_p`x' == 3 // code children (also includes step, adopted and foster)
	replace child_own = 0 if child_own == . 
	
	replace parent = 1 if rlshp_p`x' == 4 //  code parent
	replace parent = 0 if parent == . 
	
	replace child_inlaw = 1 if rlshp_p`x' == 5 // son- or daughter-in-law
	replace child_inlaw = 0 if child_inlaw == . 
	
	replace sibling = 1 if rlshp_p`x' == 8 //  code sibling
	replace sibling = 0 if sibling == . 
	
	replace grandchild = 1 if rlshp_p`x' == 6 // code grandchild
	replace grandchild = 0 if grandchild == . 
	
	replace grandparent = 1 if rlshp_p`x' == 7 // code grandparent
	replace grandparent = 0 if grandparent == . 
	
	replace other_rel = 1 if rlshp_p`x' == 9 // code other relative
	replace other_rel = 0 if other_rel == . 
	
	replace other_nonrel = 1 if rlshp_p`x' == 10 // code other non-related HH member
	replace other_nonrel = 0 if other_nonrel == . 

	
	
	gen partner_`x' = 1 if rlshp_p`x' == 1 // marks HH member `x' as R's partner 
	
	gen child_own_`x' = 1 if (rlshp_p`x' == 2 | rlshp_p`x' == 3) // marks HH member `x' as a R's child
	
	gen parent_`x'= 1 if rlshp_p`x' == 4 //  marks HH member `x' as R's parent 
	
	gen child_inlaw_`x' = 1 if rlshp_p`x' == 5 // 
	
	gen sibling_`x' = 1 if rlshp_p`x' == 8 //  marks HH member `x' as R's sibling
	
	gen grandchild_`x' = 1 if rlshp_p`x' == 6
	
	gen grandparent_`x' = 1 if rlshp_p`x' == 7
	
	gen other_rel_`x' = 1 if rlshp_p`x' == 9 //  marks HH member `x' as R's other relative
	
	gen other_nonrel_`x' = 1 if rlshp_p`x' == 10 //  marks HH member `x' as R's non-relative
	
	replace hh_depchild = 1 if age_p`x' < 18 // marks presence of a depedent child in the HH
	replace hh_depchild = 1 if inrange(age_p`x',18,24) & inlist(empstat_p`x',8,11,12,13) 
	
	gen inedu_`x' = 1 if empstat_p`x' == 11 
	
}

replace hh_depchild = 1 if partner == 0 & inrange(age,18,24) & inlist(empstatus,8,11,12,13)
replace hh_depchild = 0 if hh_depchild == .


* Calculate the number of each relation in the HH - this is used mainly when R is a child to identify whether they live with one or two parents
egen partner_n = rowtotal(partner_*)
egen child_n = rowtotal(child_own_*)
egen parent_n = rowtotal(parent_*)
egen child_inlaw_n = rowtotal(child_inlaw_*)
egen sibling_n = rowtotal(sibling_*)
egen grandchild_n = rowtotal(grandchild_*)
egen grandparent_n = rowtotal(grandparent_*)
egen other_rel_n = rowtotal(other_rel_*)
egen other_nonrel_n = rowtotal(other_nonrel_*)
egen inedu_n = rowtotal(inedu_*)

* Delete all respondents who are in education and co-reside with people who are not related to them and are all in education - these are dependent on their parents who live in different households 
drop if empstatus == 11 & (hhsize - 1) == inedu_n
