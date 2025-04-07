***********************
*** HBS Unique ID's ***
***********************


* generate unique IDs for household members using YEAR, MA04 and MA05
	/*	Generates unique ID for each respondent in the survey (person_id) 
		for easier analysis of the data and housheold structure. 
		The person ID is constructed from the YEAR, household ID and position 
		of the respondent within the household. */
		
tostring (MA05), gen(pid) 
tostring (MA04), gen(hid)

* generate iso codes (ISO 3166-1 numeric)
gen str3 isonum = "."
replace isonum = "040" if COUNTRY == "AT"
replace isonum = "056" if COUNTRY == "BE"
replace isonum = "100" if COUNTRY == "BG"
replace isonum = "756" if COUNTRY == "CH"
replace isonum = "196" if COUNTRY == "CY"
replace isonum = "203" if COUNTRY == "CZ"
replace isonum = "276" if COUNTRY == "DE"
replace isonum = "208" if COUNTRY == "DK"
replace isonum = "233" if COUNTRY == "EE"
replace isonum = "300" if COUNTRY == "GR"
replace isonum = "724" if COUNTRY == "ES"
replace isonum = "246" if COUNTRY == "FI"
replace isonum = "250" if COUNTRY == "FR"
replace isonum = "191" if COUNTRY == "HR"
replace isonum = "348" if COUNTRY == "HU"
replace isonum = "372" if COUNTRY == "IE"
replace isonum = "352" if COUNTRY == "IS"
replace isonum = "380" if COUNTRY == "IT"
replace isonum = "440" if COUNTRY == "LT"
replace isonum = "442" if COUNTRY == "LU"
replace isonum = "428" if COUNTRY == "LV"
replace isonum = "470" if COUNTRY == "MT"
replace isonum = "528" if COUNTRY == "NL"
replace isonum = "578" if COUNTRY == "NO"
replace isonum = "616" if COUNTRY == "PL"
replace isonum = "620" if COUNTRY == "PT"
replace isonum = "642" if COUNTRY == "RO"
replace isonum = "752" if COUNTRY == "SE"
replace isonum = "705" if COUNTRY == "SI"
replace isonum = "703" if COUNTRY == "SK"
replace isonum = "826" if COUNTRY == "GB"


egen str13 person_id = concat(YEAR isonum hid pid)

