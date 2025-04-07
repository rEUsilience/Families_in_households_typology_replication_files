***********************************
*** 	GRANDPARENTS in HH 		***
***********************************

/*		This code only identifies whether there are any grandparents in the HH.

		It does so through identifying a respondent who co-reside with either of 
		their parent and their child. 

*/


foreach x of global wave {
	use "$DATA/silc20`x'_siblings.dta", clear

	gen gp = ((mother_id != . | father_id != .) & child1_id != .)

	egen grandparent = max(gp), by(country year hid)
	
	save "$DATA/silc20`x'_grandparent.dta", replace

}
