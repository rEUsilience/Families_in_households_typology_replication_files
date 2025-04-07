***********************************
*** 	DATA COLLECTION: Year 	***
***********************************


/*		Enter year of data collection based on the ESS documentation
		(https://ess.sikt.no/en/study/412db4fe-c77a-4e98-8ea4-6c19007f551b).
		
		If data collection took place both in 2023 and 2024, we use the year
		in which the data collection was longer (e.g. when data collection took
		6 months in 2003 and one month in 2024, we use the value 2023).
		
*/

gen year = .

* set macros
local year_2023 "AT BE CY HR FI FR DE IE LT NL NO PL PT SK SI SE CH GB"
local year_2024 "CZ GR HU IS IT RS ES"

foreach x of local year_2023 {
	replace year = 2023 if cntry == "`x'" // assign value 2023 to variable year for all countries listed in "year_2023"
}

foreach x of local year_2024 {
	replace year = 2024 if cntry == "`x'" // assign value 2023 to variable year for all countries listed in "year_2024"
}
