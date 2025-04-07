***********************
*** 	EQLS: FHT 	***
***********************


/*	The categories of the FHT are based on the categories we identified using EU-SILC data (see codes for EU-SILC for more detail) */

gen fht = .


* Single person HH
replace fht = 1 		if hhsize == 1 // single-person hh


* Couple HH
replace fht = 2			if hhsize == 2 & partner == 1 & fht == . // couple


* Single parent with at least one dependent child
replace fht = 3			if partner == 0 & parent == 0 & child_own == 1 & sibling == 0 & child_inlaw == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // single parent with at least one dependent child 
replace fht = 3			if partner == 0 & parent == 1 & parent_n == 1 & child_own == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // R is 18+ years old, lives with one parent and either R or their sibling is a dependent child


* Single parent with adult children
replace fht = 4 		if partner == 0 & parent == 0 & child_own == 1 & sibling == 0 & child_inlaw == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // single parent with adult child/ren 
replace fht = 4 		if partner == 0 & parent == 1 & parent_n == 1 & child_own == 0 & child_inlaw == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // R is 18+ years old and lives with one parent. Siblings can be present in the HH but they are not dependent children, no other relatives and non-related HH members. 


* Couple with at least one dependent child
replace fht = 5			if partner == 1 & parent == 0 & child_own == 1 & child_inlaw == 0 & sibling == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // couple with at least one dependent child 
replace fht = 5			if partner == 0 & parent == 1 & parent_n == 2 & child_own == 0 & child_inlaw == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & fht == . & hh_depchild == 1 // R is 18+ years old, lives with two parents - either the R or their sibling is a dependent child


* Couple with adult children
replace fht = 6 		if partner == 1 & parent == 0 & child_own == 1 & sibling == 0 & grandchild == 0 & grandparent == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // couple with adult child/ren 
replace fht = 6			if partner == 0 & parent == 1 & parent_n == 2 & child_own == 0 & grandchild == 0 & grandparent == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 // R is 18+ years old, lives with 2 parents and if they have a sibling, they are all more than 18 years old 


* Single parent with at least one dependent child and grandparent/s
replace fht = 7 		if partner == 0 & parent == 1 & child_own == 1 & child_inlaw == 0 & sibling == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // single parent with dependent child/ren and grandparent
replace fht = 7			if partner == 0 & parent == 1 & parent_n == 1 & child_own == 0 & child_inlaw == 0 & grandparent == 1 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // R is an adult child, lives with a parent, a grandparent and either R or their sibling is a dependent child
replace fht = 7 		if child_own == 1 & child_n == 1 & child_inlaw == 0 & sibling == 0 & grandchild == 1 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // R is a grandparent with one child who is also a parent and a grandchild


* Single parent with adult children and grandparent/s 
replace fht = 8 		if partner == 0 & parent == 1 & child_own == 1 & child_inlaw == 0 & sibling == 0 & grandchild == 0 & grandparent == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // single parent with adult child/ren and grandparent
replace fht = 8 		if partner == 0 & parent == 1 & parent_n == 1 & child_own == 0 & child_inlaw == 0 & grandchild == 0 & grandparent == 1 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // R is a child who lives with one of their parents and a grandparent
replace fht = 8 		if parent == 0 & child_own == 1 & child_n == 1 & child_inlaw == 0 & sibling == 0 & grandchild == 1 & grandparent == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // R is a grandparent living with one of their child (single parent), and with a grandchild


* Couple with at least one dependent child and grandparent/s
replace fht = 9 		if partner == 1 & parent == 1 & child_own == 1 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // couple with dependent child/ren and grandparent
replace fht = 9 		if partner == 0 & parent == 1 & parent_n == 2 & child_own == 0 & sibling == 1 & grandchild == 0 & grandparent == 1 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // R is a single adult living with their parents and a sibling who is a dependent child 
replace fht = 9 		if parent == 0 & child_own == 1 & child_n == 1 & child_inlaw == 1 & sibling == 0 & grandchild == 1 & grandparent == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild == 1 & fht == . // R is a grandparent living with one of their children, their partner and at least one grandchild who is dependent


* Couple with adult children and grandparent/s
replace fht = 10 		if partner == 1 & parent == 1 & child_own == 1 & child_inlaw == 0 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // couple with adult child/ren and grandparent
replace fht = 10 		if partner == 0 & parent == 1 & parent_n == 2 & child_own == 0 & child_inlaw == 0 & grandchild == 0 & grandparent == 1 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // R is a child living with both parents and a grandparent, there is no dependent child in the HH
replace fht = 10 		if parent == 0 & child_own == 1 & child_n == 1 & child_inlaw == 1 & grandchild == 1 & grandparent == 0 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // R is a grandparent living with one of their children and their partner, and at least one of grandchildren. None of the children is dependent. 


* Couple with parent/s
replace fht = 11 		if partner == 1 & parent == 1 & child_own == 0 & sibling == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // couple with parent/s 
replace fht = 11 		if parent == 0 & child_own == 1 & child_n == 1 & child_inlaw == 1 & sibling == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 0 & hh_depchild != 1 & fht == . // R is a parent who lives with one of their children and their partner


* Co-residing adults
replace fht = 12 		if partner == 0 & parent == 0 & child_own == 0 & child_inlaw == 0 & sibling == 0 & grandparent == 0 & grandchild == 0 & other_rel == 0 & other_nonrel == 1 & fht == . // coresiding unrelated individuals


* Other HH types
replace fht = 13 		if fht == .



lab var fht "Families in Households Typology (FHT)"
lab def fht_l 1 "Single adult HH" 2 "Couples" 3 "Single parents with dependent child" 4 "Single parents with adult child" 5 "Couples with dependent children" 6 "Couples with adult children" 7 "Single parents with dependent children, grandparents" 8 "Single parents with adult children, grandparents" 9 "Couples with dependent children, grandparents" 10 "Couples with adult children, grandparents" 11 "Couples with parents" 12 "Coresiding unrelated adults" 13 "Other" 
lab val fht fht_l




