***********************************
*** 	DEPENDENT CHILDREN 		***
***********************************


/* 		When constructing the indicator of a dependent child, we prefer to use 
		Eurostat's definition of children who are less than 18 years old and chidlren 
		who are between 18 and 24 years old and who are in education or economically inactive.
		
		ESS doesn't collect data on economic activity of all household members. 
		We, therefore, use age as the sole defining factor of dependent children 
		as all those children who are less than 18 years old. 
	
*/ 


gen depchild = . 


foreach x of numlist 2/12 {
	
	replace depchild = 1 		if (year - yrbrn`x') < 18 // assign value 1 to all household members who are less than 18 years old

}

replace depchild = 0 	if depchild == .
