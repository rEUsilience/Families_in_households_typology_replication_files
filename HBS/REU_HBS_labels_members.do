******************
*** HBS LABELS ***
******************


*** Members level

lab var MA04 "Household ID"

lab var MB01 "Country of birth of HH member"

lab var MB011 "Country of Citizenship of HH member"

lab var MB012 "Country of Residence of the HH member"

lab var MB02 "Gender of household member(s)"
lab def MB02_l 1 "male" 2 "female" 9 "not specified"
lab val MB02 MB02_l

lab var MB04_Recoded_3Categ "Marital status of household member"
lab def MB04_Recoded_3Categ_l 1 "Never married and never in a registered partnership" 2 "Married or in a registered partnership" ///
3 "Divorced/Widowed" 9 "not specified"
lab val MB04_Recoded_3Categ MB04_Recoded_3Categ_l

lab var MB042 "Consensual union of household member"
lab def MB042_l 1 "Person living in consensual union" 2 "Person not living in consensual union" 9 "Not specified"
lab val MB042 MB042_l

lab var MB05 "Relationship"
lab def MB05_l 1 "Reference person" 2 "Spouse or partner" 3 "child of Reference person and/or of the spouse" ///
4 "parent of Reference person and/or of the spouse" 5 "other relative" 6 "no family relationship" 9 "not specified"
lab val MB05 MB05_l

lab var MC01 "Level of studies completed by the household member"
lab def MC01_l 0 "No formal education or below ISCED 1" 1 "ISCED 1-Primary education" 2 "ISCED 2 - Lower secondary education" ///
3 "ISCED 3 - Upper secondary education" 4 "ISCED 4 - Post-secondary non-tertiary education" 5 "ISCED 5 – Tertiary education first stage" ///
6 "ISCED 6 – Tertiary education second stage" 9 "not specified"
lab val MC01 MC01_l

lab var MC02 "Level of studies currently being followed by the household member"
lab def MC02_l 0 "No formal education or below ISCED 1" 1 "ISCED 1 - Primary education" 2 "ISCED 2 - Lower secondary education" ///
3 "ISCED 3 - Upper secondary education" 4 "ISCED 4 - Post-secondary non-tertiary education" 5 "ISCED 5 – Tertiary education first stage" ///
6 "ISCED 6 – Tertiary education second stage" 9 "not specified"
lab val MC02 MC02_l

lab var ME01 "Current activity status of household member"
lab def ME01_l 1 "working including with employment but temporarily absent" 2 "unemployed" ///
3 "In retirement or early retirement or has given up business" 4 "Pupil, student, further training, unpaid work experience" ///
5 "Fulfilling domestic tasks" 6 "Permanently disabled" 7 "In compulsory military or community service" ///
8 "not applicable (legal age to work unfulfilled)" 9 "not specified"
lab val ME01 ME01_l

lab var ME02 "Hours worked"
lab def ME02_l 1 "Full time" 2 "Part time" 8 "Not applicable" 9 "not specified"
lab val ME02 ME02_l

lab var ME03 "Type of work contract for the household member"
lab def ME03_l 1 "permanent job/work contract of unlimited duration" 2 "temporary job/work contract of limited duration" ///
8 "not applicable (does not work)" 9 "not specified"
lab val ME03 ME03_l

lab var ME04 "Economic sector in Employment of household member (reflecting NACE rev2)"

lab var ME12 "Status in employment household member"
lab def ME12_l 1 "employer" 2 "self employed person" 3 "employee" 4 "unpaid family worker" 5 "apprentice" 6 "persons not classified by status" ///
8 "not applicable (legal age to work unfulfilled)" 9 "not specified"
lab val ME12 ME12_l

lab var ME13 "Sector household member"
lab def ME13_l 1 "public sector employee" 2 "private sector employee" 8 "not applicable (legal age not fulfilled or not an employee)" ///
9 "not specified"
lab val ME13 ME13_l

lab var MA05 "Line number of the member of household"

lab var ME0988 "Occupation of household member (ISCO88)"

lab var ME0908_Recoded "Occupation of household member (ISCO08)"

lab var EUR_MF099 "Total income from all sources (net amount) corresponding to each single member of the family"

lab var MB03_Recoded_5YearsClasses "Age (5 year-range classes) of household member"
gen age_cat = 1 if MB03_Recoded_5YearsClasses == "0_4"
replace age_cat = 2 if MB03_Recoded_5YearsClasses == "5_9"
replace age_cat = 3 if MB03_Recoded_5YearsClasses == "10_14"
replace age_cat = 4 if MB03_Recoded_5YearsClasses == "15_19"
replace age_cat = 5 if MB03_Recoded_5YearsClasses == "20_24"
replace age_cat = 6 if MB03_Recoded_5YearsClasses == "25_29"
replace age_cat = 7 if MB03_Recoded_5YearsClasses == "30_34"
replace age_cat = 8 if MB03_Recoded_5YearsClasses == "35_39"
replace age_cat = 9 if MB03_Recoded_5YearsClasses == "40_44"
replace age_cat = 10 if MB03_Recoded_5YearsClasses == "45_49"
replace age_cat = 11 if MB03_Recoded_5YearsClasses == "50_54"
replace age_cat = 12 if MB03_Recoded_5YearsClasses == "55_59"
replace age_cat = 13 if MB03_Recoded_5YearsClasses == "60_64"
replace age_cat = 14 if MB03_Recoded_5YearsClasses == "65_69"
replace age_cat = 15 if MB03_Recoded_5YearsClasses == "70_74"
replace age_cat = 16 if MB03_Recoded_5YearsClasses == "75_79"
replace age_cat = 17 if MB03_Recoded_5YearsClasses == "80_84"
replace age_cat = 18 if MB03_Recoded_5YearsClasses == "85_Inf"
replace age_cat = . if MB03_Recoded_5YearsClasses == ".a"

lab def age_cat_l 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-29" 7 "30-34" ///
8 "35-39" 9 "40-44" 10 "45-49" 11 "50-54" 12 "55-59" 13 "60-64" 14 "65-69" 15 "70-74" ///
16 "75-79" 17 "80-84" 18 "85 and older"
lab val age_cat age_cat_l

lab var MB03_Recoded_5Classes "Age (5 classes) of household member"
gen age_cat5 = 1 if MB03_Recoded_5Classes == "0_14"
replace age_cat5 = 2 if MB03_Recoded_5Classes == "15_29"
replace age_cat5 = 3 if MB03_Recoded_5Classes == "30_44"
replace age_cat5 = 4 if MB03_Recoded_5Classes == "45_59"
replace age_cat5 = 5 if MB03_Recoded_5Classes == "60_Inf"

lab def age_cat5_l 1 "0-14" 2 "15-29" 3 "30-44" 4 "45-59" 5 "60 and older"
lab val age_cat5 age_cat5_l









 